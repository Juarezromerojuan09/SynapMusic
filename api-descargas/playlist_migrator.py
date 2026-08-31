import subprocess
import os
import json
import asyncio
import glob
import httpx
import re

MEDIA_DIR = "/opt/synapmusic/media"


async def get_deezer_playlist_info(playlist_id: str):
    url = f"https://api.deezer.com/playlist/{playlist_id}"
    async with httpx.AsyncClient() as client:
        res = await client.get(url)
        if res.status_code == 200:
            data = res.json()
            title = data.get("title", "Deezer Playlist")
            tracks = [{"title": t["title"], "artist": t["artist"]["name"]} for t in data.get("tracks", {}).get("data", [])]
            return title, tracks
    return "Deezer Playlist", []


def get_spotify_playlist_info(url: str):
    save_file = "/tmp/temp_spotify.spotdl"
    if os.path.exists(save_file):
        os.remove(save_file)
    subprocess.run(["spotdl", "save", url, "--save-file", save_file], check=False)

    tracks = []
    if os.path.exists(save_file):
        with open(save_file, "r") as f:
            data = json.load(f)
            tracks = [{"title": t.get("name"), "artist": t.get("artist")} for t in data]
        os.remove(save_file)
    return "Spotify Playlist", tracks


async def search_jellyfin_for_track(client: httpx.AsyncClient, base_url: str, headers: dict, title: str):
    search_url = f"{base_url}/Items"
    params = {"SearchTerm": title, "IncludeItemTypes": "Audio", "Recursive": "true", "Limit": 5}
    try:
        res = await client.get(search_url, headers=headers, params=params)
        if res.status_code == 200:
            items = res.json().get("Items", [])
            if items:
                return items[0]["Id"]
    except Exception as e:
        print(f"Error buscando track en Jellyfin: {e}")
    return None


def get_media_file_set():
    """Toma una foto instantánea de todos los archivos de audio en MEDIA_DIR."""
    extensions = ("*.mp3", "*.flac", "*.ogg", "*.opus", "*.m4a", "*.wav")
    files = set()
    for ext in extensions:
        files.update(glob.glob(os.path.join(MEDIA_DIR, "**", ext), recursive=True))
    return files


async def run_rescue_phase(missing_tracks):
    """
    Fase de Rescate con verificación FÍSICA de archivos en disco usando carpetas únicas.
    """
    import uuid
    import shutil
    import glob
    from main import enrich_metadata_for_ytdlp
    
    print(f"[Migrator] Iniciando Fase de Rescate para {len(missing_tracks)} canciones...")
    for track in missing_tracks:
        query = f"{track['artist']} - {track['title']}"
        print(f"[Rescate] Intentando rescatar: {query}")

        # Intento 1: spotDL
        print("  -> Intento 1: spotDL")
        spotdl_tmp = os.path.join(MEDIA_DIR, f".spotdl_tmp_{uuid.uuid4().hex[:6]}")
        os.makedirs(spotdl_tmp, exist_ok=True)
        
        subprocess.run(
            ["spotdl", "download", query,
             "--output", f"{spotdl_tmp}/{{artist}} - {{title}}.{{output-ext}}",
             "--generate-lrc"],
            capture_output=True
        )

        new_files = glob.glob(f"{spotdl_tmp}/*")

        if new_files:
            for tmp_f in new_files:
                dest = os.path.join(MEDIA_DIR, os.path.basename(tmp_f))
                if os.path.exists(dest):
                    os.remove(dest)
                shutil.move(tmp_f, dest)
            print(f"  -> Rescatado con spotDL. Archivo: {os.path.basename(list(new_files)[0])}")
        else:
            print("  -> spotDL NO generó archivo. Intento 2: yt-dlp (android client)")

            ytdlp_tmp = os.path.join(MEDIA_DIR, f".ytdlp_tmp_{uuid.uuid4().hex[:6]}")
            os.makedirs(ytdlp_tmp, exist_ok=True)
            
            env = os.environ.copy()
            deno_path = os.path.expanduser("~/.deno/bin")
            if deno_path not in env.get("PATH", ""):
                env["PATH"] = deno_path + ":" + env.get("PATH", "")
            
            clean_q = query.replace('"', '').replace("'", "")
            ytdlp_cmd = [
                "yt-dlp",
                "-x", "--audio-format", "mp3", "--audio-quality", "0",
                "--extractor-args", "youtube:player_client=android",
                "--write-thumbnail",
                "-o", f"{ytdlp_tmp}/{track['artist']} - {track['title']}.%(ext)s",
                f"ytsearch1:{clean_q} audio"
            ]
            
            subprocess.run(ytdlp_cmd, check=False, env=env)
            
            mp3_files = glob.glob(f"{ytdlp_tmp}/*.mp3")
            if mp3_files:
                file_path = mp3_files[0]
                print(f"  -> Rescatado con yt-dlp. Archivo: {os.path.basename(file_path)}")
                try:
                    enrich_metadata_for_ytdlp(file_path, query)
                except Exception as e:
                    print(f"  [!] Error global en enrich_metadata: {e}")
                    
                base_name = os.path.splitext(os.path.basename(file_path))[0]
                for tmp_f in glob.glob(f"{ytdlp_tmp}/{base_name}.*"):
                    if tmp_f.endswith('.mp3') or tmp_f.endswith('.lrc'):
                        dest = os.path.join(MEDIA_DIR, os.path.basename(tmp_f))
                        if os.path.exists(dest):
                            os.remove(dest)
                        shutil.move(tmp_f, dest)
            else:
                print(f"  -> FALLO TOTAL: Ni spotDL ni yt-dlp pudieron descargar: {query}")
                
            shutil.rmtree(ytdlp_tmp, ignore_errors=True)
            
            import random
            sleep_time = random.uniform(5.0, 8.0)
            print(f"  -> [Anti-Bot] Enfriando conexión por {sleep_time:.1f} segundos...")
            import time
            time.sleep(sleep_time)
            
        shutil.rmtree(spotdl_tmp, ignore_errors=True)

    # Ajustar permisos para que Jellyfin pueda leer los archivos nuevos
    subprocess.run(["chmod", "-R", "755", MEDIA_DIR])


async def run_migration_task(url: str, user_id: str, jellyfin_url: str, jellyfin_api_key: str):
    print(f"[Migrator] Iniciando migración en Cascada Inteligente: {url}")
    title = "Migrated Playlist"
    tracks = []

    # 1. Extraer metadatos originales
    if "deezer" in url:
        match = re.search(r'playlist/(\d+)', url)
        if match:
            title, tracks = await get_deezer_playlist_info(match.group(1))
    elif "spotify" in url:
        title, tracks = get_spotify_playlist_info(url)

    if not tracks:
        print("[Migrator] Error: No se encontraron tracks en los metadatos. Cancelando.")
        return

    # 2. Descarga Principal (Motor Primario)
    print(f"[Migrator] Descarga Principal Iniciada ({len(tracks)} tracks)...")
    if "deezer" in url:
        subprocess.run(["deemix", "--bitrate", "320", "-p", MEDIA_DIR, url])
    else:
        subprocess.run(["spotdl", "download", url,
                         "--output", f"{MEDIA_DIR}/{{artist}} - {{title}}.{{output-ext}}",
                         "--generate-lrc"])

    subprocess.run(["chmod", "-R", "755", MEDIA_DIR])

    async with httpx.AsyncClient() as client:
        headers = {"X-Emby-Token": jellyfin_api_key, "Content-Type": "application/json"}
        base_url = jellyfin_url.rstrip('/')

        # Crear Playlist en Jellyfin
        res = await client.post(f"{base_url}/Playlists", headers=headers,
                                params={"Name": title, "UserId": user_id, "MediaType": "Audio"})
        if res.status_code != 200:
            print("[Migrator] Fallo crítico al crear la playlist vacía en Jellyfin.")
            return

        playlist_id = res.json().get("Id")

        # 3. Primer Indexado y Mapeo
        print("[Migrator] Solicitando refresh primario de biblioteca...")
        try:
            await client.post(f"{base_url}/Library/Refresh", headers=headers)
        except Exception:
            pass

        print("[Migrator] Esperando 15 segundos para indexación inicial...")
        await asyncio.sleep(15)

        found_ids = []
        missing_tracks_list = []

        print(f"[Migrator] Evaluando {len(tracks)} tracks originales descargados...")
        for track in tracks:
            track_id = await search_jellyfin_for_track(client, base_url, headers, track['title'])
            if track_id:
                found_ids.append(track_id)
            else:
                missing_tracks_list.append(track)

        # 4. Consolidación Primaria (Meter lo que sí se descargó rápido)
        if found_ids:
            ids_str = ",".join(found_ids)
            try:
                res = await client.post(f"{base_url}/Playlists/{playlist_id}/Items",
                                        headers=headers,
                                        params={"Ids": ids_str, "userId": user_id})
                res.raise_for_status()
                print(f"[Migrator] Playlist '{title}' poblada inicialmente con {len(found_ids)}/{len(tracks)} canciones. (Rápido)")
            except Exception as e:
                print(f"[Migrator] Error añadiendo tracks iniciales a la playlist: {e}")

        # 5. FASE DE RESCATE (Fallback con verificación física en background virtual)
        if missing_tracks_list:
            print(f"[Migrator] ¡Alerta! {len(missing_tracks_list)} canciones perdidas. Entrando en Cascada de Rescate Lenta.")
            await run_rescue_phase(missing_tracks_list)

            # Segundo Indexado exclusivo para los rescatados
            print("[Migrator] Solicitando refresh secundario de rescate...")
            try:
                await client.post(f"{base_url}/Library/Refresh", headers=headers)
            except Exception:
                pass

            print("[Migrator] Esperando 15 segundos para indexación de rescate...")
            await asyncio.sleep(15)

            rescued_ids = []
            # Volver a buscar solo los que faltaban
            for track in missing_tracks_list:
                track_id = await search_jellyfin_for_track(client, base_url, headers, track['title'])
                if track_id:
                    rescued_ids.append(track_id)
                    print(f"[Migrator] ¡Canción integrada tras rescate!: {track['title']}")
                else:
                    print(f"[Migrator] Imposible rescatar, ignorando: {track['title']}")
            
            # 6. Consolidación Secundaria (Añadir rescatados a la misma playlist)
            if rescued_ids:
                ids_str = ",".join(rescued_ids)
                try:
                    res = await client.post(f"{base_url}/Playlists/{playlist_id}/Items",
                                            headers=headers,
                                            params={"Ids": ids_str, "userId": user_id})
                    res.raise_for_status()
                    print(f"[Migrator] Playlist '{title}' actualizada con {len(rescued_ids)} canciones rescatadas. TOTAL: {len(found_ids) + len(rescued_ids)}/{len(tracks)}")
                except Exception as e:
                    print(f"[Migrator] Error añadiendo tracks rescatados a la playlist: {e}")
        else:
            print(f"[Migrator] Migración perfecta sin rescates. 100% de éxito en fase 1.")

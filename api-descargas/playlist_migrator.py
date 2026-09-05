import subprocess
import os
import json
import asyncio
import glob
import httpx
import re

MEDIA_DIR = "/opt/synapmusic/media"


def patch_deemix_libraries():
    """
    Parchea automáticamente deezer-py y deemix para solucionar:
    1. IndexError: list index out of range en deezer/utils.py (track['MEDIA'][0]['HREF'])
    2. KeyError: 'explicit_lyrics' en deemix/itemgen.py (trackAPI['explicit_lyrics'])
    """
    import sys
    import glob

    # --- 1. deezer/utils.py ---
    deezer_candidates = set()
    try:
        import deezer.utils
        if hasattr(deezer.utils, '__file__') and deezer.utils.__file__:
            deezer_candidates.add(os.path.abspath(deezer.utils.__file__))
    except Exception:
        pass

    for p in sys.path:
        target = os.path.abspath(os.path.join(p, "deezer", "utils.py"))
        if os.path.isfile(target):
            deezer_candidates.add(target)

    try:
        venv_root = os.path.dirname(os.path.dirname(sys.executable))
        for f in glob.glob(os.path.join(venv_root, "**", "deezer", "utils.py"), recursive=True):
            if os.path.isfile(f):
                deezer_candidates.add(os.path.abspath(f))
    except Exception:
        pass

    fixed_deezer_paths = [
        "/home/juarezromerojuan09/api-descargas/venv/lib64/python3.13/site-packages/deezer/utils.py",
        "/home/juarezromerojuan09/api-descargas/venv/lib/python3.13/site-packages/deezer/utils.py",
    ]
    for fp in fixed_deezer_paths:
        if os.path.isfile(fp):
            deezer_candidates.add(os.path.abspath(fp))

    safe_preview = "result['preview'] = track['MEDIA'][0]['HREF'] if track.get('MEDIA') and len(track['MEDIA']) > 0 else None"
    pattern_preview = re.compile(r"result\s*\[\s*['\"]preview['\"]\s*\]\s*=\s*track\s*\[\s*['\"]MEDIA['\"]\s*\]\s*\[\s*0\s*\]\s*\[\s*['\"]HREF['\"]\s*\]")

    for path in deezer_candidates:
        try:
            with open(path, "r", encoding="utf-8") as f:
                code = f.read()

            changed = False
            if pattern_preview.search(code):
                code = pattern_preview.sub(safe_preview, code)
                changed = True

            if "'explicit_lyrics': False" not in code and "'track_token_expire': track['TRACK_TOKEN_EXPIRE']" in code:
                code = code.replace(
                    "'track_token_expire': track['TRACK_TOKEN_EXPIRE']",
                    "'track_token_expire': track['TRACK_TOKEN_EXPIRE'],\n        'explicit_lyrics': False"
                )
                changed = True

            if changed:
                with open(path, "w", encoding="utf-8") as f:
                    f.write(code)
                print(f"[Auto-Patch Deezer] Corregido satisfactoriamente en: {path}")
            else:
                print(f"[Auto-Patch Deezer] Verificado: {path} ya cuenta con el parche.")
        except Exception as e:
            print(f"[Auto-Patch Deezer] Error al inspeccionar/parchear {path}: {e}")

    # --- 2. deemix/itemgen.py ---
    deemix_candidates = set()
    try:
        import deemix.itemgen
        if hasattr(deemix.itemgen, '__file__') and deemix.itemgen.__file__:
            deemix_candidates.add(os.path.abspath(deemix.itemgen.__file__))
    except (Exception, BaseException):
        pass

    for p in sys.path:
        target = os.path.abspath(os.path.join(p, "deemix", "itemgen.py"))
        if os.path.isfile(target):
            deemix_candidates.add(target)

    try:
        venv_root = os.path.dirname(os.path.dirname(sys.executable))
        for f in glob.glob(os.path.join(venv_root, "**", "deemix", "itemgen.py"), recursive=True):
            if os.path.isfile(f):
                deemix_candidates.add(os.path.abspath(f))
    except Exception:
        pass

    fixed_deemix_paths = [
        "/home/juarezromerojuan09/api-descargas/venv/lib64/python3.13/site-packages/deemix/itemgen.py",
        "/home/juarezromerojuan09/api-descargas/venv/lib/python3.13/site-packages/deemix/itemgen.py",
    ]
    for fp in fixed_deemix_paths:
        if os.path.isfile(fp):
            deemix_candidates.add(os.path.abspath(fp))

    gen_pattern = re.compile(r"(\w+)\s*\[\s*['\"]explicit_lyrics['\"]\s*\]")
    gen_replace = r"\1.get('explicit_lyrics', False)"

    for path in deemix_candidates:
        try:
            with open(path, "r", encoding="utf-8") as f:
                code = f.read()

            changed = False
            # Limpiar posibles barras invertidas escapadas erróneamente (\'explicit_lyrics\')
            if chr(92) + chr(39) in code:
                code = code.replace(chr(92) + chr(39), chr(39))
                changed = True
            if chr(92) + chr(34) in code:
                code = code.replace(chr(92) + chr(34), chr(34))
                changed = True

            # Corregir accesos directos inseguros
            if gen_pattern.search(code):
                code = gen_pattern.sub(gen_replace, code)
                changed = True

            if changed:
                with open(path, "w", encoding="utf-8") as f:
                    f.write(code)
                print(f"[Auto-Patch Deemix] Corregido satisfactoriamente en: {path}")
            elif ".get('explicit_lyrics', False)" in code:
                print(f"[Auto-Patch Deemix] Verificado: {path} ya cuenta con el parche.")
        except Exception as e:
            print(f"[Auto-Patch Deemix] Error al inspeccionar/parchear {path}: {e}")

    # --- 3. deemix/utils/pathtemplates.py ---
    pathtemplates_candidates = set()
    try:
        import deemix.utils.pathtemplates
        if hasattr(deemix.utils.pathtemplates, '__file__') and deemix.utils.pathtemplates.__file__:
            pathtemplates_candidates.add(os.path.abspath(deemix.utils.pathtemplates.__file__))
    except (Exception, BaseException):
        pass

    for p in sys.path:
        target = os.path.abspath(os.path.join(p, "deemix", "utils", "pathtemplates.py"))
        if os.path.isfile(target):
            pathtemplates_candidates.add(target)

    try:
        venv_root = os.path.dirname(os.path.dirname(sys.executable))
        for f in glob.glob(os.path.join(venv_root, "**", "deemix", "utils", "pathtemplates.py"), recursive=True):
            if os.path.isfile(f):
                pathtemplates_candidates.add(os.path.abspath(f))
    except Exception:
        pass

    fixed_pathtemplates = [
        "/home/juarezromerojuan09/api-descargas/venv/lib64/python3.13/site-packages/deemix/utils/pathtemplates.py",
        "/home/juarezromerojuan09/api-descargas/venv/lib/python3.13/site-packages/deemix/utils/pathtemplates.py",
    ]
    for fp in fixed_pathtemplates:
        if os.path.isfile(fp):
            pathtemplates_candidates.add(os.path.abspath(fp))

    for path in pathtemplates_candidates:
        try:
            with open(path, "r", encoding="utf-8") as f:
                code = f.read()

            changed = False
            if 'filename.replace("%upc%", track.album.barcode)' in code:
                code = code.replace(
                    'filename.replace("%upc%", track.album.barcode)',
                    'filename.replace("%upc%", str(track.album.barcode or ""))'
                )
                changed = True
            if 'filename.replace("%isrc%", track.ISRC)' in code:
                code = code.replace(
                    'filename.replace("%isrc%", track.ISRC)',
                    'filename.replace("%isrc%", str(track.ISRC or ""))'
                )
                changed = True

            if changed:
                with open(path, "w", encoding="utf-8") as f:
                    f.write(code)
                print(f"[Auto-Patch Deemix] Corregido TypeError de barcode en: {path}")
            elif 'track.album.barcode or ""' in code:
                print(f"[Auto-Patch Deemix] Verificado: {path} ya cuenta con el parche de barcode.")
        except Exception as e:
            print(f"[Auto-Patch Deemix] Error al inspeccionar/parchear {path}: {e}")

# Alias para compatibilidad
patch_deezer_utils = patch_deemix_libraries

# Ejecutar parche al cargar el módulo
patch_deemix_libraries()


def get_deemix_binary():
    """Obtiene la ruta al binario deemix en venv o PATH."""
    import sys
    import shutil
    venv_deemix = os.path.join(os.path.dirname(sys.executable), "deemix")
    if os.path.isfile(venv_deemix) and os.access(venv_deemix, os.X_OK):
        return venv_deemix
    which_path = shutil.which("deemix")
    if which_path:
        return which_path
    server_path = "/home/juarezromerojuan09/api-descargas/venv/bin/deemix"
    if os.path.isfile(server_path) and os.access(server_path, os.X_OK):
        return server_path
    return "deemix"


async def get_deezer_playlist_info(playlist_id: str):
    url = f"https://api.deezer.com/playlist/{playlist_id}"
    async with httpx.AsyncClient(timeout=30.0) as client:
        try:
            res = await client.get(url)
            if res.status_code == 200:
                data = res.json()
                playlist_title = data.get("title", "Deezer Playlist")
                nb_tracks = data.get("nb_tracks", 0)
                tracks_obj = data.get("tracks", {})
                raw_tracks = list(tracks_obj.get("data", []))

                # Si la playlist tiene más canciones que el tope de 400 devuelto en la raíz:
                # El endpoint dedicado /playlist/{id}/tracks permite paginar hasta el total real
                current_index = len(raw_tracks)
                while current_index < nb_tracks:
                    page_url = f"https://api.deezer.com/playlist/{playlist_id}/tracks?limit=100&index={current_index}"
                    try:
                        p_res = await client.get(page_url)
                        if p_res.status_code == 200:
                            p_data = p_res.json()
                            batch = p_data.get("data", [])
                            if not batch:
                                break
                            raw_tracks.extend(batch)
                            current_index += len(batch)
                            if not p_data.get("next") and current_index >= p_data.get("total", nb_tracks):
                                break
                        else:
                            break
                    except Exception as e:
                        print(f"[Migrator] Error obteniendo tracks de Deezer en index {current_index}: {e}")
                        break

                tracks = []
                for t in raw_tracks:
                    if not isinstance(t, dict):
                        continue
                    t_title = t.get("title")
                    art_obj = t.get("artist")
                    t_artist = art_obj.get("name") if isinstance(art_obj, dict) else "Unknown Artist"
                    if t_title:
                        tracks.append({
                            "title": t_title,
                            "artist": t_artist or "Unknown Artist",
                            "id": t.get("id"),
                            "link": t.get("link")
                        })
                print(f"[Migrator] Deezer playlist obtenida: '{playlist_title}' con {len(tracks)} canciones (Total en Deezer: {nb_tracks}).")
                return playlist_title, tracks
        except Exception as e:
            print(f"[Migrator] Error consultando API de Deezer: {e}")
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


async def search_jellyfin_for_track(client: httpx.AsyncClient, base_url: str, headers: dict, title: str, artist: str = ""):
    search_url = f"{base_url}/Items"
    
    # 1. Búsqueda directa por título
    params = {"SearchTerm": title, "IncludeItemTypes": "Audio", "Recursive": "true", "Limit": 10}
    try:
        res = await client.get(search_url, headers=headers, params=params)
        if res.status_code == 200:
            items = res.json().get("Items", [])
            if items:
                if artist:
                    for it in items:
                        artists_list = it.get("Artists", [])
                        album_artist = it.get("AlbumArtist", "")
                        combined = (" ".join(artists_list) + " " + album_artist).lower()
                        if artist.lower() in combined or combined in artist.lower():
                            return it["Id"]
                return items[0]["Id"]
    except Exception as e:
        print(f"Error buscando track en Jellyfin: {e}")

    # 2. Búsqueda con título limpio (remover '(feat. ...)', '[remaster]', etc.)
    clean_title = re.sub(r'[\(\[].*?[\)\]]', '', title).strip()
    if clean_title and clean_title != title:
        try:
            params["SearchTerm"] = clean_title
            res = await client.get(search_url, headers=headers, params=params)
            if res.status_code == 200:
                items = res.json().get("Items", [])
                if items:
                    if artist:
                        for it in items:
                            artists_list = it.get("Artists", [])
                            album_artist = it.get("AlbumArtist", "")
                            combined = (" ".join(artists_list) + " " + album_artist).lower()
                            if artist.lower() in combined or combined in artist.lower():
                                return it["Id"]
                    return items[0]["Id"]
        except Exception:
            pass

    # 3. Búsqueda combinada artista + título limpio
    if artist and clean_title:
        try:
            params["SearchTerm"] = f"{artist} {clean_title}"
            res = await client.get(search_url, headers=headers, params=params)
            if res.status_code == 200:
                items = res.json().get("Items", [])
                if items:
                    return items[0]["Id"]
        except Exception:
            pass

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
        patch_deezer_utils()
        deemix_bin = get_deemix_binary()
        print(f"[Migrator] Ejecutando {deemix_bin} --bitrate 320 -p {MEDIA_DIR} {url}")
        res_deemix = subprocess.run([deemix_bin, "--bitrate", "320", "-p", MEDIA_DIR, url])
        print(f"[Migrator] Deemix completó con código: {res_deemix.returncode}")
    else:
        subprocess.run(["spotdl", "download", url,
                         "--output", f"{MEDIA_DIR}/{{artist}} - {{title}}.{{output-ext}}",
                         "--generate-lrc"])

    subprocess.run(["chmod", "-R", "755", MEDIA_DIR])

    async with httpx.AsyncClient() as client:
        headers = {"X-Emby-Token": jellyfin_api_key, "Content-Type": "application/json"}
        base_url = jellyfin_url.rstrip('/')

        # Buscar si ya existe una playlist con este nombre para evitar duplicados
        playlist_id = None
        existing_track_ids = set()
        try:
            pl_search = await client.get(
                f"{base_url}/Users/{user_id}/Items",
                headers=headers,
                params={"IncludeItemTypes": "Playlist", "Recursive": "true"}
            )
            if pl_search.status_code == 200:
                user_playlists = pl_search.json().get("Items", [])
                for pl in user_playlists:
                    if pl.get("Name", "").strip().lower() == title.strip().lower():
                        playlist_id = pl["Id"]
                        print(f"[Migrator] Playlist existente encontrada en Jellyfin '{title}' (ID: {playlist_id}). Se reutilizará.")
                        try:
                            items_res = await client.get(
                                f"{base_url}/Playlists/{playlist_id}/Items",
                                headers=headers,
                                params={"UserId": user_id}
                            )
                            if items_res.status_code == 200:
                                for it in items_res.json().get("Items", []):
                                    existing_track_ids.add(it["Id"])
                                print(f"[Migrator] La playlist existente ya cuenta con {len(existing_track_ids)} canciones.")
                        except Exception:
                            pass
                        break
        except Exception as e:
            print(f"[Migrator] Error buscando playlists existentes: {e}")

        # Si no existe, crearla
        if not playlist_id:
            res = await client.post(f"{base_url}/Playlists", headers=headers,
                                    params={"Name": title, "UserId": user_id, "MediaType": "Audio"})
            if res.status_code != 200:
                print("[Migrator] Fallo crítico al crear la playlist vacía en Jellyfin.")
                return
            playlist_id = res.json().get("Id")
            print(f"[Migrator] Creada nueva playlist en Jellyfin '{title}' (ID: {playlist_id}).")

        # 3. Primer Indexado y Mapeo
        print("[Migrator] Solicitando refresh primario de biblioteca a Jellyfin...")
        try:
            await client.post(f"{base_url}/Library/Refresh", headers=headers)
        except Exception as e:
            print(f"[Migrator] Error solicitando refresh a Jellyfin: {e}")

        # Tiempo prudente para indexar archivos en Jellyfin (mínimo 15s, máx 45s)
        wait_time = min(45, max(15, len(tracks) // 15))
        print(f"[Migrator] Esperando {wait_time} segundos para indexación inicial...")
        await asyncio.sleep(wait_time)

        found_ids = []
        missing_tracks_list = []

        print(f"[Migrator] Evaluando {len(tracks)} tracks originales descargados...")
        for track in tracks:
            track_id = await search_jellyfin_for_track(client, base_url, headers, track['title'], track.get('artist', ''))
            if track_id:
                found_ids.append(track_id)
            else:
                missing_tracks_list.append(track)

        # Si aún faltan pistas pero Jellyfin pudo haber indexado parcialmente, re-intentar tras 15 segundos
        if missing_tracks_list and found_ids and len(missing_tracks_list) > 5:
            print(f"[Migrator] {len(found_ids)} indexadas, {len(missing_tracks_list)} pendientes. Esperando 15s extra para que Jellyfin complete el escaneo...")
            await asyncio.sleep(15)
            still_missing = []
            for track in missing_tracks_list:
                track_id = await search_jellyfin_for_track(client, base_url, headers, track['title'], track.get('artist', ''))
                if track_id:
                    found_ids.append(track_id)
                else:
                    still_missing.append(track)
            missing_tracks_list = still_missing

        # 4. Consolidación Primaria (Añadir en lotes de 100 para evitar URI Too Long)
        new_ids_to_add = [fid for fid in found_ids if fid not in existing_track_ids]
        if new_ids_to_add:
            chunk_size = 100
            for i in range(0, len(new_ids_to_add), chunk_size):
                chunk = new_ids_to_add[i:i + chunk_size]
                ids_str = ",".join(chunk)
                try:
                    res = await client.post(f"{base_url}/Playlists/{playlist_id}/Items",
                                            headers=headers,
                                            params={"Ids": ids_str, "userId": user_id})
                    res.raise_for_status()
                except Exception as e:
                    print(f"[Migrator] Error añadiendo bloque {i}-{i+len(chunk)} a playlist: {e}")
            existing_track_ids.update(new_ids_to_add)
            print(f"[Migrator] Playlist '{title}' poblada con éxito con {len(new_ids_to_add)} canciones nuevas (Total: {len(existing_track_ids)}).")
        else:
            print(f"[Migrator] Las canciones encontradas ya estaban en la playlist '{title}'.")

        # 5. FASE DE RESCATE (Fallback con verificación física en background virtual)
        if missing_tracks_list:
            print(f"[Migrator] ¡Alerta! {len(missing_tracks_list)} canciones perdidas. Entrando en Cascada de Rescate Lenta.")
            await run_rescue_phase(missing_tracks_list)

            # Segundo Indexado exclusivo para los rescatados
            print("[Migrator] Solicitando refresh secundario de rescate a Jellyfin...")
            try:
                await client.post(f"{base_url}/Library/Refresh", headers=headers)
            except Exception:
                pass

            print("[Migrator] Esperando 15 segundos para indexación de rescate...")
            await asyncio.sleep(15)

            rescued_ids = []
            for track in missing_tracks_list:
                track_id = await search_jellyfin_for_track(client, base_url, headers, track['title'], track.get('artist', ''))
                if track_id:
                    rescued_ids.append(track_id)
                    print(f"[Migrator] ¡Canción integrada tras rescate!: {track['title']}")
                else:
                    print(f"[Migrator] Imposible rescatar, ignorando: {track['title']}")
            
            # 6. Consolidación Secundaria (Añadir rescatados a la misma playlist)
            new_rescued_ids = [rid for rid in rescued_ids if rid not in existing_track_ids]
            if new_rescued_ids:
                chunk_size = 100
                for i in range(0, len(new_rescued_ids), chunk_size):
                    chunk = new_rescued_ids[i:i + chunk_size]
                    ids_str = ",".join(chunk)
                    try:
                        res = await client.post(f"{base_url}/Playlists/{playlist_id}/Items",
                                                headers=headers,
                                                params={"Ids": ids_str, "userId": user_id})
                        res.raise_for_status()
                    except Exception as e:
                        print(f"[Migrator] Error añadiendo bloque de rescate a la playlist: {e}")
                existing_track_ids.update(new_rescued_ids)
                print(f"[Migrator] Playlist '{title}' actualizada con {len(new_rescued_ids)} canciones rescatadas. TOTAL: {len(existing_track_ids)}/{len(tracks)}")
        else:
            print(f"[Migrator] Migración perfecta sin rescates. 100% de éxito en fase 1.")


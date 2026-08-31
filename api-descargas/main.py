import os
import asyncio
import httpx
import requests
import subprocess
from fastapi import FastAPI, Depends, HTTPException, Security, BackgroundTasks
from playlist_migrator import run_migration_task
from fastapi.security import APIKeyHeader
from pydantic import BaseModel
from dotenv import load_dotenv
from typing import List, Optional

# Cargar variables de entorno desde .env
load_dotenv()

API_KEY = os.getenv("API_KEY", "default_secret_key")
MEDIA_DIR = "/opt/synapmusic/media"  # Restaurado a ruta absoluta obligatoria
JELLYFIN_URL = os.getenv("JELLYFIN_URL", "http://localhost:8096")
JELLYFIN_API_KEY = os.getenv("JELLYFIN_API_KEY", "")
DEEZER_ARL = os.getenv("DEEZER_ARL", "")

def setup_deemix():
    """Configura el entorno de Deemix inyectando ARL y config.json."""
    if not DEEZER_ARL:
        print("Advertencia: DEEZER_ARL no configurada. Deemix fallará.")
        return
        
    import json
    deemix_config_dir = os.path.expanduser("~/.config/deemix")
    os.makedirs(deemix_config_dir, exist_ok=True)
    
    # Escribir el ARL
    with open(os.path.join(deemix_config_dir, ".arl"), "w") as f:
        f.write(DEEZER_ARL)
        
    # Escribir la configuración en formato plano (flat)
    # Escribir la configuración en formato plano (flat)
    config_data = {
        "downloadLocation": MEDIA_DIR,
        "tracknameTemplate": "%artist% - %title%",
        "albumTrackTemplate": "%artist% - %title%",
        "createM3U8File": False,
        "createArtistFolder": False,
        "createAlbumFolder": False,
        "createPlaylistFolder": False,
        "saveLyrics": True,
        "lyricsPosition": "folder",
        "saveSyncedLyrics": True
    }
    
    with open(os.path.join(deemix_config_dir, "config.json"), "w") as f:
        json.dump(config_data, f, indent=4)
        
    print("Deemix ARL y config.json configurados correctamente para estructura plana.")

# Inicializar configuración de deemix
setup_deemix()

app = FastAPI(
    title="SynapMusic - API de Descargas",
    description="API puente para descargar música usando spotDL y actualizar Jellyfin.",
    version="1.0.0"
)

api_key_header = APIKeyHeader(name="X-API-Key", auto_error=True)

def get_api_key(api_key_header: str = Security(api_key_header)):
    if api_key_header != API_KEY:
        raise HTTPException(
            status_code=403,
            detail="Could not validate credentials",
        )
    return api_key_header

class DownloadRequest(BaseModel):
    query: str  # Puede ser un link de Spotify o un término de búsqueda

class BulkDownloadRequest(BaseModel):
    queries: List[str]

class MigrationRequest(BaseModel):
    url: str
    user_id: str

class PlaylistCreateRequest(BaseModel):
    name: str
    user_id: str | None = None

async def update_jellyfin_library():
    """Llama a la API de Jellyfin para escanear la biblioteca."""
    if not JELLYFIN_API_KEY:
        print("Advertencia: JELLYFIN_API_KEY no configurada. Saltando actualización.")
        return
        
    url = f"{JELLYFIN_URL.rstrip('/')}/Library/Refresh"
    headers = {
        "X-Emby-Token": JELLYFIN_API_KEY,
        "Content-Type": "application/json"
    }
    
    async with httpx.AsyncClient() as client:
        try:
            response = await client.post(url, headers=headers)
            response.raise_for_status()
            await asyncio.sleep(2)
            print("Biblioteca de Jellyfin actualizada correctamente.")
        except httpx.HTTPError as e:
            print(f"Error al actualizar la biblioteca de Jellyfin: {e}")

@app.post("/download", dependencies=[Depends(get_api_key)])
async def download_music(request: DownloadRequest, background_tasks: BackgroundTasks):
    """
    Recibe una petición de descarga y la encola en segundo plano.
    """
    background_tasks.add_task(run_dual_download, [request.query])
    return {
        "status": "success",
        "message": f"Descarga de '{request.query}' iniciada en segundo plano."
    }


def clean_title(title):
    import re
    # Quitar palabras entre parentesis o corchetes que contengan official, video, audio, lyric, live, cover
    cleaned = re.sub(r'[\(\[][^\)\]]*(official|video|audio|lyric|live|cover|hd|hq|1080p|4k)[^\)\]]*[\)\]]', '', title, flags=re.IGNORECASE)
    cleaned = re.sub(r'(official music video|official video|official audio|lyric video|music video)', '', cleaned, flags=re.IGNORECASE)
    # Limpiar guiones o espacios multiples
    cleaned = re.sub(r'\s+', ' ', cleaned)
    return cleaned.strip()

def enrich_metadata_for_ytdlp(file_path, original_query):
    print(f"  [Metadatos] Iniciando enriquecimiento para: {os.path.basename(file_path)}")
    clean = clean_title(original_query)
    
    cover_bytes = None
    try:
        import requests
        dz_res = requests.get("https://api.deezer.com/search/track", params={"q": clean, "limit": 1}, timeout=5)
        if dz_res.status_code == 200:
            dz_data = dz_res.json().get("data", [])
            if dz_data:
                cover_url = dz_data[0].get("album", {}).get("cover_xl")
                if cover_url:
                    cover_bytes = requests.get(cover_url, timeout=5).content
                    print("  ✓ Portada obtenida desde Deezer")
    except Exception as e:
        print(f"  [!] Error buscando portada en deezer: {e}")

    if not cover_bytes:
        import glob
        base_name = os.path.splitext(file_path)[0]
        thumbs = glob.glob(f"{base_name}.*")
        thumb_file = None
        for t in thumbs:
            if t != file_path and (t.endswith(".jpg") or t.endswith(".webp") or t.endswith(".png")):
                thumb_file = t
                break
        
        if thumb_file:
            try:
                from PIL import Image
                import io
                with Image.open(thumb_file) as img:
                    width, height = img.size
                    new_size = min(width, height)
                    left = (width - new_size)/2
                    top = (height - new_size)/2
                    right = (width + new_size)/2
                    bottom = (height + new_size)/2
                    img_cropped = img.crop((left, top, right, bottom))
                    img_cropped = img_cropped.convert("RGB")
                    b = io.BytesIO()
                    img_cropped.save(b, format="JPEG")
                    cover_bytes = b.getvalue()
                os.remove(thumb_file)
                print("  ✓ Portada rescatada y recortada desde miniatura de YouTube")
            except Exception as e:
                print(f"  [!] Error procesando miniatura de YT: {e}")

    try:
        from mutagen.mp3 import MP3
        from mutagen.id3 import ID3, APIC, TXXX, error
        audio = MP3(file_path, ID3=ID3)
        try:
            audio.add_tags()
        except error:
            pass
            
        filename = os.path.basename(file_path)
        name_without_ext = os.path.splitext(filename)[0]
        parts = name_without_ext.split(" - ", 1)
        if len(parts) == 2:
            artist_text = parts[0].strip()
            title_text = parts[1].strip()
        else:
            artist_text = "Unknown Artist"
            title_text = name_without_ext.strip()
            
        from mutagen.id3 import TIT2, TPE1, TALB
        audio.tags.add(TIT2(encoding=3, text=[title_text]))
        audio.tags.add(TPE1(encoding=3, text=[artist_text]))
        audio.tags.add(TALB(encoding=3, text=[title_text]))
            
        if cover_bytes:
            audio.tags.add(
                APIC(
                    encoding=3,
                    mime='image/jpeg',
                    type=3, # front cover
                    desc='Cover',
                    data=cover_bytes
                )
            )
            
        audio.tags.add(
            TXXX(
                encoding=3,
                desc='synap_source',
                text=['youtube']
            )
        )
        audio.save(v2_version=3)
    except Exception as e:
        print(f"  [!] Error inyectando metadatos MP3: {e}")

    # Letras (Estrategia Dual)
    def fetch_lyrics(q):
        try:
            import requests
            res = requests.get("https://lrclib.net/api/search", params={"q": q}, timeout=5)
            if res.status_code == 200:
                data = res.json()
                if data and isinstance(data, list) and len(data) > 0:
                    best = data[0]
                    return best.get("syncedLyrics") or best.get("plainLyrics")
        except:
            pass
        return None

    lyrics = fetch_lyrics(original_query)
    if lyrics:
        print("  ✓ Letra exacta encontrada (LRCLIB)")
    elif clean != original_query:
        lyrics = fetch_lyrics(clean)
        if lyrics:
            print("  ✓ Letra limpia de estudio encontrada (LRCLIB)")
            
    if lyrics:
        lrc_path = os.path.splitext(file_path)[0] + ".lrc"
        with open(lrc_path, "w", encoding="utf-8") as f:
            f.write(lyrics)

def run_dual_download(queries: List[str]):
    import glob
    import random
    import time
    import uuid
    import shutil
    import subprocess
    import os

    task_id = uuid.uuid4().hex[:8]
    print(f"[{task_id}] Iniciando descarga de Motor Dual ({len(queries)} pistas)")

    query_map = {}
    deezer_urls = []
    spotdl_queries = []

    print(f"[{task_id}] Fase 1: Clasificando consultas...")
    import requests
    for query in queries:
        if "deezer.com/track" in query:
            deezer_urls.append(query)
            try:
                track_id = query.split("track/")[1].split("?")[0].split("/")[0]
                res = requests.get(f"https://api.deezer.com/track/{track_id}", timeout=5)
                if res.status_code == 200:
                    track = res.json()
                    query_map[query] = {
                        "artist": track.get("artist", {}).get("name", "Unknown"),
                        "title": track.get("title", query),
                        "original_query": query
                    }
                else:
                    spotdl_queries.append(query)
            except Exception as e:
                print(f"[{task_id}] Error consultando Deezer para '{query}': {e}")
                spotdl_queries.append(query)
        elif "spotify.com/track" in query or "youtube.com/watch" in query or "youtu.be/" in query:
            spotdl_queries.append(query)
            query_map[query] = {"original_query": query}
        else:
            deezer_urls.append(query)
            query_map[query] = {"original_query": query}
            
    os.makedirs(MEDIA_DIR, exist_ok=True)
            
    failed_deemix = []
    if deezer_urls:
        print(f"[{task_id}] Fase 2: Ejecutando Deemix para {len(deezer_urls)} pistas...")
        for url in deezer_urls:
            deemix_tmp = os.path.join(MEDIA_DIR, f".deemix_tmp_{uuid.uuid4().hex[:6]}")
            os.makedirs(deemix_tmp, exist_ok=True)
            
            command_deemix = ["deemix", "--bitrate", "320", "-p", deemix_tmp, url]
            result_deemix = subprocess.run(command_deemix, capture_output=True, text=True)
            out_deemix = result_deemix.stdout + result_deemix.stderr
            print(out_deemix)
            
            new_files = glob.glob(f"{deemix_tmp}/**/*", recursive=True)
            new_files = [f for f in new_files if os.path.isfile(f)]
            
            if new_files:
                for tmp_f in new_files:
                    dest = os.path.join(MEDIA_DIR, os.path.basename(tmp_f))
                    if os.path.exists(dest):
                        os.remove(dest)
                    shutil.move(tmp_f, dest)
                print(f"[{task_id}]   ✓ Deemix descargó desde: {url}")
            elif "already downloaded" in out_deemix.lower():
                print(f"[{task_id}]   ✓ Deemix ya tenía descargado: {url}")
            else:
                info = query_map.get(url, {})
                artist = info.get("artist", "Unknown") if isinstance(info, dict) else "Unknown"
                title = info.get("title", "Unknown") if isinstance(info, dict) else "Unknown"
                original = info.get("original_query", url) if isinstance(info, dict) else url
                print(f"[{task_id}]   ✗ Deemix NO generó archivo para: {original}")
                failed_deemix.append({"artist": artist, "title": title, "query": original})
                
            shutil.rmtree(deemix_tmp, ignore_errors=True)

    failed_spotdl = []
    for track in failed_deemix:
        spotdl_queries.append(f"{track['artist']} - {track['title']}")

    if spotdl_queries:
        print(f"[{task_id}] Fase 3: Ejecutando spotDL (Fallback) para {len(spotdl_queries)} pistas...")
        for query in spotdl_queries:
            spotdl_tmp = os.path.join(MEDIA_DIR, f".spotdl_tmp_{uuid.uuid4().hex[:6]}")
            os.makedirs(spotdl_tmp, exist_ok=True)
            
            command_spotdl = [
                "spotdl",
                "download",
                f"{query}",
                "--output", f"{spotdl_tmp}/{{artists}} - {{title}}.{{ext}}",
                "--format", "mp3",
                "--bitrate", "320k"
            ]
            result_spotdl = subprocess.run(command_spotdl, capture_output=True, text=True)
            print(result_spotdl.stdout + result_spotdl.stderr)
            
            new_files = glob.glob(f"{spotdl_tmp}/*")
            
            if new_files:
                for tmp_f in new_files:
                    dest = os.path.join(MEDIA_DIR, os.path.basename(tmp_f))
                    if os.path.exists(dest):
                        os.remove(dest)
                    shutil.move(tmp_f, dest)
                print(f"[{task_id}]   ✓ spotDL rescató: {query}")
            elif "already downloaded" in (result_spotdl.stdout + result_spotdl.stderr).lower():
                print(f"[{task_id}]   ✓ spotDL ya tenía descargado: {query}")
            else:
                print(f"[{task_id}]   ✗ spotDL NO generó archivo para: {query}")
                failed_spotdl.append(query)
                
            shutil.rmtree(spotdl_tmp, ignore_errors=True)

    if failed_spotdl:
        print(f"[{task_id}] Fase 4: Ejecutando yt-dlp para {len(failed_spotdl)} pistas...")
        env = os.environ.copy()
        deno_path = os.path.expanduser("~/.deno/bin")
        if deno_path not in env.get("PATH", ""):
            env["PATH"] = deno_path + ":" + env.get("PATH", "")
        
        for query in failed_spotdl:
            search_query = query if query.startswith("http") else f"ytsearch1:{query} audio"
            
            ytdlp_tmp = os.path.join(MEDIA_DIR, f".ytdlp_tmp_{uuid.uuid4().hex[:6]}")
            os.makedirs(ytdlp_tmp, exist_ok=True)
            
            ytdlp_cmd = [
                "yt-dlp",
                "-x", "--audio-format", "mp3", "--audio-quality", "0",
                "--extractor-args", "youtube:player_client=android",
                "--write-thumbnail",
                "-o", f"{ytdlp_tmp}/%(title)s.%(ext)s",
                search_query
            ]
            
            subprocess.run(ytdlp_cmd, check=False, env=env)
            
            mp3_files = glob.glob(f"{ytdlp_tmp}/*.mp3")
            if mp3_files:
                file_path = mp3_files[0]
                print(f"[{task_id}]   ✓ yt-dlp rescató: {os.path.basename(file_path)}")
                try:
                    enrich_metadata_for_ytdlp(file_path, query)
                except Exception as e:
                    print(f"[{task_id}]   [!] Error global en enrich_metadata: {e}")
                    
                base_name = os.path.splitext(os.path.basename(file_path))[0]
                for tmp_f in glob.glob(f"{ytdlp_tmp}/{base_name}.*"):
                    if tmp_f.endswith('.mp3') or tmp_f.endswith('.lrc'):
                        dest = os.path.join(MEDIA_DIR, os.path.basename(tmp_f))
                        if os.path.exists(dest):
                            os.remove(dest)
                        shutil.move(tmp_f, dest)
            else:
                print(f"[{task_id}]   ✗ FALLO TOTAL: Ningún motor pudo descargar: {query}")
                
            shutil.rmtree(ytdlp_tmp, ignore_errors=True)
            
            sleep_time = random.uniform(5.0, 8.0)
            print(f"[{task_id}]   [Anti-Bot] Enfriando {sleep_time:.1f}s...")
            time.sleep(sleep_time)

    print(f"[{task_id}] Descargas finalizadas. Ajustando permisos...")
    try:
        subprocess.run(["chmod", "-R", "755", MEDIA_DIR])
    except Exception:
        pass
        
    print(f"[{task_id}] Notificando a Jellyfin...")
    import asyncio
    asyncio.run(update_jellyfin_library())

@app.post("/download/bulk", dependencies=[Depends(get_api_key)])
async def download_music_bulk(request: BulkDownloadRequest, background_tasks: BackgroundTasks):
    """
    Recibe múltiples peticiones de descarga y las encola como una sola tarea de lote en segundo plano.
    """
    if not request.queries:
        return {"status": "error", "message": "No se enviaron canciones para descargar."}
        
    background_tasks.add_task(run_dual_download, request.queries)
    return {
        "status": "success",
        "message": f"Descarga de {len(request.queries)} pistas iniciada en segundo plano."
    }

@app.post("/playlist", dependencies=[Depends(get_api_key)])
async def create_playlist(request: PlaylistCreateRequest):
    """Crea una nueva playlist vacía en Jellyfin."""
    if not JELLYFIN_API_KEY:
        raise HTTPException(status_code=500, detail="JELLYFIN_API_KEY no está configurada")

    async with httpx.AsyncClient() as client:
        headers = {
            "X-Emby-Token": JELLYFIN_API_KEY,
            "Content-Type": "application/json"
        }
        
        user_id = request.user_id
        if not user_id:
            # 1. Fallback al administrador
            users_url = f"{JELLYFIN_URL.rstrip('/')}/Users"
            try:
                users_res = await client.get(users_url, headers=headers)
                users_res.raise_for_status()
                users_data = users_res.json()
                if not users_data:
                    raise HTTPException(status_code=500, detail="No se encontraron usuarios en Jellyfin")
                user_id = users_data[0]["Id"]
            except Exception as e:
                print(f"Error obteniendo usuarios de Jellyfin: {e}")
                raise HTTPException(status_code=500, detail=f"Error obteniendo usuarios de Jellyfin: {e}")

        # 2. Crear la playlist
        create_url = f"{JELLYFIN_URL.rstrip('/')}/Playlists"
        params = {
            "Name": request.name,
            "UserId": user_id,
            "MediaType": "Audio"
        }
        try:
            create_res = await client.post(create_url, headers=headers, params=params)
            create_res.raise_for_status()
            data = create_res.json()
            print(f"Playlist '{request.name}' creada exitosamente.")
            return {"status": "success", "message": "Playlist creada", "playlist_id": data.get("Id")}
        except Exception as e:
            print(f"Error creando playlist en Jellyfin: {e}")
            raise HTTPException(status_code=500, detail=f"Error creando playlist en Jellyfin: {e}")

@app.delete("/playlist/{playlist_id}", dependencies=[Depends(get_api_key)])
async def delete_playlist(playlist_id: str):
    """Elimina una playlist en Jellyfin."""
    if not JELLYFIN_API_KEY:
        raise HTTPException(status_code=500, detail="JELLYFIN_API_KEY no está configurada")
    
    headers = {"X-Emby-Token": JELLYFIN_API_KEY}
    url = f"{JELLYFIN_URL.rstrip('/')}/Items/{playlist_id}"
    try:
        async with httpx.AsyncClient() as client:
            res = await client.delete(url, headers=headers)
            res.raise_for_status()
            return {"status": "success", "message": "Playlist eliminada"}
    except Exception as e:
        print(f"Error eliminando playlist: {e}")
        raise HTTPException(status_code=500, detail=f"Error eliminando playlist en Jellyfin: {e}")

@app.get("/playlists", dependencies=[Depends(get_api_key)])
async def get_playlists(user_id: Optional[str] = None):
    """Obtiene las playlists del usuario (o todas) desde Jellyfin."""
    try:
        headers = {"X-Emby-Token": JELLYFIN_API_KEY}
        url = f"{JELLYFIN_URL.rstrip('/')}/Users/{user_id}/Items" if user_id else f"{JELLYFIN_URL.rstrip('/')}/Items"
        params = {
            "IncludeItemTypes": "Playlist",
            "Recursive": "true",
            "SortBy": "SortName",
        }
        
        async with httpx.AsyncClient() as client:
            res = await client.get(url, headers=headers, params=params)
            res.raise_for_status()
            data = res.json()
            return data.get("Items", [])
    except Exception as e:
        print(f"Error obteniendo playlists: {e}")
        raise HTTPException(status_code=500, detail=f"Error obteniendo playlists de Jellyfin: {e}")

async def check_jellyfin_local(query: str, client: httpx.AsyncClient = None):
    """Verifica si la canción ya existe en la biblioteca local de Jellyfin."""
    if not JELLYFIN_API_KEY:
        return {"exists": False}
        
    url = f"{JELLYFIN_URL.rstrip('/')}/Items"
    params = {
        "SearchTerm": query,
        "Recursive": "true",
        "IncludeItemTypes": "Audio",
        "Limit": 1
    }
    headers = {
        "X-Emby-Token": JELLYFIN_API_KEY
    }
    
    async def do_req(c):
        try:
            response = await c.get(url, params=params, headers=headers)
            response.raise_for_status()
            data = response.json()
            if data.get("TotalRecordCount", 0) > 0:
                return {"exists": True, "data": data["Items"][0]}
        except Exception as e:
            print(f"Error consultando caché local de Jellyfin para '{query}': {e}")
        return {"exists": False}

    if client:
        return await do_req(client)
    else:
        async with httpx.AsyncClient() as c:
            return await do_req(c)

@app.get("/search", dependencies=[Depends(get_api_key)])
async def search_music(q: str, source: str = "deezer", limit: int = 15, offset: int = 0):
    """
    Busca música: validación en Jellyfin (Caché Local) y opciones externas vía Deezer o YouTube.
    """
    import json
    import re as _re

    if not q:
        return {"local_match": {"exists": False, "jellyfin_data": None}, "remote_results": []}

    local_check = await check_jellyfin_local(q)
    if not local_check["exists"]:
        parts = _re.split(r'[,\-]', q)
        if len(parts) > 1:
            local_check = await check_jellyfin_local(parts[0].strip())
            
    local_match_data = {
        "exists": local_check["exists"],
        "jellyfin_data": local_check.get("data") if local_check["exists"] else None
    }
    results = []

    if source == "deezer":
        try:
            url = "https://api.deezer.com/search"
            async with httpx.AsyncClient(follow_redirects=True) as client:
                response = await client.get(url, params={"q": q, "limit": limit, "index": offset})
                response.raise_for_status()
                data = response.json()
            
            for item in data.get('data', []):
                results.append({
                    "title": item.get("title", "Unknown Title"),
                    "artist": item.get("artist", {}).get("name", "Unknown Artist"),
                    "duration": f"{item.get('duration', 0) // 60}:{item.get('duration', 0) % 60:02d}",
                    "cover_url": item.get("album", {}).get("cover_medium", ""),
                    "source": "deezer",
                    "query_string": item.get("link", ""),
                    "spotify_url": item.get("link", ""),
                })
        except Exception as e:
            print(f"Error buscando en Deezer: {repr(e)}")
            
    else: # YouTube (yt-dlp fallback)
        print(f"Buscando externamente con yt-dlp: {q}")
        command = [
            "yt-dlp",
            "-J",
            f"ytsearch7:{q}"
        ]
        
        process = await asyncio.create_subprocess_exec(
            *command,
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.PIPE
        )
        
        stdout, stderr = await process.communicate()
        
        if process.returncode == 0 and stdout:
            try:
                data = json.loads(stdout.decode('utf-8'))
                entries = data.get("entries", [])
                for entry in entries:
                    results.append({
                        "title": entry.get("title", "Unknown Title"),
                        "artist": entry.get("uploader", "Unknown Artist"),
                        "duration": entry.get("duration_string", ""),
                        "url": entry.get("webpage_url", ""),
                        "cover_url": entry.get("thumbnail", "")
                    })
            except Exception as e:
                print(f"Error parseando resultados de yt-dlp: {e}")
        else:
            print(f"Error en búsqueda externa yt-dlp: {stderr.decode('utf-8', errors='ignore')}")
            
    return {
        "local_match": local_match_data,
        "remote_results": results
    }

@app.get("/search/albums", dependencies=[Depends(get_api_key)])
async def search_albums(q: str):
    """
    Busca álbumes usando la API de Deezer.
    """
    if not q:
        return {"results": []}

    try:
        url = "https://api.deezer.com/search/album"
        async with httpx.AsyncClient(follow_redirects=True) as client:
            response = await client.get(url, params={"q": q, "limit": 12})
            response.raise_for_status()
            data = response.json()

        albums_data = []
        for item in data.get('data', []):
            albums_data.append({
                "id": str(item.get('id')),
                "title": item.get('title', 'Unknown Title'),
                "artist": item.get('artist', {}).get('name', 'Unknown Artist'),
                "year": "Unknown", # Deezer search doesn't return release date easily, fallback
                "cover_url": item.get('cover_xl', item.get('cover_big', '')),
                "spotify_url": item.get('link', '') # Se usa como deezer_url
            })
            
        print(f"✅ ¡Éxito! {len(albums_data)} álbumes de Deezer enviados al frontend.")
        return {"results": albums_data}
        
    except Exception as e:
        print(f"❌ Error buscando álbumes en Deezer: {e}")
        return {"error": str(e), "results": []}

@app.get("/album/{album_id}", dependencies=[Depends(get_api_key)])
async def get_album_details(album_id: str):
    """
    Obtiene los detalles del álbum (Deezer) y verifica el caché local en Jellyfin para cada pista.
    """
    try:
        url = f"https://api.deezer.com/album/{album_id}"
        async with httpx.AsyncClient() as client:
            response = await client.get(url)
            album_info = response.json()

        if 'error' in album_info:
            return {"error": "Álbum no encontrado"}

        year = album_info.get('release_date', '')[:4] if album_info.get('release_date') else "Unknown"

        album_data = {
            "id": str(album_info.get('id')),
            "title": album_info.get('title', 'Unknown Title'),
            "artist": album_info.get('artist', {}).get('name', 'Unknown Artist'),
            "year": year,
            "cover_url": album_info.get('cover_xl', album_info.get('cover_big', ''))
        }

        tracks_data = []
        async with httpx.AsyncClient() as jf_client:
            for track in album_info.get('tracks', {}).get('data', []):
                title = track.get('title', 'Unknown Title')
                artist = track.get('artist', {}).get('name', 'Unknown Artist')
                
                # 1. Verificar si la canción ya existe en tu Jellyfin local
                # Se busca solo por título, y si no por título + artista. Usamos conexión persistente.
                local_check = await check_jellyfin_local(title, jf_client)
                if not local_check.get("exists"):
                    local_check = await check_jellyfin_local(f"{title} {artist}", jf_client)
            
                # 2. Empaquetar la pista con la información de caché y el query de descarga
                # Si pasamos el link directo a Deemix será instantáneo
                tracks_data.append({
                    "id": str(track.get('id')),
                    "title": title,
                    "artist": artist,
                    "track_number": track.get('track_position', 0),
                    "duration_ms": track.get('duration', 0) * 1000,
                    "query_string": track.get('link', f"{artist} - {title}"), 
                    "local_match": {
                        "exists": local_check["exists"],
                        "jellyfin_data": local_check.get("data") if local_check["exists"] else None
                    }
                })

        return {
            "album": album_data,
            "tracks": tracks_data
        }
    except Exception as e:
        print(f"❌ Error obteniendo detalles del álbum: {e}")
        return {"error": str(e)}

@app.get("/health")
async def health_check():
    """Endpoint para verificar el estado de la API."""
    return {"status": "ok"}

@app.get("/lyrics", dependencies=[Depends(get_api_key)])
async def get_lyrics(artist: str, title: str):
    """Obtiene las letras de una canción desde el archivo local o desde la API pública LRCLIB."""
    import urllib.parse
    
    # 1. Intento local
    possible_filenames = [
        f"{artist} - {title}.lrc",
        f"{artist} - {title}.txt",
        f"{title}.lrc"
    ]
    
    for filename in possible_filenames:
        filepath = os.path.join(MEDIA_DIR, filename)
        if os.path.exists(filepath):
            try:
                with open(filepath, 'r', encoding='utf-8') as f:
                    content = f.read()
                return {"status": "success", "lyrics": content, "source": "local"}
            except Exception as e:
                print(f"Error leyendo archivo de letras: {e}")
                
    # 2. Fallback a LRCLIB (API Pública y Gratuita)
    print(f"Letras locales no encontradas. Buscando en LRCLIB para: {artist} - {title}")
    try:
        url = f"https://lrclib.net/api/get?artist_name={urllib.parse.quote(artist)}&track_name={urllib.parse.quote(title)}"
        async with httpx.AsyncClient() as client:
            # LRCLIB requiere un User-Agent
            headers = {"User-Agent": "SynapMusic (https://github.com/tu-usuario/SynapMusic)"}
            response = await client.get(url, headers=headers, timeout=5.0)
            
            if response.status_code == 200:
                data = response.json()
                lyrics = data.get("syncedLyrics") or data.get("plainLyrics")
                if lyrics:
                    # Opcionalmente, podríamos guardar el archivo .lrc aquí para el futuro
                    filepath = os.path.join(MEDIA_DIR, f"{artist} - {title}.lrc")
                    try:
                        with open(filepath, 'w', encoding='utf-8') as f:
                            f.write(lyrics)
                    except:
                        pass
                        
                    return {"status": "success", "lyrics": lyrics, "source": "lrclib"}
    except Exception as e:
        print(f"Error buscando en LRCLIB: {e}")
        
    return {"status": "error", "message": "Letras no encontradas en el servidor ni en LRCLIB"}

class RegisterRequest(BaseModel):
    username: str
    password: str

@app.post("/register")
async def register_user(req: RegisterRequest):
    # Crea un usuario en Jellyfin y lo deshabilita (Sala de Espera).
    headers = {"X-Emby-Token": JELLYFIN_API_KEY}
    
    async with httpx.AsyncClient() as client:
        # 1. Crear usuario
        create_url = f"{JELLYFIN_URL}/Users/New"
        create_resp = await client.post(create_url, headers=headers, json={"Name": req.username, "Password": req.password})
        
        if create_resp.status_code != 200:
            print(f"Error creando usuario: {create_resp.text}")
            raise HTTPException(status_code=400, detail="Error al crear el usuario en Jellyfin")
            
        user_data = create_resp.json()
        user_id = user_data.get("Id")
        
        if not user_id:
            raise HTTPException(status_code=500, detail="No se obtuvo el ID del usuario creado")
            
        # 2. Obtener política actual
        get_user_url = f"{JELLYFIN_URL}/Users/{user_id}"
        user_resp = await client.get(get_user_url, headers=headers)
        if user_resp.status_code != 200:
            raise HTTPException(status_code=500, detail="Error obteniendo política del usuario")
            
        policy = user_resp.json().get("Policy", {})
        
        # 3. Deshabilitar usuario y revocar privilegios de admin por seguridad
        policy["IsDisabled"] = True
        policy["IsAdministrator"] = False
        
        policy_url = f"{JELLYFIN_URL}/Users/{user_id}/Policy"
        policy_resp = await client.post(policy_url, headers=headers, json=policy)
        
        if policy_resp.status_code not in [200, 204]:
            print(f"Error actualizando política: {policy_resp.text}")
            raise HTTPException(status_code=500, detail="Error enviando a sala de espera")
            
        return {"status": "success", "message": "Cuenta creada. Esperando aprobación."}

@app.get("/users/pending")
async def get_pending_users():
    # Obtiene todos los usuarios que están deshabilitados (en sala de espera).
    headers = {"X-Emby-Token": JELLYFIN_API_KEY}
    
    async with httpx.AsyncClient() as client:
        users_url = f"{JELLYFIN_URL}/Users"
        resp = await client.get(users_url, headers=headers)
        
        if resp.status_code != 200:
            raise HTTPException(status_code=500, detail="Error obteniendo usuarios de Jellyfin")
            
        users = resp.json()
        pending = [u for u in users if u.get("Policy", {}).get("IsDisabled", False)]
        
        return pending

@app.post("/users/approve/{user_id}")
async def approve_user(user_id: str):
    # Habilita a un usuario en sala de espera y le da acceso a las bibliotecas.
    headers = {"X-Emby-Token": JELLYFIN_API_KEY}
    
    async with httpx.AsyncClient() as client:
        # 1. Obtener usuario actual para su policy
        get_user_url = f"{JELLYFIN_URL}/Users/{user_id}"
        user_resp = await client.get(get_user_url, headers=headers)
        
        if user_resp.status_code != 200:
            raise HTTPException(status_code=404, detail="Usuario no encontrado")
            
        policy = user_resp.json().get("Policy", {})
        
        # 2. Modificar política
        policy["IsDisabled"] = False
        policy["EnableAllFolders"] = True
        policy["IsAdministrator"] = False
        
        # 3. Guardar política
        policy_url = f"{JELLYFIN_URL}/Users/{user_id}/Policy"
        policy_resp = await client.post(policy_url, headers=headers, json=policy)
        
        if policy_resp.status_code not in [200, 204]:
            raise HTTPException(status_code=500, detail="Error aprobando al usuario")
            
        return {"status": "success", "message": "Usuario aprobado correctamente."}

async def expand_url(url: str) -> str:
    """Expande URLs acortadas (ej. link.deezer.com) a su URL real."""
    async with httpx.AsyncClient(follow_redirects=True) as client:
        try:
            res = await client.head(url)
            return str(res.url)
        except Exception as e:
            print(f"Error expandiendo URL {url}: {e}")
            return url

@app.post("/download/playlist-migration", dependencies=[Depends(get_api_key)])
async def migrate_external_playlist(request: MigrationRequest, background_tasks: BackgroundTasks):
    if not request.url or not request.user_id:
        raise HTTPException(status_code=400, detail="Faltan parámetros")
        
    real_url = await expand_url(request.url)
        
    background_tasks.add_task(
        run_migration_task,
        real_url,
        request.user_id,
        JELLYFIN_URL,
        JELLYFIN_API_KEY
    )
    return {
        "status": "success",
        "message": "Migración inteligente de playlist iniciada en segundo plano."
    }

import datetime
import random
import asyncio

async def fetch_top_mexico_and_download():
    # 1. Traer Top 10 de Mexico desde Deezer
    url = "https://api.deezer.com/chart/132/tracks"
    try:
        async with httpx.AsyncClient(follow_redirects=True) as client:
            response = await client.get(url, params={"limit": 10})
            response.raise_for_status()
            data = response.json()
            
            tracks = data.get("data", [])
            for track in tracks:
                query = track.get("link", "")
                title = track.get("title", "")
                artist = track.get("artist", {}).get("name", "")
                if query:
                    # check local first
                    local_check = await check_jellyfin_local(title, client)
                    if not local_check.get("exists"):
                        local_check = await check_jellyfin_local(f"{title} {artist}", client)
                        
                    if local_check.get("exists"):
                        print(f"Saltando {title} de Top 10 Mexico, ya existe en Jellyfin.")
                        continue

                    # Enviar a la cola de descarga (simulate call to orchestrator)
                    print(f"Descargando desde Top 10 Mexico: {query}")
                    asyncio.create_task(asyncio.to_thread(run_dual_download, [query]))
    except Exception as e:
        print(f"Error en top mexico task: {e}")

async def daily_top_mexico_task():
    while True:
        now = datetime.datetime.now()
        target = now.replace(hour=3, minute=0, second=0, microsecond=0)
        if now >= target:
            target += datetime.timedelta(days=1)
        
        sleep_seconds = (target - now).total_seconds()
        await asyncio.sleep(sleep_seconds)
        
        await fetch_top_mexico_and_download()
        with open("last_top_run.txt", "w") as f:
            f.write(datetime.datetime.now().strftime("%Y-%m-%d"))

@app.on_event("startup")
async def startup_event():
    # Check if we should run it now
    today = datetime.datetime.now().strftime("%Y-%m-%d")
    run_now = True
    if os.path.exists("last_top_run.txt"):
        with open("last_top_run.txt", "r") as f:
            last_run = f.read().strip()
            if last_run == today:
                run_now = False
                
    if run_now:
        print("Ejecutando tarea de Top 10 Mexico en startup...")
        with open("last_top_run.txt", "w") as f:
            f.write(today)
        asyncio.create_task(fetch_top_mexico_and_download())
        
    asyncio.create_task(daily_top_mexico_task())


@app.get("/home/top-songs", dependencies=[Depends(get_api_key)])
async def get_top_songs(user_id: str):
    if not JELLYFIN_API_KEY: return []
    url = f"{JELLYFIN_URL.rstrip('/')}/Users/{user_id}/Items"
    params = {
        "IncludeItemTypes": "Audio",
        "SortBy": "PlayCount",
        "SortOrder": "Descending",
        "Limit": 15,
        "Recursive": "true",
        "Filters": "IsPlayed"
    }
    headers = {"X-Emby-Token": JELLYFIN_API_KEY}
    try:
        async with httpx.AsyncClient() as client:
            res = await client.get(url, params=params, headers=headers)
            res.raise_for_status()
            data = res.json()
            return data.get("Items", [])
    except:
        return []

@app.get("/home/top-artists", dependencies=[Depends(get_api_key)])
async def get_top_artists(user_id: str):
    if not JELLYFIN_API_KEY: return []
    url = f"{JELLYFIN_URL.rstrip('/')}/Users/{user_id}/Items"
    params = {
        "IncludeItemTypes": "Audio",
        "SortBy": "PlayCount,Random",
        "SortOrder": "Descending",
        "Limit": 100,
        "Recursive": "true"
    }
    headers = {"X-Emby-Token": JELLYFIN_API_KEY}
    results = []
    seen = set()
    try:
        async with httpx.AsyncClient() as client:
            res = await client.get(url, params=params, headers=headers)
            res.raise_for_status()
            items = res.json().get("Items", [])
            
            for item in items:
                artist_items = item.get("ArtistItems", [])
                for a in artist_items:
                    name = a.get("Name")
                    if name and name not in seen:
                        seen.add(name)
                        artist_info = {
                            "id": a.get("Id"),
                            "name": name,
                            "cover_url": None
                        }
                        try:
                            dz_res = await client.get("https://api.deezer.com/search/artist", params={"q": name, "limit": 1})
                            if dz_res.status_code == 200:
                                dz_data = dz_res.json().get("data", [])
                                if dz_data:
                                    artist_info["cover_url"] = dz_data[0].get("picture_medium")
                        except:
                            pass
                        results.append(artist_info)
                        if len(results) >= 10:
                            return results
            return results
    except Exception as e:
        print("Error top artists:", e)
        return []

@app.get("/home/top-albums", dependencies=[Depends(get_api_key)])
async def get_top_albums(user_id: str):
    if not JELLYFIN_API_KEY: return []
    url = f"{JELLYFIN_URL.rstrip('/')}/Users/{user_id}/Items"
    params = {
        "IncludeItemTypes": "Audio",
        "SortBy": "PlayCount,Random",
        "SortOrder": "Descending",
        "Limit": 150,
        "Recursive": "true"
    }
    headers = {"X-Emby-Token": JELLYFIN_API_KEY}
    results = []
    seen = set()
    try:
        async with httpx.AsyncClient() as client:
            res = await client.get(url, params=params, headers=headers)
            res.raise_for_status()
            items = res.json().get("Items", [])
            
            for item in items:
                album_name = item.get("Album")
                if album_name and album_name not in seen:
                    seen.add(album_name)
                    artist = item.get("AlbumArtist", "Unknown")
                    cover_url = None
                    if item.get("ImageTags", {}).get("Primary"):
                        public_url = os.getenv("JELLYFIN_PUBLIC_URL", JELLYFIN_URL)
                        cover_url = f"{public_url.rstrip('/')}/Items/{item.get('Id')}/Images/Primary"
                    
                    deezer_id = None
                    try:
                        d_res = await client.get("https://api.deezer.com/search/album", params={"q": f"{album_name} {artist}", "limit": 1})
                        if d_res.status_code == 200:
                            d_data = d_res.json().get("data", [])
                            if d_data:
                                deezer_id = str(d_data[0].get("id"))
                    except:
                        pass
                        
                    if deezer_id:
                        results.append({
                            "id": deezer_id,
                            "title": album_name,
                            "artist": artist,
                            "cover_url": cover_url,
                            "source": "deezer",
                            "jellyfin_item": item 
                        })
                        if len(results) >= 10:
                            break
            return results
    except Exception as e:
        print("Error top albums:", e)
        return []

@app.get("/home/new-releases", dependencies=[Depends(get_api_key)])
async def get_new_releases(user_id: str):
    import datetime
    artists = await get_top_artists(user_id)
    top_3 = artists[:3]
    results = []
    current_year = str(datetime.datetime.now().year)
    
    try:
        async with httpx.AsyncClient() as client:
            for artist in top_3:
                dz_res = await client.get("https://api.deezer.com/search/artist", params={"q": artist["name"], "limit": 1})
                if dz_res.status_code == 200:
                    dz_data = dz_res.json().get("data", [])
                    if dz_data:
                        dz_id = dz_data[0].get("id")
                        alb_res = await client.get(f"https://api.deezer.com/artist/{dz_id}/albums")
                        if alb_res.status_code == 200:
                            albs = alb_res.json().get("data", [])
                            for a in albs:
                                rd = a.get("release_date", "")
                                if rd.startswith(current_year):
                                    results.append({
                                        "id": str(a.get("id")),
                                        "title": a.get("title"),
                                        "artist": artist["name"],
                                        "cover_url": a.get("cover_medium"),
                                        "source": "deezer"
                                    })
                                    break
            
            if not results:
                url = f"{JELLYFIN_URL.rstrip('/')}/Users/{user_id}/Items"
                params = {
                    "IncludeItemTypes": "Audio",
                    "SortBy": "Random",
                    "Limit": 50,
                    "Recursive": "true"
                }
                res = await client.get(url, params=params, headers={"X-Emby-Token": JELLYFIN_API_KEY})
                if res.status_code == 200:
                    items = res.json().get("Items", [])
                    seen_alb = set()
                    for item in items:
                        album_name = item.get("Album")
                        if album_name and album_name not in seen_alb:
                            seen_alb.add(album_name)
                            artist_name = item.get("AlbumArtist", "Unknown")
                            cover_url = None
                            if item.get("ImageTags", {}).get("Primary"):
                                public_url = os.getenv("JELLYFIN_PUBLIC_URL", JELLYFIN_URL)
                                cover_url = f"{public_url.rstrip('/')}/Items/{item.get('Id')}/Images/Primary"
                                
                            deezer_id = None
                            try:
                                d_res = await client.get("https://api.deezer.com/search/album", params={"q": f"{album_name} {artist_name}", "limit": 1})
                                if d_res.status_code == 200:
                                    d_data = d_res.json().get("data", [])
                                    if d_data:
                                        deezer_id = str(d_data[0].get("id"))
                            except:
                                pass
                                
                            if deezer_id:
                                results.append({
                                    "id": deezer_id,
                                    "title": album_name,
                                    "artist": artist_name,
                                    "cover_url": cover_url,
                                    "source": "deezer",
                                    "jellyfin_item": item
                                })
                                if len(results) >= 4:
                                    break
            return results
    except Exception as e:
        print(f"Error in new-releases: {e}")
        return []

@app.get("/search/global-albums", dependencies=[Depends(get_api_key)])
async def get_global_albums():
    try:
        url = "https://api.deezer.com/chart/0/albums"
        async with httpx.AsyncClient() as client:
            res = await client.get(url, params={"limit": 15})
            res.raise_for_status()
            data = res.json().get("data", [])
            results = []
            for item in data:
                results.append({
                    "id": str(item.get("id")),
                    "title": item.get("title"),
                    "artist": item.get("artist", {}).get("name", "Unknown"),
                    "cover_url": item.get("cover_medium")
                })
            return results
    except:
        return []

@app.get("/home/top-mexico", dependencies=[Depends(get_api_key)])
async def get_top_mexico():
    try:
        url = "https://api.deezer.com/chart/132/tracks"
        async with httpx.AsyncClient() as client:
            res = await client.get(url, params={"limit": 10})
            res.raise_for_status()
            data = res.json().get("data", [])
            results = []
            for item in data:
                title = item.get("title")
                artist = item.get("artist", {}).get("name", "Unknown")
                
                # Check local Jellyfin
                local_data = await check_jellyfin_local(title, client)
                if not local_data.get("exists"):
                    local_data = await check_jellyfin_local(f"{title} {artist}", client)
                jellyfin_item = None
                local_id = None
                if local_data.get("exists") and "data" in local_data:
                    local_id = local_data["data"].get("Id")
                    jellyfin_item = local_data["data"]
                    
                    # Ensure full image URL for jellyfin item in Top 10 Mexico
                    if jellyfin_item.get("ImageTags", {}).get("Primary"):
                        jellyfin_item["ImageTags"]["Primary"] = jellyfin_item["ImageTags"]["Primary"]
                
                results.append({
                    "id": str(item.get("id")),
                    "title": title,
                    "artist": artist,
                    "cover_url": item.get("album", {}).get("cover_medium"),
                    "query_string": item.get("link"),
                    "local_id": local_id,
                    "jellyfin_item": jellyfin_item
                })
            return results
    except Exception as e:
        print("Error top mexico:", e)
        return []
@app.get("/artist/{artist_name}/profile", dependencies=[Depends(get_api_key)])
async def get_artist_profile(artist_name: str):
    import asyncio
    try:
        async with httpx.AsyncClient() as client:
            # 1. Search artist
            dz_res = await client.get("https://api.deezer.com/search/artist", params={"q": artist_name, "limit": 1})
            dz_res.raise_for_status()
            dz_data = dz_res.json().get("data", [])
            if not dz_data:
                return {"error": "Artista no encontrado en Deezer"}
            
            artist = dz_data[0]
            artist_id = artist.get("id")
            
            # 2. Concurrently fetch top tracks and albums
            top_res, alb_res = await asyncio.gather(
                client.get(f"https://api.deezer.com/artist/{artist_id}/top", params={"limit": 15}),
                client.get(f"https://api.deezer.com/artist/{artist_id}/albums", params={"limit": 50})
            )
            
            top_tracks = top_res.json().get("data", []) if top_res.status_code == 200 else []
            all_albums = alb_res.json().get("data", []) if alb_res.status_code == 200 else []
            
            # 3. Categorize albums and singles
            albums = []
            singles = []
            for a in all_albums:
                record_type = a.get("record_type", "")
                item = {
                    "id": str(a.get("id")),
                    "title": a.get("title"),
                    "cover_url": a.get("cover_medium"),
                    "release_date": a.get("release_date", "")
                }
                if record_type == "album":
                    if len(albums) < 3: albums.append(item)
                elif record_type == "single" or record_type == "ep":
                    if len(singles) < 5: singles.append(item)
                    
            latest_release = None
            if all_albums:
                # all_albums is usually sorted by release date desc
                a = all_albums[0]
                latest_release = {
                    "id": str(a.get("id")),
                    "title": a.get("title"),
                    "cover_url": a.get("cover_medium"),
                    "type": a.get("record_type", "")
                }
                
            # Formatting top tracks
            formatted_tracks = []
            for t in top_tracks:
                title = t.get("title")
                # Pasamos el cliente para no abrir 15 conexiones nuevas
                local_data = await check_jellyfin_local(title, client)
                
                # Double check to prevent strict match failures:
                # If we didn't find it with exact title, maybe try Title + Artist?
                if not local_data.get("exists"):
                    local_data = await check_jellyfin_local(f"{title} {artist.get('name')}", client)
                    
                local_id = local_data["data"].get("Id") if local_data.get("exists") and "data" in local_data else None
                
                formatted_tracks.append({
                    "id": str(t.get("id")),
                    "title": title,
                    "cover_url": t.get("album", {}).get("cover_medium") if t.get("album") else artist.get("picture_medium"),
                    "query_string": t.get("link"),
                    "local_id": local_id
                })
                
            return {
                "artist": {
                    "id": str(artist_id),
                    "name": artist.get("name"),
                    "picture_url": artist.get("picture_xl") or artist.get("picture_medium")
                },
                "latest_release": latest_release,
                "top_tracks": formatted_tracks,
                "albums": albums,
                "singles": singles
            }
    except Exception as e:
        print("Error artist profile:", e)
        return {"error": str(e)}



class MetadataEditRequest(BaseModel):
    query: str
    manual_cover_url: Optional[str] = None
    manual_lyrics: Optional[str] = None

@app.get("/metadata/check/{item_id}", dependencies=[Depends(get_api_key)])
async def check_metadata_editable(item_id: str):
    try:
        import httpx
        from mutagen.mp3 import MP3
        from mutagen.id3 import ID3
        
        headers = {"X-Emby-Token": JELLYFIN_API_KEY}
        url = f"{JELLYFIN_URL}/Items?Ids={item_id}&Fields=Path"
        async with httpx.AsyncClient() as client:
            res = await client.get(url, headers=headers, timeout=5)
            data = res.json()
            items = data.get("Items", [])
            if not items:
                return {"editable": False, "error": "Item not found in Jellyfin"}
                
            path = items[0].get("Path")
            if not path or not os.path.exists(path):
                filename = os.path.basename(path) if path else ""
                possible_path = os.path.join(MEDIA_DIR, filename)
                if os.path.exists(possible_path):
                    path = possible_path
                else:
                    return {"editable": False, "error": f"File not found on disk: {path}"}
            
            if not path.lower().endswith(".mp3"):
                return {"editable": False, "reason": "Not an MP3 file"}
                
            audio = MP3(path, ID3=ID3)
            is_youtube = False
            for tag in audio.tags.values():
                if tag.FrameID == "TXXX" and tag.desc == "synap_source" and "youtube" in tag.text:
                    is_youtube = True
                    break
                    
            return {"editable": is_youtube, "title": items[0].get("Name"), "artist": items[0].get("Artists", [""])[0] if items[0].get("Artists") else ""}
    except Exception as e:
        return {"editable": False, "error": str(e)}

@app.post("/metadata/edit/{item_id}", dependencies=[Depends(get_api_key)])
async def edit_metadata(item_id: str, request: MetadataEditRequest):
    try:
        import httpx
        headers = {"X-Emby-Token": JELLYFIN_API_KEY}
        url = f"{JELLYFIN_URL}/Items?Ids={item_id}&Fields=Path"
        async with httpx.AsyncClient() as client:
            res = await client.get(url, headers=headers, timeout=5)
            items = res.json().get("Items", [])
            if not items:
                return {"status": "error", "message": "Item not found"}
            
            path = items[0].get("Path")
            if not path or not os.path.exists(path):
                filename = os.path.basename(path) if path else ""
                possible_path = os.path.join(MEDIA_DIR, filename)
                if os.path.exists(possible_path):
                    path = possible_path
                else:
                    return {"status": "error", "message": "File not found"}
                    
            lrc_path = os.path.splitext(path)[0] + ".lrc"
            if request.manual_lyrics:
                with open(lrc_path, "w", encoding="utf-8") as f:
                    f.write(request.manual_lyrics)
            else:
                try:
                    res_lrc = requests.get("https://lrclib.net/api/search", params={"q": request.query}, timeout=5)
                    if res_lrc.status_code == 200:
                        data = res_lrc.json()
                        if data and isinstance(data, list) and len(data) > 0:
                            lyrics = data[0].get("syncedLyrics") or data[0].get("plainLyrics")
                            if lyrics:
                                with open(lrc_path, "w", encoding="utf-8") as f:
                                    f.write(lyrics)
                except:
                    pass
                    
            cover_bytes = None
            if request.manual_cover_url:
                try:
                    cover_bytes = requests.get(request.manual_cover_url, timeout=5).content
                except:
                    pass
            else:
                try:
                    dz_res = requests.get("https://api.deezer.com/search/track", params={"q": request.query, "limit": 1}, timeout=5)
                    if dz_res.status_code == 200:
                        dz_data = dz_res.json().get("data", [])
                        if dz_data:
                            cover_url = dz_data[0].get("album", {}).get("cover_xl")
                            if cover_url:
                                cover_bytes = requests.get(cover_url, timeout=5).content
                except:
                    pass
                    
            if cover_bytes:
                from mutagen.mp3 import MP3
                from mutagen.id3 import ID3, APIC
                audio = MP3(path, ID3=ID3)
                audio.tags.delall("APIC")
                audio.tags.add(
                    APIC(
                        encoding=3,
                        mime='image/jpeg',
                        type=3,
                        desc='Cover',
                        data=cover_bytes
                    )
                )
                audio.save(v2_version=3)
                
                headers_post = {"X-Emby-Token": JELLYFIN_API_KEY, "Content-Type": "image/jpeg"}
                post_url = f"{JELLYFIN_URL}/Items/{item_id}/Images/Primary"
                async with httpx.AsyncClient() as c2:
                    await c2.post(post_url, headers=headers_post, content=cover_bytes)
                    
            items[0]["Name"] = request.query
            update_url = f"{JELLYFIN_URL}/Items/{item_id}"
            headers_json = {"X-Emby-Token": JELLYFIN_API_KEY, "Content-Type": "application/json"}
            async with httpx.AsyncClient() as c3:
                await c3.post(update_url, headers=headers_json, json=items[0])
                
            await update_jellyfin_library()
            return {"status": "success", "message": "Metadata updated successfully"}
            
    except Exception as e:
        return {"status": "error", "message": str(e)}

@app.get("/debug/local-check")

async def debug_local_check(q: str):
    local_data = await check_jellyfin_local(q)
    return {"query": q, "result": local_data}

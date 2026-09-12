import os
import asyncio
import httpx
import requests
import subprocess
from fastapi import FastAPI, Depends, HTTPException, Security, BackgroundTasks, Request, File, UploadFile, Form
from fastapi.responses import FileResponse, HTMLResponse
from fastapi.staticfiles import StaticFiles
from playlist_migrator import run_migration_task
from fastapi.security import APIKeyHeader
from pydantic import BaseModel
from dotenv import load_dotenv
from typing import List, Optional
import sqlite3
import uuid
import json
import re
from zoneinfo import ZoneInfo
import datetime
import time

# Cargar variables de entorno desde .env
load_dotenv()

API_KEY = os.getenv("API_KEY", "default_secret_key")
MEDIA_DIR = "/opt/synapmusic/media"  # Restaurado a ruta absoluta obligatoria
JELLYFIN_URL = os.getenv("JELLYFIN_URL", "http://localhost:8096")
JELLYFIN_API_KEY = os.getenv("JELLYFIN_API_KEY", "")
DEEZER_ARL = os.getenv("DEEZER_ARL", "")

# Configuración de Feedback / Ayuda y comentarios
FEEDBACK_DIR = os.getenv("FEEDBACK_DIR", os.path.join(os.path.dirname(__file__), "feedback_images"))
FEEDBACK_DB = os.getenv("FEEDBACK_DB", os.path.join(os.path.dirname(__file__), "feedback.db"))
os.makedirs(FEEDBACK_DIR, exist_ok=True)

def init_feedback_db():
    try:
        conn = sqlite3.connect(FEEDBACK_DB)
        cursor = conn.cursor()
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS feedback (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                user_id TEXT,
                user_name TEXT,
                title TEXT,
                message TEXT,
                created_at TEXT,
                images TEXT
            )
        """)
        conn.commit()
        conn.close()
    except Exception as e:
        print(f"Error inicializando feedback.db: {e}")

init_feedback_db()

def patch_deemix_libraries():
    """
    Parchea automáticamente deezer-py y deemix para solucionar:
    1. IndexError: list index out of range en deezer/utils.py (track['MEDIA'][0]['HREF'])
    2. KeyError: 'explicit_lyrics' en deemix/itemgen.py (trackAPI['explicit_lyrics'])
    """
    import sys
    import glob
    import re

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
        "/opt/synapmusic/api-descargas/venv/lib64/python3.13/site-packages/deezer/utils.py",
        "/opt/synapmusic/api-descargas/venv/lib/python3.13/site-packages/deezer/utils.py",
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
        "/opt/synapmusic/api-descargas/venv/lib64/python3.13/site-packages/deemix/itemgen.py",
        "/opt/synapmusic/api-descargas/venv/lib/python3.13/site-packages/deemix/itemgen.py",
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
        "/opt/synapmusic/api-descargas/venv/lib64/python3.13/site-packages/deemix/utils/pathtemplates.py",
        "/opt/synapmusic/api-descargas/venv/lib/python3.13/site-packages/deemix/utils/pathtemplates.py",
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

def get_deemix_binary():
    """Obtiene la ruta absoluta al ejecutable deemix."""
    import sys
    import shutil
    venv_deemix = os.path.join(os.path.dirname(sys.executable), "deemix")
    if os.path.isfile(venv_deemix) and os.access(venv_deemix, os.X_OK):
        return venv_deemix
    which_path = shutil.which("deemix")
    if which_path:
        return which_path
    server_path = "/opt/synapmusic/api-descargas/venv/bin/deemix"
    if os.path.isfile(server_path) and os.access(server_path, os.X_OK):
        return server_path
    return "deemix"

def setup_deemix():
    """Configura el entorno de Deemix inyectando ARL, config.json y aplicando el parche a deezer-py."""
    patch_deezer_utils()
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

PORTAL_DIR = os.path.join(os.path.dirname(__file__), "portal")
if os.path.exists(PORTAL_DIR):
    app.mount("/portal-static", StaticFiles(directory=PORTAL_DIR), name="portal-static")

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
    filename = os.path.basename(file_path)
    name_without_ext = os.path.splitext(filename)[0]
    print(f"  [Metadatos] Iniciando enriquecimiento para: {filename}")
    
    # Determinar texto base para buscar portada y letras si la consulta original era un URL
    search_seed = name_without_ext if (original_query.startswith("http://") or original_query.startswith("https://")) else original_query
    clean = clean_title(search_seed)
    
    norm_name = name_without_ext.replace('｜', '|').replace('／', '/').replace('—', '-').replace('–', '-')
    parts = norm_name.split(" - ", 1)
    if len(parts) == 2:
        artist_text = parts[0].strip()
        title_text = parts[1].strip()
    else:
        artist_text = "Unknown Artist"
        title_text = norm_name.strip()

    clean_title_text = clean_title(title_text)
    if not clean_title_text:
        clean_title_text = title_text
    
    cover_bytes = None
    latin_artist = re.sub(r'[\uac00-\ud7af\u1100-\u11ff\u3040-\u30ff\u3400-\u4dbf\u4e00-\u9fff]', '', artist_text).strip()

    # 1. Portada: Estrategia en Cascada (Deezer con validación -> Miniatura YouTube)
    try:
        import requests
        dz_queries = [
            f"{artist_text} {clean_title_text}",
            f"{latin_artist} {clean_title_text}" if latin_artist else None,
            clean
        ]
        dz_queries = [q for q in dz_queries if q]

        for dq in dz_queries:
            dz_res = requests.get("https://api.deezer.com/search/track", params={"q": dq, "limit": 5}, timeout=5)
            if dz_res.status_code == 200:
                dz_data = dz_res.json().get("data", [])
                for it in dz_data:
                    it_t = it.get('title', '').lower()
                    it_a = it.get('artist', {}).get('name', '').lower()
                    target_t = clean_title_text.lower()

                    title_match = (target_t in it_t or it_t in target_t)
                    artist_match = True
                    if latin_artist:
                        artist_match = (latin_artist.lower() in it_a or it_a in latin_artist.lower())
                    elif artist_text != "Unknown Artist":
                        artist_match = (artist_text.lower() in it_a or it_a in artist_text.lower())

                    if title_match and artist_match:
                        cover_url = it.get("album", {}).get("cover_xl")
                        if cover_url:
                            cover_bytes = requests.get(cover_url, timeout=5).content
                            print(f"  ✓ Portada obtenida desde Deezer: {it.get('artist', {}).get('name')} - {it.get('title')}")
                            break
            if cover_bytes:
                break
    except Exception as e:
        print(f"  [!] Error buscando portada en deezer: {e}")

    # Si Deezer no tiene la canción exacta (ej. bonus track exclusivo o remix), usar miniatura de YouTube
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
        from mutagen.id3 import ID3, APIC, TXXX, TIT2, TPE1, TALB, error
        audio = MP3(file_path, ID3=ID3)
        try:
            audio.add_tags()
        except error:
            pass
            
        audio.tags.add(TIT2(encoding=3, text=[clean_title_text]))
        audio.tags.add(TPE1(encoding=3, text=[artist_text]))
        audio.tags.add(TALB(encoding=3, text=[clean_title_text]))
            
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

    # 2. Letras: Estrategia en Cascada LRCLIB (Exacta -> Con Artista Latino -> Por Título)
    def fetch_lyrics(q, target_artist=None):
        try:
            import requests
            res = requests.get("https://lrclib.net/api/search", params={"q": q}, timeout=5)
            if res.status_code == 200:
                data = res.json()
                if data and isinstance(data, list) and len(data) > 0:
                    for item in data:
                        if target_artist and target_artist.lower() not in item.get('artistName', '').lower():
                            continue
                        if item.get("syncedLyrics"):
                            return item["syncedLyrics"]
                    for item in data:
                        if target_artist and target_artist.lower() not in item.get('artistName', '').lower():
                            continue
                        if item.get("plainLyrics"):
                            return item["plainLyrics"]
        except:
            pass
        return None

    lyrics = fetch_lyrics(f"{artist_text} {clean_title_text}")
    if lyrics:
        print("  ✓ Letra exacta encontrada (LRCLIB)")
    elif latin_artist:
        lyrics = fetch_lyrics(f"{latin_artist} {clean_title_text}", target_artist=latin_artist)
        if lyrics:
            print("  ✓ Letra por artista latino + título encontrada (LRCLIB)")
            
    if not lyrics:
        lyrics = fetch_lyrics(clean_title_text, target_artist=latin_artist or (artist_text if artist_text != "Unknown Artist" else None))
        if lyrics:
            print("  ✓ Letra por título encontrada (LRCLIB)")
            
    if not lyrics and clean != search_seed:
        lyrics = fetch_lyrics(clean)
        if lyrics:
            print("  ✓ Letra por búsqueda limpia encontrada (LRCLIB)")
            
    if lyrics:
        lrc_path = os.path.splitext(file_path)[0] + ".lrc"
        with open(lrc_path, "w", encoding="utf-8") as f:
            f.write(lyrics)
            
        alt_lrc_name = f"{artist_text} - {clean_title_text}.lrc"
        alt_lrc_path = os.path.join(os.path.dirname(file_path), alt_lrc_name)
        if alt_lrc_path != lrc_path:
            try:
                with open(alt_lrc_path, "w", encoding="utf-8") as f:
                    f.write(lyrics)
            except Exception:
                pass

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
    ytdlp_queries = []

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
        elif "youtube.com" in query.lower() or "youtu.be" in query.lower() or query.lower().startswith("ytsearch"):
            print(f"[{task_id}] Enlace de YouTube detectado, enrutando directo a yt-dlp: {query}")
            ytdlp_queries.append(query)
            query_map[query] = {"original_query": query}
        elif "spotify.com/track" in query:
            spotdl_queries.append(query)
            query_map[query] = {"original_query": query}
        elif "deezer.com" in query:
            deezer_urls.append(query)
            query_map[query] = {"original_query": query}
        else:
            # Búsquedas de texto plano van a spotDL directo
            spotdl_queries.append(query)
            query_map[query] = {"original_query": query}
            
    os.makedirs(MEDIA_DIR, exist_ok=True)
            
    failed_deemix = []
    if deezer_urls:
        print(f"[{task_id}] Fase 2: Ejecutando Deemix para {len(deezer_urls)} pistas...")
        for url in deezer_urls:
            deemix_tmp = os.path.join(MEDIA_DIR, f".deemix_tmp_{uuid.uuid4().hex[:6]}")
            os.makedirs(deemix_tmp, exist_ok=True)
            
            command_deemix = [get_deemix_binary(), "--bitrate", "320", "-p", deemix_tmp, url]
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
        if track['artist'] == "Unknown" and track['title'] == "Unknown":
            spotdl_queries.append(track['query'])
        else:
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

    all_ytdlp = ytdlp_queries + failed_spotdl
    if all_ytdlp:
        print(f"[{task_id}] Fase 4: Ejecutando yt-dlp para {len(all_ytdlp)} pistas...")
        env = os.environ.copy()
        deno_path = os.path.expanduser("~/.deno/bin")
        if deno_path not in env.get("PATH", ""):
            env["PATH"] = deno_path + ":" + env.get("PATH", "")
        
        for query in all_ytdlp:
            clean_q = query.replace('"', '').replace("'", "")
            search_query = query if query.startswith("http") else f"ytsearch1:{clean_q} audio"
            
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
                    
                for tmp_f in glob.glob(f"{ytdlp_tmp}/*"):
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

        # 1.5 Si ya existe una playlist con ese nombre, reutilizarla para evitar duplicados
        try:
            get_url = f"{JELLYFIN_URL.rstrip('/')}/Users/{user_id}/Items" if user_id else f"{JELLYFIN_URL.rstrip('/')}/Items"
            get_params = {
                "IncludeItemTypes": "Playlist",
                "Recursive": "true",
            }
            check_res = await client.get(get_url, headers=headers, params=get_params)
            if check_res.status_code == 200:
                for existing in check_res.json().get("Items", []):
                    if existing.get("Name", "").strip().lower() == request.name.strip().lower():
                        print(f"Playlist '{request.name}' ya existe en Jellyfin (ID: {existing.get('Id')}). Evitando duplicado.")
                        return {"status": "success", "message": "Playlist ya existe", "playlist_id": existing.get("Id")}
        except Exception as e:
            print(f"Aviso al verificar existencia de playlist: {e}")

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
    """Obtiene las playlists del usuario (o todas) desde Jellyfin, deduplicando 'My likes' si existieran duplicados."""
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
            items = data.get("Items", [])
            
            # Deduplicar 'My likes' si Jellyfin tiene múltiples playlists con ese nombre
            likes_items = [it for it in items if it.get("Name", "").strip().lower() == "my likes"]
            if len(likes_items) > 1:
                # Ordenar: preferir la que tiene más canciones
                likes_items.sort(key=lambda x: x.get("ChildCount", 0), reverse=True)
                keeper = likes_items[0]
                duplicates = likes_items[1:]
                
                # Eliminar duplicados vacíos en Jellyfin
                for dup in duplicates:
                    dup_id = dup.get("Id")
                    if dup_id and dup.get("ChildCount", 0) == 0:
                        try:
                            await client.delete(f"{JELLYFIN_URL.rstrip('/')}/Items/{dup_id}", headers=headers)
                            print(f"Eliminado duplicado vacío de 'My likes': {dup_id}")
                        except Exception as err:
                            print(f"Aviso eliminando duplicado de playlist {dup_id}: {err}")
                
                # Filtrar la lista devuelta para que solo contenga un 'My likes'
                dup_ids = {d.get("Id") for d in duplicates}
                items = [it for it in items if it.get("Id") not in dup_ids]

            return items
    except Exception as e:
        print(f"Error obteniendo playlists: {e}")
        raise HTTPException(status_code=500, detail=f"Error obteniendo playlists de Jellyfin: {e}")

def get_search_variations(query: str, artist: str = None) -> List[str]:
    """Genera múltiples variaciones de búsqueda para asegurar coincidencias en Jellyfin."""
    if not query:
        return []
    variations = []
    
    def add_var(v):
        if not v:
            return
        v = v.strip()
        if len(v) < 2:
            return
        if artist and v.lower() == artist.lower():
            return
        if v.lower() not in [x.lower() for x in variations]:
            variations.append(v)
            
    add_var(query)
    
    # 1. Normalizar barras y caracteres especiales
    norm = query.replace('｜', ' ').replace('|', ' ').replace('／', ' ').replace('/', ' ').replace('—', '-').replace('–', '-')
    norm = re.sub(r'\s+', ' ', norm).strip()
    add_var(norm)
    
    # 2. Quitar etiquetas típicas de YouTube/Deezer entre paréntesis o corchetes
    no_yt = re.sub(r'[\(\[][^\)\]]*(official|video|audio|lyric|visualizer|live|cover|remix|hd|hq|4k|mv|clip|version|explicit|prod|directed|visual)[^\)\]]*[\)\]]', '', norm, flags=re.IGNORECASE)
    no_yt = re.sub(r'[\(\[][fF]eat\.?.*?[\]\)]', '', no_yt)
    no_yt = re.sub(r'[\(\[][wW]ith\.?.*?[\]\)]', '', no_yt)
    no_yt = re.sub(r'[\(\[][rR]emastered.*?[\]\)]', '', no_yt, flags=re.IGNORECASE)
    no_yt = re.sub(r' - [rR]emastered.*', '', no_yt, flags=re.IGNORECASE)
    no_yt = re.sub(r'\s+', ' ', no_yt).strip()
    add_var(no_yt)
    
    # 3. Formato Artista - Título de YouTube
    for base in [norm, no_yt, query]:
        if ' - ' in base:
            parts = base.split(' - ', 1)
            title_part = parts[1].strip()
            add_var(title_part)
            clean_part = re.sub(r'[\(\[][^\)\]]*[\)\]]', '', title_part).strip()
            add_var(clean_part)
            
    # 4. Si se especificó artista y empieza con el artista
    if artist:
        art_clean = artist.strip().lower()
        for base in list(variations):
            if base.lower().startswith(f"{art_clean} "):
                add_var(base[len(art_clean):].strip(' -:_'))
            elif base.lower().startswith(f"{art_clean}-"):
                add_var(base[len(art_clean)+1:].strip(' -:_'))
                
    # 5. Cortar en delimitadores (subtítulos, barras, etc.)
    for base in list(variations):
        for delim in [' : ', ' - ', ' | ']:
            if delim in base:
                first_chunk = base.split(delim, 1)[0].strip()
                add_var(first_chunk)
                
    return variations

def clean_title_for_search(title: str) -> str:
    """Limpia el título de colaboraciones, remasterizaciones y caracteres superfluos para buscar en Jellyfin."""
    vars = get_search_variations(title)
    return vars[1] if len(vars) > 1 else (title or "")

async def check_jellyfin_local(query: str, client: httpx.AsyncClient = None, artist: str = None, album: str = None):
    """Verifica si la canción ya existe en la biblioteca local de Jellyfin."""
    if not JELLYFIN_API_KEY:
        return {"exists": False}

    if isinstance(client, str):
        artist = client
        client = None

    url = f"{JELLYFIN_URL.rstrip('/')}/Items"
    headers = {
        "X-Emby-Token": JELLYFIN_API_KEY
    }

    async def do_req(c, search_term):
        try:
            params = {
                "SearchTerm": search_term,
                "Recursive": "true",
                "IncludeItemTypes": "Audio",
                "Limit": 20,
                "Fields": "PrimaryImageAspectRatio,CanDelete,BasicSyncInfo,MediaSourceCount,Artists,AlbumArtist,AlbumId,ImageTags,ParentId,AlbumPrimaryImageTag,Overview"
            }
            response = await c.get(url, params=params, headers=headers)
            response.raise_for_status()
            data = response.json()
            items = data.get("Items", [])
            if items:
                # 1. Si se especificó álbum, priorizar coincidencia de álbum
                if album:
                    album_clean = album.lower().strip()
                    for item in items:
                        item_album = item.get("Album", "").lower().strip()
                        if item_album == album_clean or album_clean in item_album or item_album in album_clean:
                            if artist:
                                artist_clean = artist.lower().strip()
                                item_artists = [a.lower().strip() for a in item.get("Artists", [])]
                                album_artist = item.get("AlbumArtist", "").lower().strip()
                                if (artist_clean in item_artists or 
                                    any(artist_clean in a or a in artist_clean for a in item_artists) or 
                                    artist_clean in album_artist or 
                                    album_artist in artist_clean):
                                    return {"exists": True, "data": item, "data_list": items, "same_album": True}
                            else:
                                return {"exists": True, "data": item, "data_list": items, "same_album": True}

                if artist:
                    artist_clean = artist.lower().strip()
                    for item in items:
                        item_artists = [a.lower().strip() for a in item.get("Artists", [])]
                        album_artist = item.get("AlbumArtist", "").lower().strip()
                        if (artist_clean in item_artists or 
                            any(artist_clean in a or a in artist_clean for a in item_artists) or 
                            artist_clean in album_artist or 
                            album_artist in artist_clean):
                            return {"exists": True, "data": item, "data_list": items, "same_album": False}

                    # Coincidencia por título limpio (resuelve artistas de canal YouTube vs artista real)
                    clean_q = clean_title_for_search(search_term).lower().strip()
                    for item in items:
                        item_name = item.get("Name", "").lower().strip()
                        clean_item = clean_title(item_name).lower().strip()
                        if (item_name == clean_q or 
                            clean_q in item_name or 
                            item_name in clean_q or
                            clean_item == clean_q or
                            clean_item in clean_q or
                            clean_q in clean_item or
                            any(v.lower() == item_name or v.lower() in item_name or item_name in v.lower() for v in get_search_variations(search_term))):
                            return {"exists": True, "data": item, "data_list": items, "same_album": False}
                else:
                    return {"exists": True, "data": items[0], "data_list": items, "same_album": False}
        except Exception as e:
            print(f"Error consultando caché local de Jellyfin para '{search_term}': {e}")
        return {"exists": False}

    async def execute(c):
        variations = get_search_variations(query, artist=artist)
        for var in variations:
            res = await do_req(c, var)
            if res.get("exists"):
                return res
        return {"exists": False}

    if client:
        return await execute(client)
    else:
        async with httpx.AsyncClient() as c:
            return await execute(c)

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
        "jellyfin_data": local_check.get("data") if local_check["exists"] else None,
        "jellyfin_data_list": local_check.get("data_list", [])
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
                    raw_title = entry.get("title", "Unknown Title")
                    uploader = entry.get("uploader", "Unknown Artist")
                    
                    parsed_artist = uploader
                    parsed_title = raw_title
                    norm_raw = raw_title.replace('｜', '|').replace('／', '/').replace('—', '-').replace('–', '-')
                    if " - " in norm_raw:
                        t_parts = norm_raw.split(" - ", 1)
                        parsed_artist = t_parts[0].strip()
                        parsed_title = t_parts[1].strip()
                        
                    video_url = entry.get("webpage_url") or entry.get("url") or ""
                    results.append({
                        "title": parsed_title,
                        "artist": parsed_artist,
                        "raw_title": raw_title,
                        "duration": entry.get("duration_string", ""),
                        "url": video_url,
                        "query_string": video_url,
                        "cover_url": entry.get("thumbnail", ""),
                        "source": "youtube"
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
                # Se prioriza coincidencia exacta con el álbum y artista actual.
                album_title = album_data.get('title')
                album_artist = album_data.get('artist', artist)
                local_check = await check_jellyfin_local(title, client=jf_client, artist=album_artist, album=album_title)
                if not local_check.get("exists"):
                    local_check = await check_jellyfin_local(f"{title} {artist}", client=jf_client, artist=album_artist, album=album_title)
            
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
                        "same_album": local_check.get("same_album", False),
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
    import glob
    
    clean_t = clean_title(title)
    if not clean_t:
        clean_t = title
        
    clean_a = artist.strip()
    norm_a = clean_a.replace('｜', '|').replace('／', '/').replace('—', '-').replace('–', '-')
    if " - " in norm_a:
        clean_a = norm_a.split(" - ", 1)[0].strip()
    
    # 1. Intento local exacto
    possible_filenames = [
        f"{clean_a} - {title}.lrc",
        f"{clean_a} - {clean_t}.lrc",
        f"{artist} - {title}.lrc",
        f"{artist} - {clean_t}.lrc",
        f"{clean_t}.lrc",
        f"{title}.lrc",
        f"{clean_a} - {title}.txt",
        f"{clean_a} - {clean_t}.txt",
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
                
    # 2. Búsqueda local por coincidencia de nombre de pista
    try:
        t_low = clean_t.lower()
        if len(t_low) >= 3:
            for lrc_file in glob.glob(os.path.join(MEDIA_DIR, "*.lrc")):
                lrc_name = os.path.basename(lrc_file).lower()
                if t_low in lrc_name:
                    with open(lrc_file, 'r', encoding='utf-8') as f:
                        return {"status": "success", "lyrics": f.read(), "source": "local"}
    except Exception as e:
        print(f"Error en búsqueda flexible de letras locales: {e}")
                
    # 3. Fallback a LRCLIB (API Pública y Gratuita)
    print(f"Letras locales no encontradas. Buscando en LRCLIB para: {clean_a} - {clean_t}")
    headers = {"User-Agent": "SynapMusic (https://github.com/tu-usuario/SynapMusic)"}
    
    # 3.1 Intento get exacto
    for art, tit in [(clean_a, clean_t), (artist, title)]:
        try:
            url = f"https://lrclib.net/api/get?artist_name={urllib.parse.quote(art)}&track_name={urllib.parse.quote(tit)}"
            async with httpx.AsyncClient() as client:
                response = await client.get(url, headers=headers, timeout=4.0)
                if response.status_code == 200:
                    data = response.json()
                    lyrics = data.get("syncedLyrics") or data.get("plainLyrics")
                    if lyrics:
                        filepath = os.path.join(MEDIA_DIR, f"{clean_a} - {clean_t}.lrc")
                        try:
                            with open(filepath, 'w', encoding='utf-8') as f:
                                f.write(lyrics)
                        except:
                            pass
                        return {"status": "success", "lyrics": lyrics, "source": "lrclib"}
        except Exception:
            pass

    # 3.2 Intento search en LRCLIB
    try:
        search_q = f"{clean_a} {clean_t}".strip()
        url = f"https://lrclib.net/api/search?q={urllib.parse.quote(search_q)}"
        async with httpx.AsyncClient() as client:
            response = await client.get(url, headers=headers, timeout=4.0)
            if response.status_code == 200:
                items = response.json()
                if items and isinstance(items, list):
                    for it in items:
                        lyrics = it.get("syncedLyrics") or it.get("plainLyrics")
                        if lyrics:
                            filepath = os.path.join(MEDIA_DIR, f"{clean_a} - {clean_t}.lrc")
                            try:
                                with open(filepath, 'w', encoding='utf-8') as f:
                                    f.write(lyrics)
                            except:
                                pass
                            return {"status": "success", "lyrics": lyrics, "source": "lrclib"}
    except Exception as e:
        print(f"Error en búsqueda general LRCLIB: {e}")
        
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

class UpdateUserNameRequest(BaseModel):
    name: str

@app.post("/users/{user_id}/name", dependencies=[Depends(get_api_key)])
async def update_user_name(user_id: str, req: UpdateUserNameRequest):
    """Actualiza el nombre de un usuario en Jellyfin."""
    headers = {"X-Emby-Token": JELLYFIN_API_KEY}
    async with httpx.AsyncClient() as client:
        get_user_url = f"{JELLYFIN_URL}/Users/{user_id}"
        user_resp = await client.get(get_user_url, headers=headers)
        if user_resp.status_code != 200:
            raise HTTPException(status_code=404, detail="Usuario no encontrado")
        
        user_data = user_resp.json()
        user_data["Name"] = req.name
        
        update_url = f"{JELLYFIN_URL}/Users/{user_id}"
        update_resp = await client.post(update_url, headers=headers, json=user_data)
        if update_resp.status_code not in [200, 204]:
            raise HTTPException(status_code=500, detail="Error actualizando nombre en Jellyfin")
        return {"status": "success", "message": "Nombre actualizado", "name": req.name}

@app.post("/users/{user_id}/avatar", dependencies=[Depends(get_api_key)])
async def update_user_avatar(user_id: str, request: Request):
    """Actualiza la foto de perfil del usuario en Jellyfin."""
    headers = {
        "X-Emby-Token": JELLYFIN_API_KEY,
        "Content-Type": request.headers.get("content-type", "image/jpeg")
    }
    body = await request.body()
    async with httpx.AsyncClient() as client:
        avatar_url = f"{JELLYFIN_URL}/Users/{user_id}/Images/Primary"
        resp = await client.post(avatar_url, headers=headers, content=body)
        if resp.status_code not in [200, 204]:
            raise HTTPException(status_code=500, detail="Error subiendo avatar a Jellyfin")
        return {"status": "success", "message": "Avatar actualizado"}

@app.post("/feedback", dependencies=[Depends(get_api_key)])
async def submit_feedback(
    user_id: str = Form(...),
    user_name: str = Form(...),
    title: str = Form(...),
    message: str = Form(...),
    files: Optional[List[UploadFile]] = File(None)
):
    """Guarda un nuevo comentario de retroalimentación con fecha y hora CDMX."""
    now_cdmx = datetime.datetime.now(ZoneInfo("America/Mexico_City")).strftime("%d/%m/%Y %I:%M %p")
    image_filenames = []
    
    if files:
        for file in files:
            if file and file.filename:
                ext = os.path.splitext(file.filename)[1] or ".jpg"
                unique_name = f"{uuid.uuid4().hex}{ext}"
                file_path = os.path.join(FEEDBACK_DIR, unique_name)
                content = await file.read()
                if content:
                    with open(file_path, "wb") as f:
                        f.write(content)
                    image_filenames.append(unique_name)
                    
    conn = sqlite3.connect(FEEDBACK_DB)
    cursor = conn.cursor()
    cursor.execute("""
        INSERT INTO feedback (user_id, user_name, title, message, created_at, images)
        VALUES (?, ?, ?, ?, ?, ?)
    """, (user_id, user_name, title, message, now_cdmx, json.dumps(image_filenames)))
    feedback_id = cursor.lastrowid
    conn.commit()
    conn.close()
    
    return {
        "status": "success",
        "message": "Comentario enviado con éxito",
        "id": feedback_id,
        "created_at": now_cdmx
    }

@app.get("/feedback", dependencies=[Depends(get_api_key)])
async def get_feedback_list():
    """Obtiene la lista de comentarios para administradores."""
    conn = sqlite3.connect(FEEDBACK_DB)
    cursor = conn.cursor()
    cursor.execute("""
        SELECT id, user_id, user_name, title, message, created_at, images
        FROM feedback
        ORDER BY id DESC
    """)
    rows = cursor.fetchall()
    conn.close()
    
    results = []
    for row in rows:
        images_list = []
        try:
            images_list = json.loads(row[6]) if row[6] else []
        except Exception:
            images_list = []
            
        results.append({
            "id": row[0],
            "user_id": row[1],
            "user_name": row[2],
            "title": row[3],
            "message": row[4],
            "created_at": row[5],
            "images": images_list
        })
    return results

@app.delete("/feedback/{feedback_id}", dependencies=[Depends(get_api_key)])
async def delete_feedback(feedback_id: int):
    """Elimina un comentario y sus imágenes asociadas."""
    conn = sqlite3.connect(FEEDBACK_DB)
    cursor = conn.cursor()
    cursor.execute("SELECT images FROM feedback WHERE id = ?", (feedback_id,))
    row = cursor.fetchone()
    if not row:
        conn.close()
        raise HTTPException(status_code=404, detail="Comentario no encontrado")
        
    try:
        images = json.loads(row[0]) if row[0] else []
        for img in images:
            img_path = os.path.join(FEEDBACK_DIR, img)
            if os.path.exists(img_path):
                os.remove(img_path)
    except Exception as e:
        print(f"Error borrando imágenes de feedback: {e}")
        
    cursor.execute("DELETE FROM feedback WHERE id = ?", (feedback_id,))
    conn.commit()
    conn.close()
    return {"status": "success", "message": "Comentario eliminado"}

@app.get("/feedback/images/{filename}")
async def get_feedback_image(filename: str):
    """Sirve las imágenes adjuntas a los comentarios."""
    file_path = os.path.join(FEEDBACK_DIR, filename)
    if not os.path.exists(file_path):
        raise HTTPException(status_code=404, detail="Imagen no encontrada")
    return FileResponse(file_path)

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

# ==========================================
# GESTIÓN Y SINCRONIZACIÓN DE TOP 10 MÉXICO
# ==========================================

_active_top_mexico_downloads = set()
_top_mexico_download_lock = asyncio.Lock()

async def get_curated_top_mexico_tracks(client: httpx.AsyncClient) -> list:
    """Obtiene las 10 canciones oficiales del Top México desde Deezer con variación y ranking."""
    playlist_id = "1111142361"
    tracks = []
    
    # 1. Scraping web para extraer indicadores de variación (subió / bajó)
    try:
        web_res = await client.get(f"https://www.deezer.com/es/playlist/{playlist_id}", timeout=6.0)
        if web_res.status_code == 200:
            matches = re.findall(r"<script[^>]*>(.*?)</script>", web_res.text, re.DOTALL)
            for s in matches:
                if "SONGS" in s and "SNG_TITLE" in s:
                    m = re.search(r"({.*\"SONGS\".*})", s)
                    if m:
                        dz_state = json.loads(m.group(1))
                        raw_songs = dz_state.get("SONGS", {}).get("data", [])
                        for sng in raw_songs[:10]:
                            alb_pic = sng.get("ALB_PICTURE")
                            cover = f"https://cdn-images.dzcdn.net/images/cover/{alb_pic}/500x500.jpg" if alb_pic else None
                            tracks.append({
                                "id": str(sng.get("SNG_ID")),
                                "title": sng.get("SNG_TITLE"),
                                "artist": sng.get("ART_NAME", "Unknown"),
                                "cover_url": cover,
                                "query_string": f"https://www.deezer.com/track/{sng.get('SNG_ID')}",
                                "variation": int(sng.get("VARIATION", 0))
                            })
                        break
    except Exception as ex:
        print("[Top10] Scraping web Deezer no disponible, usando fallback API:", ex)

    # 2. Fallback a la API de Deezer
    if not tracks:
        try:
            api_res = await client.get(f"https://api.deezer.com/playlist/{playlist_id}", timeout=6.0)
            if api_res.status_code == 200:
                api_data = api_res.json().get("tracks", {}).get("data", [])
                for item in api_data[:10]:
                    tracks.append({
                        "id": str(item.get("id")),
                        "title": item.get("title"),
                        "artist": item.get("artist", {}).get("name", "Unknown"),
                        "cover_url": item.get("album", {}).get("cover_medium"),
                        "query_string": item.get("link") or f"https://www.deezer.com/track/{item.get('id')}",
                        "variation": 0
                    })
        except Exception as ex:
            print("[Top10] Error en fallback API Deezer:", ex)
            
    return tracks

def _download_missing_top_background(queries: List[str]):
    try:
        print(f"[Top10] Iniciando descarga automática de {len(queries)} pistas faltantes...")
        run_dual_download(queries)
        print(f"[Top10] Descarga de canciones del Top 10 completada con éxito.")
    except Exception as e:
        print(f"[Top10] Error en descarga automática en segundo plano: {e}")
    finally:
        for q in queries:
            _active_top_mexico_downloads.discard(q)

async def sync_top_mexico(auto_download: bool = True) -> list:
    """
    Sincroniza la lista de Top 10 México con Deezer y Jellyfin.
    Si faltan pistas en la biblioteca local, las encola automáticamente para su descarga.
    """
    try:
        async with httpx.AsyncClient(headers={"User-Agent": "Mozilla/5.0"}) as client:
            tracks = await get_curated_top_mexico_tracks(client)
            if not tracks:
                return []

            results = []
            missing_queries = []

            for item in tracks:
                title = item["title"]
                artist = item["artist"]
                query_str = item.get("query_string") or f"https://www.deezer.com/track/{item['id']}"

                # Comprobar si ya existe en Jellyfin
                local_data = await check_jellyfin_local(title, client=client, artist=artist)
                if not local_data.get("exists"):
                    local_data = await check_jellyfin_local(f"{title} {artist}", client=client, artist=artist)

                jellyfin_item = None
                local_id = None
                if local_data.get("exists") and "data" in local_data:
                    local_id = local_data["data"].get("Id")
                    jellyfin_item = local_data["data"]
                    if jellyfin_item.get("ImageTags", {}).get("Primary"):
                        jellyfin_item["ImageTags"]["Primary"] = jellyfin_item["ImageTags"]["Primary"]
                else:
                    # Falta en la biblioteca local
                    if query_str not in _active_top_mexico_downloads:
                        missing_queries.append(query_str)

                var_val = item.get("variation", 0)
                if var_val > 0:
                    indicator = "up"
                elif var_val < 0:
                    indicator = "down"
                else:
                    indicator = "same"

                results.append({
                    "id": item["id"],
                    "title": title,
                    "artist": artist,
                    "cover_url": item["cover_url"],
                    "query_string": query_str,
                    "local_id": local_id,
                    "jellyfin_item": jellyfin_item,
                    "variation": var_val,
                    "indicator": indicator
                })

            if auto_download and missing_queries:
                async with _top_mexico_download_lock:
                    to_download = [q for q in missing_queries if q not in _active_top_mexico_downloads]
                    for q in to_download:
                        _active_top_mexico_downloads.add(q)
                    if to_download:
                        print(f"[Top10] Encolando descarga automática de {len(to_download)} canciones no presentes en el servidor...")
                        asyncio.create_task(asyncio.to_thread(_download_missing_top_background, to_download))

            return results
    except Exception as e:
        print("[Top10] Error sincronizando Top 10 México:", e)
        return []

async def fetch_top_mexico_and_download():
    """Ejecutado por startup y cron para descargar automáticamente canciones del Top 10."""
    await sync_top_mexico(auto_download=True)

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
    print("Iniciando verificación de Top 10 México en startup...")
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

def split_artist_names(artist_str: str) -> list[str]:
    if not artist_str:
        return []
    text = artist_str.strip()
    if text.upper() == "AC/DC":
        return ["AC/DC"]
    text = re.sub(r'(?i)\bac/dc\b', '__AC_DC__', text)
    pattern = r'(?:\s*[/;]\s*|\s+feat\.?\s+|\s+ft\.?\s+|\s+featuring\s+|\s+with\s+|\s+&\s+|\s*,\s*|\s+[xX]\s+)'
    parts = re.split(pattern, text, flags=re.IGNORECASE)
    cleaned = []
    for p in parts:
        p = p.replace('__AC_DC__', 'AC/DC').strip()
        if p and p not in cleaned:
            cleaned.append(p)
    return cleaned if cleaned else [artist_str]

_top_artists_cache = {}  # {user_id: {"timestamp": float, "data": list}}

@app.get("/home/top-artists", dependencies=[Depends(get_api_key)])
async def get_top_artists(user_id: str):
    if not JELLYFIN_API_KEY: return []

    now = time.time()
    if user_id in _top_artists_cache:
        cached = _top_artists_cache[user_id]
        if now - cached.get("timestamp", 0) < 300:
            return cached.get("data", [])

    url = f"{JELLYFIN_URL.rstrip('/')}/Users/{user_id}/Items"
    params = {
        "IncludeItemTypes": "Audio",
        "SortBy": "PlayCount",
        "SortOrder": "Descending",
        "Limit": 150,
        "Recursive": "true"
    }
    headers = {"X-Emby-Token": JELLYFIN_API_KEY}
    try:
        async with httpx.AsyncClient() as client:
            res = await client.get(url, params=params, headers=headers)
            res.raise_for_status()
            items = res.json().get("Items", [])
            
            # Aggregate play counts per individual artist (splitting collaborations)
            artist_scores = {}
            for item in items:
                user_data = item.get("UserData") or {}
                play_count = (user_data.get("PlayCount") or 0) + 1
                
                artist_names = []
                artist_items = item.get("ArtistItems", [])
                if artist_items:
                    for a in artist_items:
                        raw_name = a.get("Name")
                        if raw_name:
                            artist_names.extend(split_artist_names(raw_name))
                else:
                    for raw_name in item.get("Artists", []):
                        artist_names.extend(split_artist_names(raw_name))
                
                seen_in_track = set()
                for name in artist_names:
                    clean = name.strip()
                    if not clean:
                        continue
                    key = clean.lower()
                    if key in seen_in_track:
                        continue
                    seen_in_track.add(key)
                    
                    if key not in artist_scores:
                        artist_scores[key] = {"name": clean, "score": 0}
                    artist_scores[key]["score"] += play_count
                    if clean != clean.lower():
                        artist_scores[key]["name"] = clean

            sorted_artists = sorted(artist_scores.values(), key=lambda x: x["score"], reverse=True)
            top_candidates = [a["name"] for a in sorted_artists[:15]]

            sem = asyncio.Semaphore(3)

            async def fetch_dz_artist(artist_name: str):
                async with sem:
                    try:
                        await asyncio.sleep(0.04)
                        dz_res = await client.get(
                            "https://api.deezer.com/search/artist",
                            params={"q": artist_name, "limit": 1},
                            timeout=5.0
                        )
                        if dz_res.status_code == 200:
                            dz_data = dz_res.json().get("data", [])
                            if dz_data:
                                dz_artist = dz_data[0]
                                pic = dz_artist.get("picture_medium") or dz_artist.get("picture_big")
                                if pic and "artist//" not in pic and "//250x250" not in pic:
                                    return {
                                        "id": str(dz_artist.get("id")),
                                        "name": dz_artist.get("name") or artist_name,
                                        "cover_url": pic
                                    }
                    except Exception:
                        pass
                    return None

            tasks = [fetch_dz_artist(cand) for cand in top_candidates]
            dz_results = await asyncio.gather(*tasks)

            unique_artists = []
            seen_ids = set()
            for a in dz_results:
                if a and a["id"] not in seen_ids:
                    seen_ids.add(a["id"])
                    unique_artists.append(a)
                    if len(unique_artists) >= 10:
                        break

            _top_artists_cache[user_id] = {"timestamp": now, "data": unique_artists}
            return unique_artists
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
    return await sync_top_mexico(auto_download=True)
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
                # Fallback: if collaboration or delimiter present, try individual candidates
                candidates = split_artist_names(artist_name)
                for cand in candidates:
                    if cand.lower() != artist_name.lower():
                        try:
                            cand_res = await client.get("https://api.deezer.com/search/artist", params={"q": cand, "limit": 1})
                            if cand_res.status_code == 200:
                                cand_data = cand_res.json().get("data", [])
                                if cand_data:
                                    dz_data = cand_data
                                    break
                        except Exception:
                            pass
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
                jellyfin_item = local_data.get("data") if local_data.get("exists") else None
                
                formatted_tracks.append({
                    "id": str(t.get("id")),
                    "title": title,
                    "cover_url": t.get("album", {}).get("cover_medium") if t.get("album") else artist.get("picture_medium"),
                    "query_string": t.get("link"),
                    "local_id": local_id,
                    "jellyfin_item": jellyfin_item
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
                    album_id = items[0].get("AlbumId") or items[0].get("ParentPrimaryImageItemId")
                    if album_id and album_id != item_id:
                        try:
                            post_url_album = f"{JELLYFIN_URL}/Items/{album_id}/Images/Primary"
                            await c2.post(post_url_album, headers=headers_post, content=cover_bytes)
                        except Exception as e_alb:
                            print(f"No se pudo sincronizar portada en el álbum Jellyfin: {e_alb}")
                    
            items[0]["Name"] = request.query
            update_url = f"{JELLYFIN_URL}/Items/{item_id}"
            headers_json = {"X-Emby-Token": JELLYFIN_API_KEY, "Content-Type": "application/json"}
            async with httpx.AsyncClient() as c3:
                await c3.post(update_url, headers=headers_json, json=items[0])
                
            await update_jellyfin_library()
            return {"status": "success", "message": "Metadata updated successfully"}
            
    except Exception as e:
        return {"status": "error", "message": str(e)}

@app.get("/music/check-local", dependencies=[Depends(get_api_key)])
async def check_track_local(title: str, artist: str = None):
    """Permite al cliente móvil comprobar en tiempo real si una pista ya está disponible en Jellyfin."""
    local_data = await check_jellyfin_local(title, artist=artist)
    
    item = local_data.get("data") if local_data.get("exists") else None
    is_ready = False
    if item:
        has_artist = bool(item.get("Artists") or item.get("AlbumArtist"))
        has_image = bool(item.get("ImageTags", {}).get("Primary") or item.get("AlbumPrimaryImageTag") or item.get("ParentId") or item.get("AlbumId"))
        is_ready = has_artist or bool(item.get("Name"))

    return {
        "exists": local_data.get("exists", False),
        "is_ready": is_ready,
        "local_id": item.get("Id") if item else None,
        "jellyfin_item": item
    }

@app.get("/debug/local-check")
async def debug_local_check(q: str, artist: str = None):
    local_data = await check_jellyfin_local(q, artist=artist)
    return {"query": q, "artist": artist, "result": local_data}

# ==========================================
# RUTAS PÚBLICAS: PORTAL Y DESCARGA DE APK
# ==========================================

@app.get("/", response_class=HTMLResponse)
async def portal_index():
    index_path = os.path.join(PORTAL_DIR, "index.html")
    if os.path.exists(index_path):
        return FileResponse(index_path)
    return HTMLResponse("<h1>SynapHub</h1><p>Portal no configurado.</p>")

@app.get("/synapmusic", response_class=HTMLResponse)
async def portal_synapmusic():
    synapmusic_path = os.path.join(PORTAL_DIR, "synapmusic.html")
    if os.path.exists(synapmusic_path):
        return FileResponse(synapmusic_path)
    return HTMLResponse("<h1>SynapMusic</h1><p>Página en construcción.</p>")

@app.get("/synapmusic/download")
@app.get("/descargar")
async def download_apk():
    apk_path = os.path.join(PORTAL_DIR, "downloads", "synapmusic.apk")
    if not os.path.exists(apk_path):
        fallback = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "cliente-finamp", "build", "app", "outputs", "flutter-apk", "app-release.apk"))
        if os.path.exists(fallback):
            apk_path = fallback
        else:
            raise HTTPException(status_code=404, detail="El archivo APK de SynapMusic aún no está disponible.")
    return FileResponse(
        path=apk_path,
        filename="SynapMusic.apk",
        media_type="application/vnd.android.package-archive"
    )

@app.get("/api/v1/version")
async def get_app_version():
    return {
        "app_name": "SynapMusic",
        "version": "0.6.28",
        "version_code": 53,
        "download_url": "/synapmusic/download",
        "release_date": "2026-09-06",
        "min_android_version": "Android 8.0+",
        "changelog": "Sincronización unificada de Top 10 México con auto-descarga en segundo plano, soporte de Pull-to-Refresh y correcciones de estabilidad."
    }

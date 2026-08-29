import re

with open('api-descargas/main.py', 'r') as f:
    content = f.read()

# Replace the entire search_music function to fix indentation
pattern = r'async def search_music\(q: str, source: str = "deezer", limit: int = 15, offset: int = 0\):.*?return \{\n\s+"local_match": local_match_data,\n\s+"remote_results": results\n\s+\}'

new_func = """async def search_music(q: str, source: str = "deezer", limit: int = 15, offset: int = 0):
    \"\"\"
    Busca música: validación en Jellyfin (Caché Local) y opciones externas vía Deezer o YouTube.
    \"\"\"
    import json
    import re as _re

    if not q:
        return {"local_match": {"exists": False, "jellyfin_data": None}, "remote_results": []}

    local_check = await check_jellyfin_local(q)
    if not local_check["exists"]:
        parts = _re.split(r'[,\\-]', q)
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
    }"""

content = re.sub(pattern, new_func, content, flags=re.DOTALL)

with open('api-descargas/main.py', 'w') as f:
    f.write(content)


import re

with open('api-descargas/main.py', 'r') as f:
    content = f.read()

pattern = r'(async def fetch_top_mexico_and_download\(\):.*?print\(f"Error en top mexico task: \{e\}"\))'

new_func = """async def fetch_top_mexico_and_download():
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
        print(f"Error en top mexico task: {e}")"""

if re.search(pattern, content, flags=re.DOTALL):
    content = re.sub(pattern, new_func, content, flags=re.DOTALL)
    with open('api-descargas/main.py', 'w') as f:
        f.write(content)
    print("Patched successfully")
else:
    print("Pattern not found")

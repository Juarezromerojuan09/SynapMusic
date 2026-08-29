import re

# 1. Update main.py with the URL expander and import
with open('api-descargas/main.py', 'r') as f:
    main_content = f.read()

if "from playlist_migrator import run_migration_task" not in main_content:
    main_content = main_content.replace(
        "from fastapi import FastAPI,", 
        "from fastapi import FastAPI,\nfrom playlist_migrator import run_migration_task\n"
    )

expander_code = """
async def expand_url(url: str) -> str:
    \"\"\"Expande URLs acortadas (ej. link.deezer.com) a su URL real.\"\"\"
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
"""

if "async def expand_url" not in main_content:
    # Replace the old endpoint if it exists
    if "@app.post(\"/download/playlist-migration\"" in main_content:
        # Regex to remove old endpoint
        main_content = re.sub(r'@app\.post\("/download/playlist-migration"[\s\S]+?return \{\n.+?\n.+?\n.+?\}', expander_code.strip(), main_content)
    else:
        main_content += "\n" + expander_code

with open('api-descargas/main.py', 'w') as f:
    f.write(main_content)

print("main.py patched successfully")

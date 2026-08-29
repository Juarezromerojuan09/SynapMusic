with open('api-descargas/main.py', 'r') as f:
    content = f.read()

import re

# Add import
if "from playlist_migrator import run_migration_task" not in content:
    content = content.replace("from fastapi import FastAPI, HTTPException, BackgroundTasks, Depends", "from fastapi import FastAPI, HTTPException, BackgroundTasks, Depends\nfrom playlist_migrator import run_migration_task")

# Add MigrationRequest model
if "class MigrationRequest(BaseModel):" not in content:
    model = """class MigrationRequest(BaseModel):
    url: str
    user_id: str
"""
    content = content.replace("class PlaylistCreateRequest(BaseModel):", model + "\nclass PlaylistCreateRequest(BaseModel):")

# Add Endpoint
if "@app.post(\"/download/playlist-migration\"" not in content:
    endpoint = """@app.post("/download/playlist-migration", dependencies=[Depends(get_api_key)])
async def migrate_external_playlist(request: MigrationRequest, background_tasks: BackgroundTasks):
    if not request.url or not request.user_id:
        raise HTTPException(status_code=400, detail="Faltan parámetros")
        
    background_tasks.add_task(
        run_migration_task,
        request.url,
        request.user_id,
        JELLYFIN_URL,
        JELLYFIN_API_KEY
    )
    return {
        "status": "success",
        "message": "Migración inteligente de playlist iniciada en segundo plano."
    }
"""
    content += "\n" + endpoint

with open('api-descargas/main.py', 'w') as f:
    f.write(content)

print("Backend migration endpoint patched")

with open('api-descargas/main.py', 'r') as f:
    content = f.read()

import re

# Update PlaylistCreateRequest
old_model = """class PlaylistCreateRequest(BaseModel):
    name: str"""

new_model = """class PlaylistCreateRequest(BaseModel):
    name: str
    user_id: str = None"""

content = content.replace(old_model, new_model)

# Update create_playlist endpoint
old_create = """        # 1. Obtener el ID del primer usuario (usualmente el administrador)
        users_url = f"{JELLYFIN_URL.rstrip('/')}/Users"
        try:
            users_res = await client.get(users_url, headers=headers)
            users_res.raise_for_status()
            users_data = users_res.json()
            if not users_data:
                raise HTTPException(status_code=500, detail="No se encontraron usuarios en Jellyfin")
            admin_id = users_data[0]["Id"]
            
            # 2. Crear la playlist a nombre del admin
            playlist_url = f"{JELLYFIN_URL.rstrip('/')}/Playlists"
            params = {
                "Name": request.name,
                "UserId": admin_id,
                "MediaType": "Audio"
            }"""

new_create = """        try:
            user_id = request.user_id
            if not user_id:
                # Fallback to first user (admin) if not provided
                users_url = f"{JELLYFIN_URL.rstrip('/')}/Users"
                users_res = await client.get(users_url, headers=headers)
                users_res.raise_for_status()
                users_data = users_res.json()
                user_id = users_data[0]["Id"]
            
            # 2. Crear la playlist a nombre del usuario
            playlist_url = f"{JELLYFIN_URL.rstrip('/')}/Playlists"
            params = {
                "Name": request.name,
                "UserId": user_id,
                "MediaType": "Audio"
            }"""

content = content.replace(old_create, new_create)

with open('api-descargas/main.py', 'w') as f:
    f.write(content)

print("Backend playlist patched for user_id")

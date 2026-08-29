with open('api-descargas/main.py', 'r') as f:
    content = f.read()

import re

# Fix PlaylistCreateRequest
content = content.replace("user_id: str = None", "user_id: str | None = None")

old_create = """        # 1. Obtener el ID del primer usuario (usualmente el administrador)
        users_url = f"{JELLYFIN_URL.rstrip('/')}/Users"
        try:
            users_res = await client.get(users_url, headers=headers)
            users_res.raise_for_status()
            users_data = users_res.json()
            if not users_data:
                raise HTTPException(status_code=500, detail="No se encontraron usuarios en Jellyfin")
            admin_id = users_data[0]["Id"]
        except Exception as e:
            print(f"Error obteniendo usuarios de Jellyfin: {e}")
            raise HTTPException(status_code=500, detail=f"Error obteniendo usuarios de Jellyfin: {e}")

        # 2. Crear la playlist
        create_url = f"{JELLYFIN_URL.rstrip('/')}/Playlists"
        params = {
            "Name": request.name,
            "UserId": admin_id,
            "MediaType": "Audio"
        }"""

new_create = """        user_id = request.user_id
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
        }"""

content = content.replace(old_create, new_create)

with open('api-descargas/main.py', 'w') as f:
    f.write(content)

print("Backend playlist creation fixed")

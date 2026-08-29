with open('api-descargas/playlist_migrator.py', 'r') as f:
    content = f.read()

import re

# Add userId and raise_for_status to the POST /Items call
old_add = """        # 6. Añadir tracks a la playlist
        if found_ids:
            ids_str = ",".join(found_ids)
            await client.post(f"{base_url}/Playlists/{playlist_id}/Items", headers=headers, params={"Ids": ids_str})
            print("[Migrator] Playlist completada exitosamente.")"""

new_add = """        # 6. Añadir tracks a la playlist
        if found_ids:
            ids_str = ",".join(found_ids)
            try:
                res = await client.post(f"{base_url}/Playlists/{playlist_id}/Items", headers=headers, params={"Ids": ids_str, "userId": user_id})
                res.raise_for_status()
                print("[Migrator] Playlist completada exitosamente.")
            except Exception as e:
                print(f"[Migrator] Error CRITICO añadiendo tracks a la playlist: {e}")"""

content = content.replace(old_add, new_add)

with open('api-descargas/playlist_migrator.py', 'w') as f:
    f.write(content)

print("Migrator patched with userId for Items POST")

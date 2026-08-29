import re

with open('api-descargas/main.py', 'r') as f:
    content = f.read()

search_music_pattern = r'local_check = await check_jellyfin_local\(q\)\n\s+local_match_data = \{'
search_music_new = """local_check = await check_jellyfin_local(q)
    if not local_check["exists"]:
        # Intento de búsqueda relajada (si el usuario pone "cancion, artista" o "cancion - artista")
        import re as _re
        parts = _re.split(r'[,\\-]', q)
        if len(parts) > 1:
            local_check = await check_jellyfin_local(parts[0].strip())
            
    local_match_data = {"""

content = re.sub(search_music_pattern, search_music_new, content)

with open('api-descargas/main.py', 'w') as f:
    f.write(content)

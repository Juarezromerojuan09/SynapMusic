import re

with open('api-descargas/main.py', 'r') as f:
    content = f.read()

pattern = r'''                local_id = local_data\["data"\]\.get\("Id"\) if local_data\.get\("exists"\) and "data" in local_data else None
                
                results\.append\(\{
                    "id": str\(item\.get\("id"\)\),
                    "title": title,
                    "artist": artist,
                    "cover_url": item\.get\("album", \{\}\)\.get\("cover_medium"\),
                    "query_string": item\.get\("link"\),
                    "local_id": local_id
                \}\)'''

replacement = '''                jellyfin_item = None
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
                })'''

content = re.sub(pattern, replacement, content)

with open('api-descargas/main.py', 'w') as f:
    f.write(content)

import re

with open('api-descargas/main.py', 'r') as f:
    content = f.read()

# Replace get_top_albums
pattern_top = r'(@app\.get\("/home/top-albums", dependencies=\[Depends\(get_api_key\)\]\)\nasync def get_top_albums.*?return results)'
new_top = """@app.get("/home/top-albums", dependencies=[Depends(get_api_key)])
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
                        cover_url = f"{JELLYFIN_URL.rstrip('/')}/Items/{item.get('Id')}/Images/Primary"
                    
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
            return results"""

content = re.sub(pattern_top, new_top, content, flags=re.DOTALL)

# Replace get_new_releases
pattern_new = r'(@app\.get\("/home/new-releases", dependencies=\[Depends\(get_api_key\)\]\)\nasync def get_new_releases.*?return results)'
new_new = """@app.get("/home/new-releases", dependencies=[Depends(get_api_key)])
async def get_new_releases(user_id: str):
    import datetime
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
                                cover_url = f"{JELLYFIN_URL.rstrip('/')}/Items/{item.get('Id')}/Images/Primary"
                                
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
            return results"""

content = re.sub(pattern_new, new_new, content, flags=re.DOTALL)

with open('api-descargas/main.py', 'w') as f:
    f.write(content)

print("Backend patched")

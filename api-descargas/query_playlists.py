import asyncio
import httpx
from main import JELLYFIN_URL, JELLYFIN_API_KEY

async def main():
    print(f"Jellyfin URL: {JELLYFIN_URL}")
    headers = {"X-Emby-Token": JELLYFIN_API_KEY}
    
    async with httpx.AsyncClient() as client:
        url = f"{JELLYFIN_URL.rstrip('/')}/Items"
        params = {
            "IncludeItemTypes": "Playlist",
            "Recursive": "true"
        }
        res = await client.get(url, headers=headers, params=params)
        print("Status Code (Global):", res.status_code)
        if res.status_code == 200:
            data = res.json()
            items = data.get("Items", [])
            print(f"Global Playlists count: {len(items)}")
            for item in items:
                print(f" - {item.get('Name')} (ID: {item.get('Id')})")
        
        # also get users to check user-specific playlists
        res_users = await client.get(f"{JELLYFIN_URL.rstrip('/')}/Users", headers=headers)
        if res_users.status_code == 200:
            users = res_users.json()
            for u in users:
                uid = u.get("Id")
                uname = u.get("Name")
                res_u = await client.get(f"{JELLYFIN_URL.rstrip('/')}/Users/{uid}/Items", headers=headers, params=params)
                if res_u.status_code == 200:
                    u_items = res_u.json().get("Items", [])
                    print(f"User {uname} ({uid}) Playlists count: {len(u_items)}")
                    for item in u_items:
                        print(f"   - {item.get('Name')} (ID: {item.get('Id')})")

asyncio.run(main())

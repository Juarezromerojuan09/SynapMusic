import asyncio
import httpx

async def get_deezer_album(album_name, artist):
    async with httpx.AsyncClient() as client:
        res = await client.get("https://api.deezer.com/search/album", params={"q": f"{album_name} {artist}", "limit": 1})
        data = res.json().get("data", [])
        if data:
            return data[0]["id"]
        return None

print(asyncio.run(get_deezer_album("Discovery", "Daft Punk")))

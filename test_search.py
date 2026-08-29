import asyncio
import httpx
import os
from dotenv import load_dotenv

load_dotenv('api-descargas/.env')
JELLYFIN_URL = os.getenv("JELLYFIN_URL", "http://127.0.0.1:8096")
JELLYFIN_API_KEY = os.getenv("JELLYFIN_API_KEY")

async def test_search():
    async with httpx.AsyncClient() as client:
        url = f"{JELLYFIN_URL.rstrip('/')}/Items"
        params = {
            "SearchTerm": "Yes, I Do",
            "Recursive": "true",
            "IncludeItemTypes": "Audio",
            "Limit": 10
        }
        headers = {"X-Emby-Token": JELLYFIN_API_KEY}
        try:
            # Let's bypass internal routing issue since I'm in a sandbox and can't reach 127.0.0.1 of THEIR server!
            # I can't query their Jellyfin server from my sandbox anyway.
            pass
        except Exception as e:
            pass

asyncio.run(test_search())

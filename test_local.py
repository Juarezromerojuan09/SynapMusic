import asyncio
import sys
sys.path.append('api-descargas')
from main import get_album_details

async def test():
    res = await get_album_details("302127")
    print(len(res.get("tracks", [])))
    print(res.get("tracks", [])[0]["title"] if res.get("tracks") else "None")
    
asyncio.run(test())

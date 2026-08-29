with open('api-descargas/main.py', 'r') as f:
    content = f.read()

old_search = """        url = f"https://api.deezer.com/search/album?q={q}&limit=12"
        async with httpx.AsyncClient() as client:
            response = await client.get(url)"""

new_search = """        url = "https://api.deezer.com/search/album"
        async with httpx.AsyncClient(follow_redirects=True) as client:
            response = await client.get(url, params={"q": q, "limit": 12})
            response.raise_for_status()"""

content = content.replace(old_search, new_search)

with open('api-descargas/main.py', 'w') as f:
    f.write(content)

print("Albums patched")

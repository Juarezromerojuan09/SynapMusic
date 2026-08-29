import requests
import json
resp = requests.get("http://192.168.3.23:8000/album/302127", headers={"X-API-Key": "juarezromerojuan160311"}, timeout=5)
if resp.status_code == 200:
    data = resp.json()
    print("Tracks returned:", len(data.get("tracks", [])))
    print("First track:", data.get("tracks", [])[0]["title"] if data.get("tracks") else "none")
else:
    print("Error:", resp.status_code)

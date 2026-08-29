import requests, os
from dotenv import load_dotenv
load_dotenv('api-descargas/.env')
JF_URL = os.getenv("JELLYFIN_URL")
JF_KEY = os.getenv("JELLYFIN_API_KEY")

users = requests.get(f"{JF_URL}/Users", headers={"X-Emby-Token": JF_KEY}).json()
user_id = users[0]["Id"]
print(f"User: {user_id}")

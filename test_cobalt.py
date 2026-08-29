import requests
import sys

def get_cobalt_url(youtube_url):
    headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
    }
    data = {
        "url": youtube_url,
        "isAudioOnly": True,
        "aFormat": "mp3"
    }
    # Trying public Cobalt instances
    instances = ["https://co.wuk.sh", "https://api.cobalt.tools", "https://cobalt.q-n.space"]
    for instance in instances:
        try:
            print(f"Probando {instance}...")
            res = requests.post(f"{instance}/api/json", json=data, headers=headers, timeout=10)
            print(res.status_code, res.text)
            if res.status_code == 200:
                return res.json().get("url")
        except Exception as e:
            print(f"Error: {e}")
    return None

if __name__ == "__main__":
    yt_url = "https://www.youtube.com/watch?v=fm5kiVEklGA" # Twenty One Pilots - Forest
    download_url = get_cobalt_url(yt_url)
    if download_url:
        print("EXITO:", download_url)
    else:
        print("FALLO")

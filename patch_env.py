import re

with open('api-descargas/.env', 'r') as f:
    content = f.read()

content = re.sub(r'JELLYFIN_URL=.*', 'JELLYFIN_URL=http://127.0.0.1:8096', content)
if 'JELLYFIN_PUBLIC_URL' not in content:
    content += '\nJELLYFIN_PUBLIC_URL=http://100.81.156.126:8096\n'
    
with open('api-descargas/.env', 'w') as f:
    f.write(content)

with open('api-descargas/main.py', 'r') as f:
    main_content = f.read()
    
# Change JELLYFIN_URL to JELLYFIN_PUBLIC_URL for cover images
main_content = main_content.replace(
    'cover_url = f"{JELLYFIN_URL.rstrip(\'/\')}/Items/{item.get(\'Id\')}/Images/Primary"',
    'public_url = os.getenv("JELLYFIN_PUBLIC_URL", JELLYFIN_URL)\n                        cover_url = f"{public_url.rstrip(\'/\')}/Items/{item.get(\'Id\')}/Images/Primary"'
)

with open('api-descargas/main.py', 'w') as f:
    f.write(main_content)

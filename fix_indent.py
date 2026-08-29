with open('api-descargas/main.py', 'r') as f:
    lines = f.readlines()

for i in range(len(lines)):
    if 'public_url = os.getenv("JELLYFIN_PUBLIC_URL", JELLYFIN_URL)' in lines[i]:
        # get the indentation of the public_url line
        indent = len(lines[i]) - len(lines[i].lstrip())
        if 'cover_url = f"{public_url' in lines[i+1]:
            # make the next line have the same indentation
            lines[i+1] = (' ' * indent) + lines[i+1].lstrip()

with open('api-descargas/main.py', 'w') as f:
    f.writelines(lines)

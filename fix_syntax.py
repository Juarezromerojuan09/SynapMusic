with open('api-descargas/main.py', 'r') as f:
    content = f.read()

bad_import = "from fastapi import FastAPI,\nfrom playlist_migrator import run_migration_task\n Depends, HTTPException, Security, BackgroundTasks"
good_import = "from fastapi import FastAPI, Depends, HTTPException, Security, BackgroundTasks\nfrom playlist_migrator import run_migration_task"

content = content.replace(bad_import, good_import)

with open('api-descargas/main.py', 'w') as f:
    f.write(content)

print("Syntax fixed")

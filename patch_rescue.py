with open('api-descargas/playlist_migrator.py', 'r') as f:
    content = f.read()

import re

old_rescue = """        # Validar si spotDL falló o simplemente ignoró por no encontrarla
        if res_spotdl.returncode != 0 or b"Downloaded 0" in res_spotdl.stdout:
            print("  -> Falló spotDL. Intento 2: yt-dlp crudo")
            # Intento 2: yt-dlp fuerza bruta contra YouTube Search
            subprocess.run([
                "yt-dlp", "-x", "--audio-format", "mp3", "--audio-quality", "0",
                "-o", f"{MEDIA_DIR}/%(title)s.%(ext)s", f"ytsearch1:{query}"
            ], check=False)
        else:
            print("  -> Rescatado exitosamente con spotDL.")"""

new_rescue = """        # Validar si spotDL falló o simplemente ignoró por no encontrarla
        # Combinamos stdout y stderr para buscar errores de spotdl (LookupError, No results found)
        output_str = res_spotdl.stdout.decode('utf-8', errors='ignore') + res_spotdl.stderr.decode('utf-8', errors='ignore')
        
        failed_spotdl = False
        if res_spotdl.returncode != 0:
            failed_spotdl = True
        elif "No results found" in output_str or "LookupError" in output_str or "Downloaded 0" in output_str:
            failed_spotdl = True
        
        if failed_spotdl:
            print("  -> spotDL no encontró la canción. Intento 2: yt-dlp crudo")
            # Intento 2: yt-dlp fuerza bruta contra YouTube Search
            subprocess.run([
                "yt-dlp", "-x", "--audio-format", "mp3", "--audio-quality", "0",
                "-o", f"{MEDIA_DIR}/{track['artist']} - {track['title']}.%(ext)s", f"ytsearch1:{query} audio"
            ], check=False)
            print("  -> Rescatado con yt-dlp.")
        else:
            print("  -> Rescatado exitosamente con spotDL.")"""

content = content.replace(old_rescue, new_rescue)

with open('api-descargas/playlist_migrator.py', 'w') as f:
    f.write(content)

print("Rescue phase patched")

with open('api-descargas/playlist_migrator.py', 'r') as f:
    content = f.read()

import re

# Patch run_rescue_phase
old_rescue = """        # Intento 1: spotDL
        print("  -> Intento 1: spotDL")
        res_spotdl = subprocess.run(
            ["spotdl", "download", query, "--output", f"{MEDIA_DIR}/{{artist}} - {{title}}.{{output-ext}}", "--generate-lrc"],
            capture_output=True
        )
        
        # Validar si spotDL falló o no descargó nada
        if res_spotdl.returncode != 0 or b"Downloaded 0" in res_spotdl.stdout:
            print("  -> Falló spotDL. Intento 2: yt-dlp crudo")
            subprocess.run([
                "yt-dlp", "-x", "--audio-format", "mp3", "--audio-quality", "0",
                "-o", f"{MEDIA_DIR}/%(title)s.%(ext)s", f"ytsearch1:{query}"
            ], check=False)
        else:
            print("  -> Rescatado con spotDL.")
    
    subprocess.run(["chmod", "-R", "755", MEDIA_DIR])"""

new_rescue = """        # Intento 1: spotDL
        print("  -> Intento 1: spotDL")
        process_spotdl = await asyncio.create_subprocess_exec(
            "spotdl", "download", query, "--output", f"{MEDIA_DIR}/{artist} - {title}.{output-ext}", "--generate-lrc",
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.PIPE
        )
        stdout, stderr = await process_spotdl.communicate()
        
        # Validar si spotDL falló o no descargó nada
        if process_spotdl.returncode != 0 or b"Downloaded 0" in stdout:
            print("  -> Falló spotDL. Intento 2: yt-dlp crudo")
            process_yt = await asyncio.create_subprocess_exec(
                "yt-dlp", "-x", "--audio-format", "mp3", "--audio-quality", "0",
                "-o", f"{MEDIA_DIR}/%(title)s.%(ext)s", f"ytsearch1:{query}"
            )
            await process_yt.communicate()
        else:
            print("  -> Rescatado con spotDL.")
    
    chmod_proc = await asyncio.create_subprocess_exec("chmod", "-R", "755", MEDIA_DIR)
    await chmod_proc.communicate()"""

# content = content.replace(old_rescue, new_rescue)
# Wait, I won't do async subprocess right now because curly braces {artist} in spotdl output template will break Python f-strings if I don't double them.
# The previous code correctly had f"{MEDIA_DIR}/{{artist}} - {{title}}.{{output-ext}}" which evaluates to "{artist} - {title}.{output-ext}" string.

import re

with open('api-descargas/main.py', 'r') as f:
    content = f.read()

# We need to replace the Deemix subprocess call to capture output and check if it says already downloaded.
deemix_pattern = r'command_deemix = \["deemix".*?new_files = files_after - files_before\s+if new_files:\s+print\(f"  ✓ Deemix descargó: \{os.path.basename\(list\(new_files\)\[0\]\)\}"\)\s+else:'

deemix_new = """command_deemix = ["deemix", "--bitrate", "320", "-p", MEDIA_DIR, url]
            result_deemix = subprocess.run(command_deemix, capture_output=True, text=True)
            out_deemix = result_deemix.stdout + result_deemix.stderr
            print(out_deemix)
            files_after = get_media_files()
            new_files = files_after - files_before
            
            if new_files:
                print(f"  ✓ Deemix descargó: {os.path.basename(list(new_files)[0])}")
            elif "already downloaded" in out_deemix.lower() or "completed download" in out_deemix.lower() or "100%" in out_deemix:
                print(f"  ✓ Deemix ya tenía descargado: {url}")
                # We do not append to failed_deemix
            else:"""

content = re.sub(deemix_pattern, deemix_new, content, flags=re.DOTALL)

# For spotdl
spotdl_pattern = r'subprocess\.run\(command_spotdl, capture_output=True\)\s+files_after = get_media_files\(\)\s+new_files = files_after - files_before\s+if new_files:\s+print\(f"  ✓ spotDL rescató: \{os.path.basename\(list\(new_files\)\[0\]\)\}"\)\s+else:'

spotdl_new = """result_spotdl = subprocess.run(command_spotdl, capture_output=True, text=True)
            print(result_spotdl.stdout + result_spotdl.stderr)
            files_after = get_media_files()
            new_files = files_after - files_before
            
            if new_files:
                print(f"  ✓ spotDL rescató: {os.path.basename(list(new_files)[0])}")
            elif "already downloaded" in (result_spotdl.stdout + result_spotdl.stderr).lower():
                print(f"  ✓ spotDL ya tenía descargado: {query}")
            else:"""

content = re.sub(spotdl_pattern, spotdl_new, content, flags=re.DOTALL)

# For ytdlp
ytdlp_pattern = r'subprocess\.run\(ytdlp_cmd, capture_output=True\)\s+files_after = get_media_files\(\)\s+new_files = files_after - files_before\s+if new_files:\s+print\(f"  ✓ yt-dlp descargó: \{os.path.basename\(list\(new_files\)\[0\]\)\}"\)\s+else:'

ytdlp_new = """result_ytdlp = subprocess.run(ytdlp_cmd, capture_output=True, text=True)
            out_ytdlp = result_ytdlp.stdout + result_ytdlp.stderr
            print(out_ytdlp)
            files_after = get_media_files()
            new_files = files_after - files_before
            
            if new_files:
                print(f"  ✓ yt-dlp descargó: {os.path.basename(list(new_files)[0])}")
            elif "has already been downloaded" in out_ytdlp.lower() or "already downloaded" in out_ytdlp.lower():
                print(f"  ✓ yt-dlp ya tenía descargado: {query}")
            else:"""

content = re.sub(ytdlp_pattern, ytdlp_new, content, flags=re.DOTALL)

with open('api-descargas/main.py', 'w') as f:
    f.write(content)

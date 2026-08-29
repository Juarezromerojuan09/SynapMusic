with open('api-descargas/playlist_migrator.py', 'r') as f:
    content = f.read()

old_yt = """            if new_files_yt:
                print(f"  -> Rescatado con yt-dlp. Archivo: {os.path.basename(list(new_files_yt)[0])}")
            else:
                print(f"  -> FALLO TOTAL: Ni spotDL ni yt-dlp pudieron descargar: {query}")"""

new_yt = """            if new_files_yt:
                print(f"  -> Rescatado con yt-dlp. Archivo: {os.path.basename(list(new_files_yt)[0])}")
            else:
                print(f"  -> FALLO TOTAL: Ni spotDL ni yt-dlp pudieron descargar: {query}")
            
            # Pausa de seguridad anti-baneo para yt-dlp (5 a 8 segundos)
            import random
            sleep_time = random.uniform(5.0, 8.0)
            print(f"  -> [Anti-Bot] Enfriando conexión por {sleep_time:.1f} segundos...")
            import time
            time.sleep(sleep_time)"""

content = content.replace(old_yt, new_yt)

with open('api-descargas/playlist_migrator.py', 'w') as f:
    f.write(content)

print("Sleep patched")

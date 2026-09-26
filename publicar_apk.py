"""
Script para publicar la APK compilada de SynapMusic en el portal web de la ThinkCentre.
Uso:
  python publicar_apk.py [ruta_al_apk_opcional]
"""
import os
import sys
import paramiko

HOSTNAME = "192.168.1.121"
USERNAME = "juarezromerojuan09"
PASSWORD = "peluso160311"
REMOTE_APK_PATH = "/home/juarezromerojuan09/servicios/synapmusic/portal/downloads/synapmusic.apk"

# Buscar APK candidata
default_flutter_apk = os.path.join("cliente-finamp", "build", "app", "outputs", "flutter-apk", "app-release.apk")

if len(sys.argv) > 1 and os.path.exists(sys.argv[1]):
    local_apk = sys.argv[1]
elif os.path.exists(default_flutter_apk):
    local_apk = default_flutter_apk
else:
    # Buscar cualquier .apk en el proyecto
    found = []
    for root, _, files in os.walk("."):
        for f in files:
            if f.endswith(".apk"):
                found.append(os.path.join(root, f))
    if found:
        local_apk = found[0]
    else:
        print(f"Error: No se encontró ningún archivo APK en {default_flutter_apk}.")
        print("Compila primero la aplicación con: flutter build apk --release")
        print("O pasa la ruta del archivo APK: python publicar_apk.py <ruta_a_tu_apk>")
        sys.exit(1)

file_size_mb = os.path.getsize(local_apk) / (1024 * 1024)
print(f"Archivo APK local encontrado: {local_apk} ({file_size_mb:.2f} MB)")
print(f"Conectando a ThinkCentre ({HOSTNAME})...")

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(HOSTNAME, username=USERNAME, password=PASSWORD, timeout=10)

sftp = ssh.open_sftp()
# Asegurar que el directorio remoto exista
try:
    sftp.mkdir("/home/juarezromerojuan09/servicios/synapmusic/portal/downloads")
except:
    pass

def progress_callback(transferred, total):
    percent = (transferred / total) * 100
    print(f"\rSubiendo APK: {percent:.1f}% ({transferred // (1024*1024)} MB / {total // (1024*1024)} MB)", end="")

print("Iniciando subida al portal web...")
sftp.put(local_apk, REMOTE_APK_PATH, callback=progress_callback)
print("\n¡APK publicada con éxito en el portal web!")
sftp.close()
ssh.close()

print(f"\nYa está disponible para descarga en:")
print(f"  • Tailscale: http://100.64.134.104:8000/synapmusic")
print(f"  • Red Local: http://192.168.1.121:8000/synapmusic")

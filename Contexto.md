# SynapMusic - Ecosistema de Streaming Local

## Contexto del Proyecto

"SynapMusic" es un ecosistema de streaming de música local y privado (estilo Spotify). La arquitectura consta de tres capas principales separadas en un Monorepo, sin mezclar tecnologías entre carpetas:

1. **Infraestructura (Servidor openSUSE Headless):**
   - **Carpeta:** `/infraestructura-servidor`
   - **Tecnología:** Docker Compose, Bash.
   - **Objetivo:** Contener la configuración para levantar Jellyfin (servidor de medios y gestión de perfiles de usuario). *Nota: Tailscale se administrará a nivel de sistema operativo, no en Docker.*

2. **API Puente de Descargas (Backend):**
   - **Carpeta:** `/api-descargas`
   - **Tecnología:** Python 3, FastAPI, uvicorn, spotDL. (Seguridad mediante API Key estática por variables de entorno).
   - **Objetivo:** Una API RESTful que reciba peticiones de búsqueda/descarga, ejecute spotDL en segundo plano para descargar música en alta calidad directamente a la carpeta mapeada de Jellyfin en el host (`/opt/synapmusic/media`), y luego notifique a la API de Jellyfin para que actualice la biblioteca.

3. **Cliente Móvil/Web (Frontend):**
   - **Carpeta:** `/cliente-finamp`
   - **Tecnología:** Flutter / Dart (Fork del proyecto Finamp).
   - **Objetivo:** Modificar la interfaz de Finamp para agregar una vista de "Descubrir/Buscar" que consuma nuestra API en Python. Si la canción ya existe en Jellyfin, se agrega a la playlist; si no existe, hace la petición a la API de Python para descargarla mediante spotDL.

## Reglas de Trabajo

- Mantener el código modular, limpio y documentado.
- La base de datos y usuarios la gestionará 100% Jellyfin.
- La API en Python es solo un puente de automatización.

## Historial de Cambios

- **2026-08-16**: Creación del documento `Contexto.md`. Inicialización de la estructura del proyecto y definición del plan de implementación inicial.

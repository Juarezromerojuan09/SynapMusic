import re

with open('api-descargas/main.py', 'r') as f:
    content = f.read()

# Models
models = """class RegisterRequest(BaseModel):
    username: str
    password: str

"""

# Endpoints
endpoints = """
@app.post("/register")
async def register_user(req: RegisterRequest):
    """Crea un usuario en Jellyfin y lo deshabilita (Sala de Espera)."""
    headers = {"X-Emby-Token": JELLYFIN_API_KEY}
    
    async with httpx.AsyncClient() as client:
        # 1. Crear usuario
        create_url = f"{JELLYFIN_URL}/Users/New"
        create_resp = await client.post(create_url, headers=headers, json={"Name": req.username, "Password": req.password})
        
        if create_resp.status_code != 200:
            print(f"Error creando usuario: {create_resp.text}")
            raise HTTPException(status_code=400, detail="Error al crear el usuario en Jellyfin")
            
        user_data = create_resp.json()
        user_id = user_data.get("Id")
        
        if not user_id:
            raise HTTPException(status_code=500, detail="No se obtuvo el ID del usuario creado")
            
        # 2. Obtener política actual
        get_user_url = f"{JELLYFIN_URL}/Users/{user_id}"
        user_resp = await client.get(get_user_url, headers=headers)
        if user_resp.status_code != 200:
            raise HTTPException(status_code=500, detail="Error obteniendo política del usuario")
            
        policy = user_resp.json().get("Policy", {})
        
        # 3. Deshabilitar usuario
        policy["IsDisabled"] = True
        
        policy_url = f"{JELLYFIN_URL}/Users/{user_id}/Policy"
        policy_resp = await client.post(policy_url, headers=headers, json=policy)
        
        if policy_resp.status_code not in [200, 204]:
            print(f"Error actualizando política: {policy_resp.text}")
            raise HTTPException(status_code=500, detail="Error enviando a sala de espera")
            
        return {"status": "success", "message": "Cuenta creada. Esperando aprobación."}

@app.get("/users/pending")
async def get_pending_users():
    """Obtiene todos los usuarios que están deshabilitados (en sala de espera)."""
    headers = {"X-Emby-Token": JELLYFIN_API_KEY}
    
    async with httpx.AsyncClient() as client:
        users_url = f"{JELLYFIN_URL}/Users"
        resp = await client.get(users_url, headers=headers)
        
        if resp.status_code != 200:
            raise HTTPException(status_code=500, detail="Error obteniendo usuarios de Jellyfin")
            
        users = resp.json()
        pending = [u for u in users if u.get("Policy", {}).get("IsDisabled", False)]
        
        return pending

@app.post("/users/approve/{user_id}")
async def approve_user(user_id: str):
    """Habilita a un usuario en sala de espera y le da acceso a las bibliotecas."""
    headers = {"X-Emby-Token": JELLYFIN_API_KEY}
    
    async with httpx.AsyncClient() as client:
        # 1. Obtener usuario actual para su policy
        get_user_url = f"{JELLYFIN_URL}/Users/{user_id}"
        user_resp = await client.get(get_user_url, headers=headers)
        
        if user_resp.status_code != 200:
            raise HTTPException(status_code=404, detail="Usuario no encontrado")
            
        policy = user_resp.json().get("Policy", {})
        
        # 2. Modificar política
        policy["IsDisabled"] = False
        policy["EnableAllFolders"] = True
        
        # 3. Guardar política
        policy_url = f"{JELLYFIN_URL}/Users/{user_id}/Policy"
        policy_resp = await client.post(policy_url, headers=headers, json=policy)
        
        if policy_resp.status_code not in [200, 204]:
            raise HTTPException(status_code=500, detail="Error aprobando al usuario")
            
        return {"status": "success", "message": "Usuario aprobado correctamente."}
"""

if "RegisterRequest" not in content:
    content = content.replace("class SearchRequest(BaseModel):", models + "class SearchRequest(BaseModel):")

if "@app.post(\"/register\")" not in content:
    content += endpoints

with open('api-descargas/main.py', 'w') as f:
    f.write(content)

print("Backend patched successfully.")

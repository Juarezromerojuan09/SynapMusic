with open('api-descargas/main.py', 'r') as f:
    content = f.read()

# For register_user
old_disable = """        # 3. Deshabilitar usuario
        policy["IsDisabled"] = True"""

new_disable = """        # 3. Deshabilitar usuario y revocar privilegios de admin por seguridad
        policy["IsDisabled"] = True
        policy["IsAdministrator"] = False"""

content = content.replace(old_disable, new_disable)

# For approve_user
old_approve = """        # 2. Modificar política
        policy["IsDisabled"] = False
        policy["EnableAllFolders"] = True"""

new_approve = """        # 2. Modificar política
        policy["IsDisabled"] = False
        policy["EnableAllFolders"] = True
        policy["IsAdministrator"] = False"""

content = content.replace(old_approve, new_approve)

with open('api-descargas/main.py', 'w') as f:
    f.write(content)

print("Backend roles patched")

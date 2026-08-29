with open('lib/components/UserSelector/private_user_sign_in.dart', 'r') as f:
    content = f.read()

import re

old_row = """                children: [
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(LogsScreen.routeName),
                    child:
                        Text(AppLocalizations.of(context)!.logs.toUpperCase()),
                  ),
                  ElevatedButton(
                    onPressed:
                        isAuthenticating ? null : () async => await sendForm(),
                    child:
                        Text(AppLocalizations.of(context)!.next.toUpperCase()),
                  ),
                ],"""

new_row = """                children: [
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(LogsScreen.routeName),
                    child:
                        Text(AppLocalizations.of(context)!.logs.toUpperCase()),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/register'),
                    child:
                        const Text("REGISTRARSE"),
                  ),
                  ElevatedButton(
                    onPressed:
                        isAuthenticating ? null : () async => await sendForm(),
                    child:
                        Text(AppLocalizations.of(context)!.next.toUpperCase()),
                  ),
                ],"""

content = content.replace(old_row, new_row)
if "/register" in new_row and "register_screen.dart" not in content:
    content = content.replace("import '../error_snackbar.dart';", "import '../error_snackbar.dart';\nimport '../../screens/synap_music/register_screen.dart';")

with open('lib/components/UserSelector/private_user_sign_in.dart', 'w') as f:
    f.write(content)

print("Login row patched successfully")

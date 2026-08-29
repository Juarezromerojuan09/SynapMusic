import re

with open('lib/components/UserSelector/private_user_sign_in.dart', 'r') as f:
    content = f.read()

if "register_screen.dart" not in content:
    content = content.replace("import '../error_snackbar.dart';", "import '../error_snackbar.dart';\nimport '../../screens/synap_music/register_screen.dart';")

# Find the login button and append Register button
# Finamp login button usually is ElevatedButton or something similar
# Let's search for the button inside the form.
pattern = r"(isAuthenticating\s*\?\s*const CircularProgressIndicator.*?\s*:\s*const Text.*?)[,]?\s*\)[\n\s]*\)"
match = re.search(pattern, content, flags=re.DOTALL)
if match:
    pass # we can append after it.

# Actually, the button is inside a row or column.
# We can just append a TextButton at the end of the Column children.
# Let's find the end of the Column children.
column_pattern = r"(TextFormField\(.*?onSaved: \(newValue\) => password = newValue,.*?\),.*?)\n\s*\]"
# It's better to just use replace to add the button after the padding containing the login button.

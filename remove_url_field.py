import re

with open('cliente-finamp/lib/components/UserSelector/private_user_sign_in.dart', 'r') as f:
    content = f.read()

# Replace declaration
content = content.replace('String? baseUrl;', 'String? baseUrl = "http://100.81.156.126:8096";')

# Remove the TextFormField for serverUrl and its SizedBox
pattern = r'TextFormField\(\s*style: const TextStyle\(color: Colors\.black\),\s*keyboardType: TextInputType\.url,.*?onSaved: \(newValue\) => baseUrl = newValue,\s*\),\s*const SizedBox\(height: 16\),'

content = re.sub(pattern, '', content, flags=re.DOTALL)

with open('cliente-finamp/lib/components/UserSelector/private_user_sign_in.dart', 'w') as f:
    f.write(content)


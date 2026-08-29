import re

with open('cliente-finamp/lib/screens/synap_music/register_screen.dart', 'r') as f:
    content = f.read()

# Make Container expand to full width and height
content = content.replace('body: Container(', 'body: Container(\n        width: double.infinity,\n        height: double.infinity,')

# Add style: TextStyle(color: Colors.black) to TextFields
content = re.sub(r'(TextField\(\s*)', r'\1style: const TextStyle(color: Colors.black),\n                            ', content)

with open('cliente-finamp/lib/screens/synap_music/register_screen.dart', 'w') as f:
    f.write(content)

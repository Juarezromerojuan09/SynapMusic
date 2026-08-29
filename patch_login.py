import re

with open('cliente-finamp/lib/components/UserSelector/private_user_sign_in.dart', 'r') as f:
    content = f.read()

# Make Container expand to full width and height
# And change text color to black (since card is white)
content = content.replace('return Container(', 'return Container(\n      width: double.infinity,\n      height: double.infinity,')

# Add style: TextStyle(color: Colors.black) to TextFormFields
content = re.sub(r'(TextFormField\(\s*)', r'\1style: const TextStyle(color: Colors.black),\n                                ', content)

with open('cliente-finamp/lib/components/UserSelector/private_user_sign_in.dart', 'w') as f:
    f.write(content)

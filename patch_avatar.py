import re

with open('cliente-finamp/lib/screens/synap_music/main_home_screen.dart', 'r') as f:
    content = f.read()

pattern = r'backgroundImage: NetworkImage\(userImageUrl\),'
replacement = 'backgroundImage: CachedNetworkImageProvider(userImageUrl),'

content = re.sub(pattern, replacement, content)

with open('cliente-finamp/lib/screens/synap_music/main_home_screen.dart', 'w') as f:
    f.write(content)

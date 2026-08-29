import re

with open('cliente-finamp/lib/screens/synap_music/main_home_screen.dart', 'r') as f:
    content = f.read()

pattern = r'''                if \(item\['local_id'\] != null\) \{
                  // Reproducir localmente
                  final track = BaseItemDto\(
                    id: item\['local_id'\],
                    name: item\['title'\],
                    type: 'Audio',
                  \);'''

replacement = '''                if (item['local_id'] != null) {
                  // Reproducir localmente
                  BaseItemDto track;
                  if (item['jellyfin_item'] != null) {
                    track = BaseItemDto.fromJson(item['jellyfin_item']);
                  } else {
                    track = BaseItemDto(
                      id: item['local_id'],
                      name: item['title'],
                      type: 'Audio',
                    );
                  }'''

content = re.sub(pattern, replacement, content)

with open('cliente-finamp/lib/screens/synap_music/main_home_screen.dart', 'w') as f:
    f.write(content)

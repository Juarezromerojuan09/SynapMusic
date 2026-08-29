import re

with open('cliente-finamp/lib/screens/synap_music/main_home_screen.dart', 'r') as f:
    content = f.read()

pattern = r"""            _buildSectionTitle\('Tus Canciones Más Escuchadas'\),
            _buildHorizontalList\(_topSongsStream, \(item, index\) \{
              final cover = 'http://100\.81\.156\.126:8096/Items/\$\{item\['Id'\]\}/Images/Primary';
              final artist = \(item\['Artists'\] != null && \(item\['Artists'\] as List\)\.isNotEmpty\) 
                  \? item\['Artists'\]\[0\] : 'Desconocido';
              return _buildCard\(cover, item\['Name'\] \?\? '', artist, onTap: \(\) \{"""

replacement = """            _buildSectionTitle('Tus Canciones Más Escuchadas'),
            _buildHorizontalList(_topSongsStream, (item, index) {
              final cover = 'http://100.81.156.126:8096/Items/${item['Id']}/Images/Primary';
              final artist = (item['Artists'] != null && (item['Artists'] as List).isNotEmpty) 
                  ? item['Artists'][0] : 'Desconocido';
              final playCount = (item['UserData'] != null && item['UserData']['PlayCount'] != null) 
                  ? item['UserData']['PlayCount'] : 0;
              final subtitle = playCount == 1 ? '$artist • 1 vez' : '$artist • $playCount veces';
              return _buildCard(cover, item['Name'] ?? '', subtitle, onTap: () {"""

content = re.sub(pattern, replacement, content)

with open('cliente-finamp/lib/screens/synap_music/main_home_screen.dart', 'w') as f:
    f.write(content)


import re

with open('cliente-finamp/lib/screens/synap_music/main_home_screen.dart', 'r') as f:
    content = f.read()

# 1. Increase height in _buildHorizontalList
content = content.replace('height: 170,', 'height: 190,')

# 2. Modify _buildCard signature to include extraSubtitle
card_sig_pattern = r"Widget _buildCard\(String imageUrl, String title, String subtitle, \{bool isCircular = false, VoidCallback\? onTap, int\? rank\}\) \{"
card_sig_new = "Widget _buildCard(String imageUrl, String title, String subtitle, {bool isCircular = false, VoidCallback? onTap, int? rank, String? extraSubtitle}) {"
content = re.sub(card_sig_pattern, card_sig_new, content)

# 3. Add extraSubtitle to the UI in _buildCard
card_ui_pattern = r"""            const SizedBox\(height: 2\),
            Text\(
              subtitle,
              style: const TextStyle\(color: Colors\.grey, fontSize: 11\),
              maxLines: 1,
              overflow: TextOverflow\.ellipsis,
              textAlign: TextAlign\.center,
            \),
          \],"""
card_ui_new = """            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            if (extraSubtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                extraSubtitle,
                style: const TextStyle(color: Colors.blueGrey, fontSize: 11, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ],"""
content = re.sub(card_ui_pattern, card_ui_new, content)

# 4. Modify the caller for Top Songs
caller_pattern = r"""              final subtitle = playCount == 1 \? '\$artist • 1 vez' : '\$artist • \$playCount veces';
              return _buildCard\(cover, item\['Name'\] \?\? '', subtitle, onTap: \(\) \{"""
caller_new = """              final extraSubtitle = playCount == 1 ? '1 vez' : '$playCount veces';
              return _buildCard(cover, item['Name'] ?? '', artist, extraSubtitle: extraSubtitle, onTap: () {"""
content = re.sub(caller_pattern, caller_new, content)

with open('cliente-finamp/lib/screens/synap_music/main_home_screen.dart', 'w') as f:
    f.write(content)


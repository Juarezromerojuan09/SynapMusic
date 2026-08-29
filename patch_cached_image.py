import re

with open('cliente-finamp/lib/screens/synap_music/main_home_screen.dart', 'r') as f:
    content = f.read()

# Add import
if "import 'package:cached_network_image/cached_network_image.dart';" not in content:
    content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:cached_network_image/cached_network_image.dart';")

# Replace Image.network
pattern = r'Image\.network\(\s*imageUrl,\s*width: 120,\s*height: 120,\s*fit: BoxFit\.cover,\s*errorBuilder: \(_, __, ___\) => Container\(\s*color: Colors\.grey\[800\],\s*child: Icon\(isCircular \? Icons\.person : Icons\.music_note, size: 50, color: Colors\.white\),\s*\),\s*\)'

replacement = """CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(
                    color: Colors.grey[800],
                    child: Icon(isCircular ? Icons.person : Icons.music_note, size: 50, color: Colors.white),
                  ),
                  placeholder: (context, url) => Container(
                    color: Colors.grey[800],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                )"""

content = re.sub(pattern, replacement, content)

with open('cliente-finamp/lib/screens/synap_music/main_home_screen.dart', 'w') as f:
    f.write(content)

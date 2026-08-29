import re

with open('cliente-finamp/lib/components/track_list_item.dart', 'r') as f:
    content = f.read()

# 1. Reduce SizedBox width for track number from 30 to 24
content = content.replace("width: 30,", "width: 24,")

# 2. Reduce horizontal padding from 16 to 8
content = content.replace("padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),", "padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),")

# 3. Reduce SizedBox width after leadingWidget from 12 to 8
content = content.replace("const SizedBox(width: 12),", "const SizedBox(width: 8),")

# 4. Reduce SizedBox width before trailingWidget from 8 to 4
content = content.replace("const SizedBox(width: 8),", "const SizedBox(width: 4),")

with open('cliente-finamp/lib/components/track_list_item.dart', 'w') as f:
    f.write(content)

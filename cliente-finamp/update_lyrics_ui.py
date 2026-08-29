import re

with open('lib/screens/player_screen.dart', 'r') as f:
    content = f.read()

# 1. Update font sizes
content = content.replace("fontSize: isCurrent ? 24 : 18,", "fontSize: isCurrent ? 30 : 22,")

# 2. Update scroll offset and padding
# Old offset calculation:
old_offset = "final double offset = max(0.0, (activeIndex * 45.0) - 100.0);"
# New offset calculation (50.0 is the new estimated line height, -40.0 puts it higher)
new_offset = "final double offset = max(0.0, (activeIndex * 50.0) - 40.0);"
content = content.replace(old_offset, new_offset)

# Update padding
old_padding = "padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 16),"
new_padding = "padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 16),"
content = content.replace(old_padding, new_padding)

with open('lib/screens/player_screen.dart', 'w') as f:
    f.write(content)

print("Updated lyrics UI successfully")

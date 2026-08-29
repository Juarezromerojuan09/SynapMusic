import re

with open('cliente-finamp/lib/components/track_list_item.dart', 'r') as f:
    content = f.read()

old_block = """    if (coverUrl != null && coverUrl!.isNotEmpty) {
      leadingChildren.add(
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(
            coverUrl!,
            width: 45,
            height: 45,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.music_note),
          ),
        ),
      );
    } else {
      leadingChildren.add(
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(Icons.music_note, color: Colors.grey),
        ),
      );
    }"""

new_block = """    if (coverUrl != null) {
      if (coverUrl!.isNotEmpty) {
        leadingChildren.add(
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              coverUrl!,
              width: 45,
              height: 45,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildPlaceholder(),
            ),
          ),
        );
      } else {
        leadingChildren.add(_buildPlaceholder());
      }
    }"""

helper_method = """  Widget _buildPlaceholder() {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Icon(Icons.music_note, color: Colors.grey),
    );
  }

  @override"""

content = content.replace(old_block, new_block)
content = content.replace("  @override", helper_method, 1)

with open('cliente-finamp/lib/components/track_list_item.dart', 'w') as f:
    f.write(content)

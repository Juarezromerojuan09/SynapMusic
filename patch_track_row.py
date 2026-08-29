import re

with open('cliente-finamp/lib/components/track_list_item.dart', 'r') as f:
    content = f.read()

old_tile = """    final tile = ListTile(
      leading: leadingWidget,
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        duration != null ? '$artist • $duration' : artist,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          trailingWidget,
        ],
      ),
      onTap: isAvailableInServer ? onPlayPressed : null,
    );"""

new_tile = """    final tile = InkWell(
      onTap: isAvailableInServer ? onPlayPressed : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            leadingWidget,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 2),
                  Text(
                    duration != null ? '$artist • $duration' : artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            trailingWidget,
          ],
        ),
      ),
    );"""

content = content.replace(old_tile, new_tile)

with open('cliente-finamp/lib/components/track_list_item.dart', 'w') as f:
    f.write(content)


import re

with open('cliente-finamp/lib/components/track_list_item.dart', 'r') as f:
    content = f.read()

old_leading = """    Widget? leadingWidget;
    if (coverUrl != null && coverUrl!.isNotEmpty) {
      leadingWidget = ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.network(
          coverUrl!,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.music_note),
        ),
      );
    } else if (trackNumber != null) {
      leadingWidget = SizedBox(
        width: 30,
        child: Center(
          child: Text(
            '$trackNumber',
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      );
    } else {
      leadingWidget = const Icon(Icons.music_note);
    }"""

new_leading = """    List<Widget> leadingChildren = [];

    if (trackNumber != null) {
      leadingChildren.add(
        SizedBox(
          width: 30,
          child: Center(
            child: Text(
              '$trackNumber',
              style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }

    if (coverUrl != null && coverUrl!.isNotEmpty) {
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
    }

    Widget leadingWidget = Row(
      mainAxisSize: MainAxisSize.min,
      children: leadingChildren,
    );"""

content = content.replace(old_leading, new_leading)

with open('cliente-finamp/lib/components/track_list_item.dart', 'w') as f:
    f.write(content)


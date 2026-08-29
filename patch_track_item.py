import re

with open('cliente-finamp/lib/components/track_list_item.dart', 'r') as f:
    content = f.read()

# Add imports
imports_pattern = "import 'package:flutter/material.dart';"
imports_new = """import 'package:flutter/material.dart';
import '../services/media_state_stream.dart';"""
content = content.replace(imports_pattern, imports_new)

# Add trackId field
fields_pattern = """  final String? coverUrl;
  final int? trackNumber;"""
fields_new = """  final String? coverUrl;
  final int? trackNumber;
  final String? trackId;"""
content = content.replace(fields_pattern, fields_new)

# Add trackId to constructor
constructor_pattern = """    this.coverUrl,
    this.trackNumber,
  }) : super(key: key);"""
constructor_new = """    this.coverUrl,
    this.trackNumber,
    this.trackId,
  }) : super(key: key);"""
content = content.replace(constructor_pattern, constructor_new)

# Wrap ListTile in StreamBuilder
build_pattern = """    return ListTile(
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

build_new = """    final tile = ListTile(
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
    );

    if (trackId == null) return tile;

    return StreamBuilder<MediaState>(
      stream: mediaStateStream,
      builder: (context, snapshot) {
        final isPlaying = snapshot.data?.mediaItem?.id == trackId;
        final color = isPlaying ? synapColor.withOpacity(0.2) : Colors.transparent;
        return Container(
          color: color,
          child: Row(
            children: [
              if (isPlaying)
                Container(width: 4, height: 40, color: synapColor, margin: const EdgeInsets.only(left: 4)),
              Expanded(child: tile),
            ],
          ),
        );
      },
    );"""
content = content.replace(build_pattern, build_new)

with open('cliente-finamp/lib/components/track_list_item.dart', 'w') as f:
    f.write(content)


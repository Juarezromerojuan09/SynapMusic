import re

with open('cliente-finamp/lib/components/track_list_item.dart', 'r') as f:
    content = f.read()

fields_old = """  final int? trackNumber;
  final String? trackId;"""
fields_new = """  final int? trackNumber;
  final String? trackId;
  final Widget? trailingWidget;"""
content = content.replace(fields_old, fields_new)

constructor_old = """    this.trackNumber,
    this.trackId,
  }) : super(key: key);"""
constructor_new = """    this.trackNumber,
    this.trackId,
    this.trailingWidget,
  }) : super(key: key);"""
content = content.replace(constructor_old, constructor_new)

build_old = """    Widget trailingWidget;
    if (isAvailableInServer) {
      trailingWidget = IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: onMenuPressed,
      );
    } else {
      trailingWidget = IconButton(
        icon: const Icon(Icons.download, color: synapColor),
        onPressed: onDownloadPressed,
      );
    }"""
build_new = """    Widget actualTrailingWidget = trailingWidget ?? (isAvailableInServer 
      ? IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: onMenuPressed,
        ) 
      : IconButton(
          icon: const Icon(Icons.download, color: synapColor),
          onPressed: onDownloadPressed,
        ));"""
content = content.replace(build_old, build_new)

content = content.replace("            trailingWidget,", "            actualTrailingWidget,")

with open('cliente-finamp/lib/components/track_list_item.dart', 'w') as f:
    f.write(content)

import re

with open('cliente-finamp/lib/components/track_list_item.dart', 'r') as f:
    content = f.read()

old_block = """      builder: (context, snapshot) {
        final isPlaying = snapshot.data?.mediaItem?.id == trackId;
        final color = isPlaying ? synapColor.withOpacity(0.2) : Colors.transparent;
        return Container("""

new_block = """      builder: (context, snapshot) {
        final mediaItem = snapshot.data?.mediaItem;
        final playingId = mediaItem?.extras?['itemJson']?['Id'];
        final isPlaying = playingId != null && playingId == trackId;
        final color = isPlaying ? synapColor.withOpacity(0.2) : Colors.transparent;
        return Container("""

content = content.replace(old_block, new_block)

with open('cliente-finamp/lib/components/track_list_item.dart', 'w') as f:
    f.write(content)


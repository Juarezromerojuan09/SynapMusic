import re

with open('cliente-finamp/lib/screens/synap_music/main_home_screen.dart', 'r') as f:
    content = f.read()

# 1. Update _buildHorizontalList signature
content = content.replace(
    'Widget _buildHorizontalList(Stream<List<dynamic>>? stream, Widget Function(dynamic) itemBuilder)', 
    'Widget _buildHorizontalList(Stream<List<dynamic>>? stream, Widget Function(dynamic, int) itemBuilder)'
)

# 2. Update calling of itemBuilder inside _buildHorizontalList
content = content.replace(
    'child: itemBuilder(items[index]),', 
    'child: itemBuilder(items[index], index),'
)

# 3. Update callers to accept (item, index)
content = content.replace(
    '_buildHorizontalList(_topMexicoStream, (item) {',
    '_buildHorizontalList(_topMexicoStream, (item, index) {'
)
content = content.replace(
    '_buildHorizontalList(_topSongsStream, (item) {',
    '_buildHorizontalList(_topSongsStream, (item, index) {'
)
content = content.replace(
    '_buildHorizontalList(_topArtistsStream, (item) {',
    '_buildHorizontalList(_topArtistsStream, (item, index) {'
)
content = content.replace(
    '_buildHorizontalList(_topAlbumsStream, (item) {',
    '_buildHorizontalList(_topAlbumsStream, (item, index) {'
)
content = content.replace(
    '_buildHorizontalList(_newReleasesStream, (item) {',
    '_buildHorizontalList(_newReleasesStream, (item, index) {'
)

# 4. Modify _buildCard signature and implementation to support 'rank'
card_original = """  Widget _buildCard(String imageUrl, String title, String subtitle, {bool isCircular = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(isCircular ? 60 : 8),
                child: CachedNetworkImage(
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
                ),
              ),
            ),
            const SizedBox(height: 8),"""

card_new = """  Widget _buildCard(String imageUrl, String title, String subtitle, {bool isCircular = false, VoidCallback? onTap, int? rank}) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: rank != null
                        ? BoxDecoration(
                            border: Border.all(color: const Color(0xFF144477), width: 3),
                            borderRadius: BorderRadius.circular(isCircular ? 60 : 11),
                          )
                        : null,
                    padding: rank != null ? const EdgeInsets.all(3) : EdgeInsets.zero,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(isCircular ? 60 : 8),
                      child: CachedNetworkImage(
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
                      ),
                    ),
                  ),
                  if (rank != null)
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: const Color(0xFF144477),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            '$rank',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),"""

content = content.replace(card_original, card_new)

# 5. Pass rank in the Top 10 Mexico callback
top10_call_pattern = r"return _buildCard\(item\['cover_url'\] \?\? '', item\['title'\] \?\? '', item\['artist'\] \?\? '', onTap: \(\) \{"
top10_call_new = "return _buildCard(item['cover_url'] ?? '', item['title'] ?? '', item['artist'] ?? '', rank: index + 1, onTap: () {"

# Be careful to only replace the first occurrence (which is Top 10 Mexico). Actually, we can use re.sub with count=1.
content = re.sub(top10_call_pattern, top10_call_new, content, count=1)


with open('cliente-finamp/lib/screens/synap_music/main_home_screen.dart', 'w') as f:
    f.write(content)

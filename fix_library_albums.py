import re

with open('cliente-finamp/lib/screens/synap_music/library_playlists_screen.dart', 'r') as f:
    content = f.read()

# Add imports
imports = """import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'album_detail_screen.dart';"""
if "album_detail_screen.dart" not in content:
    content = content.replace("import 'playlist_detail_screen.dart';", "import 'playlist_detail_screen.dart';\n" + imports)

# Add state variable
state_new = """  bool _isLoading = true;
  String? _errorMessage;
  List<dynamic> _favoriteAlbums = [];"""
content = content.replace("  bool _isLoading = true;\n  String? _errorMessage;", state_new)

# Add load favorites logic
load_new = """  Future<void> _loadPlaylists() async {
    try {
      final playlists = await _apiService.getUserPlaylists();
      if (mounted) {
        setState(() {
          _playlists = playlists;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
    await _loadFavoriteAlbums();
  }

  Future<void> _loadFavoriteAlbums() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/synap_favorite_albums.json');
      if (await file.exists()) {
        final content = await file.readAsString();
        if (mounted) {
          setState(() {
            _favoriteAlbums = json.decode(content);
          });
        }
      }
    } catch (e) {
      print('Error al cargar álbumes favoritos: $e');
    }
  }"""
content = re.sub(r"  Future<void> _loadPlaylists\(\) async \{.*?\n  \}", load_new, content, flags=re.DOTALL)

# Replace albums placeholder with Grid
placeholder_old = """            // Placeholder para Álbumes
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(
                  child: Text(
                    'No hay álbumes añadidos aún.',
                    style: TextStyle(fontSize: 16, color: Colors.grey.withOpacity(0.5)),
                  ),
                ),
              ),
            ),"""

placeholder_new = """            if (_favoriteAlbums.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(
                    child: Text(
                      'No hay álbumes favoritos aún.',
                      style: TextStyle(fontSize: 16, color: Colors.grey.withOpacity(0.5)),
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 0.85,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final album = _favoriteAlbums[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => AlbumDetailScreen(albumId: album['id']),
                          )).then((_) => _loadFavoriteAlbums());
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                  child: Image.network(
                                    album['cover_url'] ?? '',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (_, __, ___) => _buildPlaceholder(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      album['title'] ?? 'Sin nombre',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${album['artist'] ?? ''}',
                                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: _favoriteAlbums.length,
                  ),
                ),
              ),"""
content = content.replace(placeholder_old, placeholder_new)

with open('cliente-finamp/lib/screens/synap_music/library_playlists_screen.dart', 'w') as f:
    f.write(content)

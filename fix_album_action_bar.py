import re

with open('cliente-finamp/lib/screens/synap_music/album_detail_screen.dart', 'r') as f:
    content = f.read()

# Add imports for path_provider and dart:io, dart:convert
imports_pattern = "import '../../components/track_list_item.dart';"
imports_new = """import '../../components/track_list_item.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';"""
content = content.replace(imports_pattern, imports_new)

# Add state variables
state_pattern = """  Map<String, dynamic>? _albumData;
  List<dynamic> _tracks = [];

  @override"""
state_new = """  Map<String, dynamic>? _albumData;
  List<dynamic> _tracks = [];
  bool _isFavorite = false;

  @override"""
content = content.replace(state_pattern, state_new)

# Add favorites loading logic
init_pattern = """        _isLoading = false;
      }); */
    }
  }"""
init_new = """        _isLoading = false;
      }); */
    }
    await _checkIfFavorite();
  }

  Future<File> _getFavoritesFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/synap_favorite_albums.json');
  }

  Future<void> _checkIfFavorite() async {
    try {
      final file = await _getFavoritesFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> favorites = json.decode(content);
        if (mounted) {
          setState(() {
            _isFavorite = favorites.any((a) => a['id'] == widget.albumId);
          });
        }
      }
    } catch (e) {
      print('Error al cargar favoritos: $e');
    }
  }

  Future<void> _toggleFavorite() async {
    if (_albumData == null) return;
    
    try {
      final file = await _getFavoritesFile();
      List<dynamic> favorites = [];
      if (await file.exists()) {
        final content = await file.readAsString();
        favorites = json.decode(content);
      }
      
      if (_isFavorite) {
        favorites.removeWhere((a) => a['id'] == widget.albumId);
      } else {
        favorites.add({
          'id': widget.albumId,
          'title': _albumData!['title'],
          'artist': _albumData!['artist'],
          'cover_url': _albumData!['cover_url'],
          'year': _albumData!['year']
        });
      }
      
      await file.writeAsString(json.encode(favorites));
      
      if (mounted) {
        setState(() {
          _isFavorite = !_isFavorite;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isFavorite ? 'Álbum añadido a favoritos' : 'Álbum removido de favoritos')),
        );
      }
    } catch (e) {
      print('Error al guardar favorito: $e');
    }
  }"""
content = content.replace(init_pattern, init_new)

# Insert the Action Bar below the Album Info
action_bar = """
                            const SizedBox(height: 20),
                            // ACTION BAR
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // 1. Play
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF144477),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.play_arrow, size: 36, color: Colors.black),
                                    onPressed: () async {
                                      if (_tracks.isEmpty) return;
                                      List<BaseItemDto> availableTracks = [];
                                      for (final track in _tracks) {
                                        final lm = track['local_match'];
                                        if (lm != null && lm['exists'] == true && lm['jellyfin_data'] != null) {
                                          availableTracks.add(BaseItemDto.fromJson(lm['jellyfin_data']));
                                        }
                                      }
                                      if (availableTracks.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No hay pistas disponibles')));
                                        return;
                                      }
                                      await GetIt.instance<AudioServiceHelper>().replaceQueueWithItem(
                                        itemList: availableTracks,
                                        initialIndex: 0,
                                      );
                                      if (mounted) Navigator.of(context, rootNavigator: true).pushNamed(PlayerScreen.routeName);
                                    },
                                  ),
                                ),
                                // 2. Shuffle
                                IconButton(
                                  icon: const Icon(Icons.shuffle, size: 28, color: Colors.white),
                                  onPressed: () async {
                                    if (_tracks.isEmpty) return;
                                    List<BaseItemDto> availableTracks = [];
                                    for (final track in _tracks) {
                                      final lm = track['local_match'];
                                      if (lm != null && lm['exists'] == true && lm['jellyfin_data'] != null) {
                                        availableTracks.add(BaseItemDto.fromJson(lm['jellyfin_data']));
                                      }
                                    }
                                    if (availableTracks.isEmpty) return;
                                    await GetIt.instance<AudioServiceHelper>().replaceQueueWithItem(
                                      itemList: availableTracks,
                                      initialIndex: 0,
                                      shuffle: true,
                                    );
                                    if (mounted) Navigator.of(context, rootNavigator: true).pushNamed(PlayerScreen.routeName);
                                  },
                                ),
                                // 3. Favorite
                                IconButton(
                                  icon: Icon(
                                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                                    size: 28,
                                    color: _isFavorite ? Colors.red : Colors.white,
                                  ),
                                  onPressed: _toggleFavorite,
                                ),
                                // 4. Download
                                IconButton(
                                  icon: const Icon(Icons.download, size: 28, color: Colors.white),
                                  onPressed: _downloadFullAlbum,
                                ),
                              ],
                            ),
                          ],"""
content = content.replace("                            const SizedBox(height: 20),\n                          ],", action_bar)

with open('cliente-finamp/lib/screens/synap_music/album_detail_screen.dart', 'w') as f:
    f.write(content)

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/jellyfin_models.dart';
import '../services/jellyfin_api_helper.dart';
import '../services/synap_api_service.dart';
import 'create_playlist_dialog.dart';

class AddToPlaylistSheet extends StatefulWidget {
  final BaseItemDto track;

  const AddToPlaylistSheet({Key? key, required this.track}) : super(key: key);

  @override
  _AddToPlaylistSheetState createState() => _AddToPlaylistSheetState();
}

class _AddToPlaylistSheetState extends State<AddToPlaylistSheet> {
  final JellyfinApiHelper _jellyfinHelper = GetIt.instance<JellyfinApiHelper>();
  final Color _synapColor = const Color(0xFF8B93FF);

  late Future<List<BaseItemDto>?> _playlistsFuture;
  final Set<String> _containingPlaylists = {};
  bool _isLoadingStatus = true;

  @override
  void initState() {
    super.initState();
    _loadPlaylists();
  }

  void _loadPlaylists() {
    _playlistsFuture = _jellyfinHelper.getPlaylists();
    _fetchPlaylistsAndStatus();
  }

  Future<void> _fetchPlaylistsAndStatus() async {
    try {
      final playlists = await _playlistsFuture;
      if (playlists != null) {
        for (var p in playlists) {
          final items = await _jellyfinHelper.getItems(
            parentId: p.id,
            includeItemTypes: "Audio",
          );
          if (items != null && items.any((t) => t.id == widget.track.id)) {
            _containingPlaylists.add(p.id!);
          }
        }
      }
    } catch (e) {
      print('Error al consultar playlists del track: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingStatus = false;
        });
      }
    }
  }

  Future<void> _togglePlaylist(BaseItemDto playlist) async {
    final playlistId = playlist.id!;
    final alreadyIn = _containingPlaylists.contains(playlistId);

    setState(() {
      if (alreadyIn) {
        _containingPlaylists.remove(playlistId);
      } else {
        _containingPlaylists.add(playlistId);
      }
    });

    try {
      if (alreadyIn) {
        await _jellyfinHelper.removeFromPlaylist(
          playlistId: playlistId,
          entryIds: [widget.track.id!],
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Eliminado de "${playlist.name}"')),
          );
        }
      } else {
        await _jellyfinHelper.addToPlaylist(
          playlistId: playlistId,
          itemIds: [widget.track.id!],
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Añadido a "${playlist.name}"')),
          );
        }
      }
    } catch (e) {
      // Revertir si hubo error
      setState(() {
        if (alreadyIn) {
          _containingPlaylists.add(playlistId);
        } else {
          _containingPlaylists.remove(playlistId);
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al modificar playlist: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF161616),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Agregar a playlist',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Color(0xFF8B93FF)),
                tooltip: 'Nueva playlist',
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (_) => const CreatePlaylistDialog(),
                  );
                  setState(() {
                    _loadPlaylists();
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Flexible(
            child: FutureBuilder<List<BaseItemDto>?>(
              future: _playlistsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: CircularProgressIndicator(),
                  ));
                }

                final playlists = snapshot.data ?? [];
                if (playlists.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Text(
                      'No tienes playlists creadas aún.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: playlists.length,
                  itemBuilder: (context, index) {
                    final playlist = playlists[index];
                    final isChecked = _containingPlaylists.contains(playlist.id);

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFF242424),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.queue_music, color: Colors.white70),
                      ),
                      title: Text(
                        playlist.name ?? 'Sin nombre',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      trailing: Checkbox(
                        activeColor: _synapColor,
                        checkColor: Colors.black,
                        value: isChecked,
                        onChanged: (_) => _togglePlaylist(playlist),
                      ),
                      onTap: () => _togglePlaylist(playlist),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

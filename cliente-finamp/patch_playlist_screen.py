with open('lib/screens/synap_music/playlist_detail_screen.dart', 'r') as f:
    content = f.read()

import re

# Add imports
imports = """import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/synap_api_service.dart';
import '../../services/sync_helper.dart';
import '../../services/downloads_helper.dart';
import '../../models/jellyfin_models.dart';
import '../../models/finamp_models.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';
"""

content = re.sub(r"import 'package:flutter/material.dart';\nimport 'package:get_it/get_it.dart';\nimport '../../services/jellyfin_api_helper.dart';\nimport '../../models/jellyfin_models.dart';", imports, content)

# State variables
state_vars = """  final Color _synapColor = const Color(0xFF144477);
  late Future<List<BaseItemDto>> _itemsFuture;
  late String _imageUrl;
  bool _isDownloading = false;
  final DownloadsHelper _downloadsHelper = GetIt.instance<DownloadsHelper>();
  late ValueNotifier<bool> _isDownloadedNotifier;
"""
content = re.sub(r"  final Color _synapColor = const Color\(0xFF144477\);\n  late Future<List<BaseItemDto>> _itemsFuture;\n  late String _imageUrl;", state_vars, content)

# InitState
init_state_old = """  @override
  void initState() {
    super.initState();
    _imageUrl = 'http://192.168.3.23:8096/Items/${widget.playlist.id}/Images/Primary';
    _loadItems();
  }"""

init_state_new = """  @override
  void initState() {
    super.initState();
    _imageUrl = 'http://192.168.3.23:8096/Items/${widget.playlist.id}/Images/Primary';
    _loadItems();
    
    _isDownloadedNotifier = ValueNotifier(_downloadsHelper.getDownloadedParent(widget.playlist.id) != null);
  }"""
content = content.replace(init_state_old, init_state_new)


# Download Method
download_method = """
  Future<void> _toggleDownload(bool value, List<BaseItemDto> items) async {
    setState(() { _isDownloading = true; });
    try {
      if (value) {
        // Encender: Descargar playlist y letras
        final syncHelper = DownloadsSyncHelper(Logger("SyncHelper"));
        syncHelper.sync(context, widget.playlist, items);
        
        // Descargar letras
        final directory = await getApplicationDocumentsDirectory();
        final lyricsDir = Directory('${directory.path}/lyrics');
        if (!await lyricsDir.exists()) {
          await lyricsDir.create(recursive: true);
        }
        
        final api = SynapApiService();
        for (var item in items) {
          if (item.name != null) {
            final artist = item.albumArtist ?? item.artists?.firstOrNull ?? '';
            final file = File('${lyricsDir.path}/${item.id}.lrc');
            if (!await file.exists()) {
              final lrc = await api.getLyrics(artist, item.name!);
              if (lrc != null && lrc.isNotEmpty) {
                await file.writeAsString(lrc);
              }
            }
          }
        }
      } else {
        // Apagar: Eliminar descargas
        await _downloadsHelper.deleteDownloadParent(deletedFor: widget.playlist.id);
        
        // No eliminamos las letras por si están en otra playlist, 
        // son texto plano así que no pesan casi nada.
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() { _isDownloading = false; });
      _isDownloadedNotifier.value = _downloadsHelper.getDownloadedParent(widget.playlist.id) != null;
    }
  }

  @override
"""
content = content.replace("  @override\n  Widget build(BuildContext context) {", download_method + "  Widget build(BuildContext context) {")


# Build SliverToBoxAdapter for switch
switch_widget = """          SliverToBoxAdapter(
            child: FutureBuilder<List<BaseItemDto>>(
              future: _itemsFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox.shrink();
                final items = snapshot.data!;
                return ValueListenableBuilder<Box<DownloadedParent>>(
                  valueListenable: _downloadsHelper.downloadedParentsListenable,
                  builder: (context, box, child) {
                    final isDownloaded = box.containsKey(widget.playlist.id);
                    return SwitchListTile(
                      title: const Text('Disponible sin conexión', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text('Descarga las canciones y letras locales'),
                      activeColor: _synapColor,
                      value: isDownloaded,
                      onChanged: _isDownloading ? null : (val) => _toggleDownload(val, items),
                    );
                  },
                );
              },
            ),
          ),
          SliverList("""

content = content.replace("          SliverList(", switch_widget)

with open('lib/screens/synap_music/playlist_detail_screen.dart', 'w') as f:
    f.write(content)

print("Playlist Screen patched")

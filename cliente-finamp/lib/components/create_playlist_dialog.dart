import 'package:flutter/material.dart';
import '../services/synap_events.dart';
import '../services/synap_api_service.dart';
import 'package:get_it/get_it.dart';
import '../services/finamp_user_helper.dart';

class CreatePlaylistDialog extends StatefulWidget {
  const CreatePlaylistDialog({Key? key}) : super(key: key);

  @override
  _CreatePlaylistDialogState createState() => _CreatePlaylistDialogState();
}

class _CreatePlaylistDialogState extends State<CreatePlaylistDialog> {
  final TextEditingController _nameController = TextEditingController();
  final SynapApiService _apiService = SynapApiService();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createPlaylist() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    final userHelper = GetIt.instance<FinampUserHelper>();
    final userId = userHelper.currentUser?.id;
    final playlistId = await _apiService.createPlaylist(name, userId: userId);

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      if (playlistId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Playlist "$name" creada exitosamente.'),
            backgroundColor: Colors.green,
          ),
        );
        SynapEvents.fireLibraryRefresh();
        Navigator.of(context).pop(true); // Return true indicating success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al crear la playlist.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color synapColor = Color(0xFF144477);

    return AlertDialog(
      title: const Text('Crear nueva playlist'),
      content: TextField(
        controller: _nameController,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Nombre de la playlist',
          border: OutlineInputBorder(),
        ),
        onSubmitted: (_) => _createPlaylist(),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _createPlaylist,
          style: ElevatedButton.styleFrom(backgroundColor: synapColor),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('Crear', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../services/synap_api_service.dart';

class RequestMetadataSheet extends StatefulWidget {
  final String trackId;
  final String initialTitle;
  final String initialArtist;
  final String? initialAlbum;

  const RequestMetadataSheet({
    Key? key,
    required this.trackId,
    required this.initialTitle,
    required this.initialArtist,
    this.initialAlbum,
  }) : super(key: key);

  @override
  _RequestMetadataSheetState createState() => _RequestMetadataSheetState();
}

class _RequestMetadataSheetState extends State<RequestMetadataSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _artistController;
  late final TextEditingController _albumController;
  late final TextEditingController _yearController;
  late final TextEditingController _commentController;

  final SynapApiService _apiService = SynapApiService();
  final Color _synapColor = const Color(0xFF8B93FF);

  bool _isSearching = false;
  bool _isSubmitting = false;
  Map<String, dynamic>? _previewData;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _artistController = TextEditingController(text: widget.initialArtist);
    _albumController = TextEditingController(text: widget.initialAlbum ?? '');
    _yearController = TextEditingController();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _artistController.dispose();
    _albumController.dispose();
    _yearController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _fetchPreview() async {
    final query = '${_titleController.text} ${_artistController.text}'.trim();
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
    });

    try {
      final top = await _apiService.previewMetadataMatch(query);
      if (top != null && top.isNotEmpty) {
        setState(() {
          _previewData = top;
          if (top['title'] != null) _titleController.text = top['title'];
          if (top['artist'] != null) _artistController.text = top['artist'];
          if (top['album'] != null) _albumController.text = top['album'];
        });
      }
    } catch (e) {
      print('Error al buscar vista previa: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    }
  }

  Future<void> _submitRequest() async {
    final title = _titleController.text.trim();
    final artist = _artistController.text.trim();

    if (title.isEmpty || artist.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El título y artista son obligatorios.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final success = await _apiService.sendMetadataRequest(
        itemId: widget.trackId,
        currentTitle: widget.initialTitle,
        currentArtist: widget.initialArtist,
        proposedQuery: '$title $artist',
        proposedCoverUrl: _previewData?['cover_url'],
        note: _commentController.text.trim().isNotEmpty ? _commentController.text.trim() : null,
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Solicitud de corrección enviada al administrador.')),
          );
          Navigator.of(context).pop(true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al enviar la solicitud. Intenta nuevamente.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Revisar y Editar Metadatos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Título de la canción',
                labelStyle: TextStyle(color: _synapColor),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _artistController,
              decoration: InputDecoration(
                labelText: 'Artista',
                labelStyle: TextStyle(color: _synapColor),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _albumController,
              decoration: InputDecoration(
                labelText: 'Álbum (opcional)',
                labelStyle: TextStyle(color: _synapColor),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: _synapColor,
                side: BorderSide(color: _synapColor),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: _isSearching
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.auto_fix_high),
              label: const Text('Detectar automáticamente y buscar carátula'),
              onPressed: _isSearching ? null : _fetchPreview,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _synapColor,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _isSubmitting ? null : _submitRequest,
              child: _isSubmitting
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                  : const Text('Guardar y Enriquecer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

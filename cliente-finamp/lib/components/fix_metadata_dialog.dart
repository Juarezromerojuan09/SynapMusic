import 'package:flutter/material.dart';
import '../services/synap_api_service.dart';

class FixMetadataDialog extends StatefulWidget {
  final String itemId;
  final String currentTitle;

  const FixMetadataDialog({
    Key? key,
    required this.itemId,
    required this.currentTitle,
  }) : super(key: key);

  @override
  State<FixMetadataDialog> createState() => _FixMetadataDialogState();
}

class _FixMetadataDialogState extends State<FixMetadataDialog> {
  final SynapApiService _apiService = SynapApiService();
  late TextEditingController _queryController;
  late TextEditingController _coverController;
  late TextEditingController _lyricsController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _queryController = TextEditingController(text: widget.currentTitle);
    _coverController = TextEditingController();
    _lyricsController = TextEditingController();
  }

  @override
  void dispose() {
    _queryController.dispose();
    _coverController.dispose();
    _lyricsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final query = _queryController.text.trim();
    if (query.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      await _apiService.editMetadata(
        itemId: widget.itemId,
        query: query,
        manualCoverUrl: _coverController.text.isNotEmpty ? _coverController.text : null,
        manualLyrics: _lyricsController.text.isNotEmpty ? _lyricsController.text : null,
      );

      if (mounted) {
        Navigator.pop(context, true); // Devuelve true si fue exitoso
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Metadatos actualizados con éxito. Recarga la página para ver los cambios.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar metadatos: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Corregir Metadatos',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Limpia el título si tiene "Official Video" para ayudar al autocompletado.',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _queryController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Título para búsqueda',
                labelStyle: const TextStyle(color: Colors.white54),
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF144477))),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Opción Manual (Deja vacío para autocompletar)',
              style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _coverController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'URL de Portada (Opcional)',
                labelStyle: TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF144477))),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _lyricsController,
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Letra exacta (Opcional)',
                labelStyle: TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF144477))),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF144477)),
                  child: _isLoading 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Aplicar / Autocompletar', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

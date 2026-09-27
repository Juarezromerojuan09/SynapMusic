import 'package:flutter/material.dart';
import '../../services/synap_api_service.dart';

class MetadataRequestsScreen extends StatefulWidget {
  const MetadataRequestsScreen({Key? key}) : super(key: key);

  @override
  _MetadataRequestsScreenState createState() => _MetadataRequestsScreenState();
}

class _MetadataRequestsScreenState extends State<MetadataRequestsScreen> {
  final SynapApiService _apiService = SynapApiService();
  final Color _synapColor = const Color(0xFF8B93FF);

  bool _isLoading = true;
  List<dynamic> _requests = [];

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final list = await _apiService.getMetadataRequests();
      if (mounted) {
        setState(() {
          _requests = list;
        });
      }
    } catch (e) {
      print('Error al obtener solicitudes de metadatos: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _applyRequest(dynamic request) async {
    final requestId = request['id']?.toString();
    if (requestId == null) return;

    try {
      final success = await _apiService.applyMetadataRequest(requestId);
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Metadatos aplicados correctamente.')),
          );
          _fetchRequests();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al aplicar solicitud de metadatos.')),
          );
        }
      }
    } catch (e) {
      print('Error al aplicar solicitud de metadatos: $e');
    }
  }

  Future<void> _deleteRequest(String requestId) async {
    try {
      final success = await _apiService.deleteMetadataRequest(requestId);
      if (mounted) {
        if (success) {
          setState(() {
            _requests.removeWhere((r) => r['id'] == requestId);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Solicitud eliminada.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al eliminar solicitud de metadatos.')),
          );
        }
      }
    } catch (e) {
      print('Error al eliminar solicitud de metadatos: $e');
    }
  }

  void _openEditAndApplyDialog(dynamic request) {
    final titleController = TextEditingController(text: request['current_title'] ?? '');
    final artistController = TextEditingController(text: request['current_artist'] ?? '');
    final queryController = TextEditingController(text: request['proposed_query'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Revisar y Editar Metadatos', style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Título actual', labelStyle: TextStyle(color: Colors.grey)),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: artistController,
                decoration: const InputDecoration(labelText: 'Artista actual', labelStyle: TextStyle(color: Colors.grey)),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: queryController,
                decoration: const InputDecoration(labelText: 'Búsqueda propuesta', labelStyle: TextStyle(color: Colors.grey)),
                style: const TextStyle(color: Colors.white),
              ),
              if (request['note'] != null && (request['note'] as String).isNotEmpty) ...[
                const SizedBox(height: 12),
                Text('Nota: ${request['note']}', style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _synapColor),
            onPressed: () {
              Navigator.pop(context);
              request['proposed_query'] = queryController.text;
              _applyRequest(request);
            },
            child: const Text('Aplicar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = _requests.isNotEmpty
        ? 'Solicitudes de Metadatos (${_requests.length})'
        : 'Solicitudes de Metadatos';

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _fetchRequests,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF8B93FF)))
          : _requests.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.check_circle_outline, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Todas las pistas reportadas han sido procesadas.',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: _requests.length,
                  itemBuilder: (context, index) {
                    final req = _requests[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: const Color(0xFF1A1A1A),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _synapColor.withOpacity(0.2),
                          child: const Icon(Icons.music_note, color: Color(0xFF8B93FF)),
                        ),
                        title: Text(
                          req['current_title'] ?? req['title'] ?? 'Sin título',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Propuesto: ${req['proposed_query'] ?? req['current_artist'] ?? ''}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check_circle, color: Colors.green),
                              onPressed: () => _applyRequest(req),
                              tooltip: 'Aplicar',
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              onPressed: () => _deleteRequest(req['id'].toString()),
                              tooltip: 'Eliminar',
                            ),
                          ],
                        ),
                        onTap: () => _openEditAndApplyDialog(req),
                      ),
                    );
                  },
                ),
    );
  }
}

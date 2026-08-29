import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../services/synap_api_service.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  static const routeName = "/admin_dashboard";

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  List<dynamic> _pendingUsers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPendingUsers();
  }

  Future<void> _fetchPendingUsers() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final synapApi = SynapApiService();
      final url = Uri.parse('${synapApi.baseUrl}/users/pending');
      final response = await http.get(
        url,
        headers: {
          'X-API-Key': synapApi.apiKey,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _pendingUsers = json.decode(response.body);
        });
      } else {
        _showError('Error cargando usuarios: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Error de conexión: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _approveUser(String userId) async {
    // Optimistic update optional, but loading dialog is safer
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0xFF144477))),
    );

    try {
      final synapApi = SynapApiService();
      final url = Uri.parse('${synapApi.baseUrl}/users/approve/$userId');
      final response = await http.post(
        url,
        headers: {
          'X-API-Key': synapApi.apiKey,
        },
      );

      Navigator.of(context).pop(); // Close dialog

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario aprobado correctamente')),
        );
        _fetchPendingUsers(); // Refresh list
      } else {
        _showError('Error al aprobar: ${response.body}');
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close dialog
      _showError('Error de conexión: $e');
    }
  }

  void _showError(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sala de Espera (Admin)'),
        backgroundColor: const Color(0xFF144477),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchPendingUsers,
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF144477)))
          : _pendingUsers.isEmpty
              ? const Center(
                  child: Text(
                    'No hay usuarios en sala de espera.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: _pendingUsers.length,
                  itemBuilder: (context, index) {
                    final user = _pendingUsers[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: Colors.grey[900],
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFF144477),
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(user['Name'] ?? 'Desconocido', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        subtitle: const Text('Esperando aprobación', style: TextStyle(color: Colors.white70)),
                        trailing: IconButton(
                          icon: const Icon(Icons.check_circle, color: Colors.green, size: 30),
                          onPressed: () => _approveUser(user['Id']),
                          tooltip: 'Aprobar Usuario',
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

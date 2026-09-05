import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../services/finamp_user_helper.dart';
import '../../services/synap_api_service.dart';

class HelpFeedbackScreen extends StatefulWidget {
  final bool isAdmin;

  const HelpFeedbackScreen({Key? key, this.isAdmin = false}) : super(key: key);

  @override
  State<HelpFeedbackScreen> createState() => _HelpFeedbackScreenState();
}

class _HelpFeedbackScreenState extends State<HelpFeedbackScreen> with SingleTickerProviderStateMixin {
  final SynapApiService _apiService = SynapApiService();
  final Color _accentColor = const Color(0xFF8B93FF);

  late bool _isAdmin;
  TabController? _tabController;

  // Estado del Formulario de Usuario
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final List<File> _attachedImages = [];
  bool _isSending = false;

  // Estado de la Lista de Administrador
  List<dynamic> _feedbackList = [];
  bool _isLoadingFeedback = true;

  @override
  void initState() {
    super.initState();
    _isAdmin = widget.isAdmin;
    if (_isAdmin) {
      _tabController = TabController(length: 2, vsync: this);
      _loadFeedbackList();
    } else {
      _checkAdminStatus();
    }
  }

  Future<void> _checkAdminStatus() async {
    try {
      final userHelper = GetIt.instance<FinampUserHelper>();
      final currentUser = userHelper.currentUser;
      if (currentUser == null) return;

      final url = Uri.parse('${currentUser.baseUrl}/Users/${currentUser.id}');
      final response = await http.get(url, headers: {
        'X-Emby-Token': currentUser.accessToken,
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final isAdmin = data['Policy']?['IsAdministrator'] ?? false;
        if (isAdmin != _isAdmin && mounted) {
          setState(() {
            _isAdmin = isAdmin;
            if (_isAdmin && _tabController == null) {
              _tabController = TabController(length: 2, vsync: this);
              _loadFeedbackList();
            }
          });
        }
      }
    } catch (_) {}
  }

  Future<void> _loadFeedbackList() async {
    setState(() => _isLoadingFeedback = true);
    final list = await _apiService.getFeedbackList();
    if (mounted) {
      setState(() {
        _feedbackList = list;
        _isLoadingFeedback = false;
      });
    }
  }

  Future<void> _pickImages() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (result != null && result.paths.isNotEmpty) {
        setState(() {
          for (final path in result.paths) {
            if (path != null) {
              final file = File(path);
              if (!_attachedImages.any((f) => f.path == file.path)) {
                _attachedImages.add(file);
              }
            }
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al seleccionar imagen: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _attachedImages.removeAt(index);
    });
  }

  Future<void> _submitFeedback() async {
    final title = _titleController.text.trim();
    final message = _messageController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa un título para el comentario'), backgroundColor: Colors.orange),
      );
      return;
    }

    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor escribe tu comentario o reporte'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isSending = true);

    final userHelper = GetIt.instance<FinampUserHelper>();
    final currentUser = userHelper.currentUser;
    final userId = currentUser?.id ?? 'anonimo';
    
    // Obtener nombre de usuario
    String userName = 'Usuario';
    try {
      if (currentUser != null) {
        final url = Uri.parse('${currentUser.baseUrl}/Users/${currentUser.id}');
        final res = await http.get(url, headers: {'X-Emby-Token': currentUser.accessToken});
        if (res.statusCode == 200) {
          final d = json.decode(res.body);
          userName = d['Name'] ?? 'Usuario';
        }
      }
    } catch (_) {}

    final success = await _apiService.sendFeedback(
      userId: userId,
      userName: userName,
      title: title,
      message: message,
      images: _attachedImages,
    );

    if (mounted) {
      setState(() => _isSending = false);
      if (success) {
        _titleController.clear();
        _messageController.clear();
        setState(() {
          _attachedImages.clear();
        });

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF1A1A1A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                Icon(Icons.check_circle, color: _accentColor, size: 26),
                const SizedBox(width: 10),
                const Text('¡Comentario enviado!', style: TextStyle(color: Colors.white, fontSize: 18)),
              ],
            ),
            content: const Text(
              'Tu comentario y capturas han sido enviados al equipo de soporte técnico con éxito. Gracias por ayudarnos a mejorar SynapMusic.',
              style: TextStyle(color: Color(0xFFA0A0A0), height: 1.4),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (_isAdmin) {
                    _loadFeedbackList();
                    _tabController?.animateTo(0);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentColor,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Aceptar', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al enviar comentario. Inténtalo nuevamente.'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _deleteFeedbackItem(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Eliminar Comentario', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text('¿Deseas eliminar este comentario de la bandeja de retroalimentación?', style: TextStyle(color: Color(0xFFA0A0A0))),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar', style: TextStyle(color: Color(0xFFA0A0A0))),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final ok = await _apiService.deleteFeedback(id);
      if (ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comentario eliminado'), backgroundColor: Colors.green),
        );
        _loadFeedbackList();
      }
    }
  }

  void _showImageZoom(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black.withOpacity(0.92),
        insetPadding: const EdgeInsets.all(10),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Center(
              child: InteractiveViewer(
                panEnabled: true,
                minScale: 0.5,
                maxScale: 4.0,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                  placeholder: (_, __) => const Center(child: CircularProgressIndicator(color: Color(0xFF8B93FF))),
                  errorWidget: (_, __, ___) => const Center(child: Icon(Icons.broken_image, color: Colors.white54, size: 48)),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFeedbackDetail(Map<String, dynamic> item) {
    final images = (item['images'] as List<dynamic>?) ?? [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.85,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Barra superior modal
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Usuario y Fecha CDMX
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _accentColor.withOpacity(0.18),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.person, color: _accentColor, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['user_name'] ?? 'Usuario',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 12, color: Color(0xFFA0A0A0)),
                                const SizedBox(width: 4),
                                Text(
                                  '${item['created_at'] ?? ''} (CDMX)',
                                  style: const TextStyle(color: Color(0xFFA0A0A0), fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                        tooltip: 'Eliminar comentario',
                        onPressed: () {
                          Navigator.of(context).pop();
                          _deleteFeedbackItem(item['id']);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(color: Colors.white12),
                  const SizedBox(height: 12),

                  // Título
                  Text(
                    item['title'] ?? 'Sin título',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Mensaje completo
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141414),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF262626)),
                    ),
                    child: Text(
                      item['message'] ?? '',
                      style: const TextStyle(
                        color: Color(0xFFDDDDDD),
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Imágenes adjuntas
                  if (images.isNotEmpty) ...[
                    Row(
                      children: [
                        Icon(Icons.photo_library, color: _accentColor, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Capturas de pantalla adjuntas (${images.length}):',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: images.length,
                      itemBuilder: (context, idx) {
                        final filename = images[idx];
                        final imgUrl = _apiService.getFeedbackImageUrl(filename);
                        return GestureDetector(
                          onTap: () => _showImageZoom(imgUrl),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: imgUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) => Container(
                                    color: const Color(0xFF222222),
                                    child: const Center(child: CircularProgressIndicator(color: Color(0xFF8B93FF), strokeWidth: 2)),
                                  ),
                                  errorWidget: (_, __, ___) => Container(
                                    color: const Color(0xFF222222),
                                    child: const Icon(Icons.broken_image, color: Colors.white38),
                                  ),
                                ),
                                Positioned(
                                  bottom: 6,
                                  right: 6,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Icon(Icons.zoom_in, color: Colors.white, size: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFeedbackForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner de ayuda
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_accentColor.withOpacity(0.2), const Color(0xFF1A1A1A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _accentColor.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _accentColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.support_agent, color: _accentColor, size: 28),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Envía un comentario a soporte técnico para mejorar la app',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Reporta fallos, sugiere ideas o cuéntanos tu experiencia.',
                        style: TextStyle(
                          color: Color(0xFFA0A0A0),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Campo: Título
          const Text(
            'Título del comentario:',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _titleController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Ej. Error al reproducir canción, sugerencia de diseño...',
              hintStyle: const TextStyle(color: Color(0xFF707070), fontSize: 13),
              filled: true,
              fillColor: const Color(0xFF161616),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF262626)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: _accentColor, width: 1.5),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Campo: Mensaje
          const Text(
            'Comentario / Descripción:',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _messageController,
            maxLines: 5,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Explica con detalle el problema o la sugerencia para poder ayudarte mejor...',
              hintStyle: const TextStyle(color: Color(0xFF707070), fontSize: 13),
              filled: true,
              fillColor: const Color(0xFF161616),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF262626)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: _accentColor, width: 1.5),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Adjuntar capturas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Capturas de pantalla (opcional):',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              OutlinedButton.icon(
                onPressed: _pickImages,
                icon: Icon(Icons.add_photo_alternate, color: _accentColor, size: 18),
                label: Text(
                  'Adjuntar',
                  style: TextStyle(color: _accentColor, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: _accentColor.withOpacity(0.5)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  backgroundColor: _accentColor.withOpacity(0.08),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),

          if (_attachedImages.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 86,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _attachedImages.length,
                itemBuilder: (context, index) {
                  final file = _attachedImages[index];
                  return Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.only(right: 12),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            file,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.black87,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, color: Colors.redAccent, size: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],

          const SizedBox(height: 32),

          // Botón Enviar
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _isSending ? null : _submitFeedback,
              icon: _isSending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                    )
                  : const Icon(Icons.send, color: Colors.black),
              label: Text(
                _isSending ? 'Enviando...' : 'Enviar comentario',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildAdminFeedbackList() {
    if (_isLoadingFeedback) {
      return Center(child: CircularProgressIndicator(color: _accentColor));
    }

    if (_feedbackList.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadFeedbackList,
        color: _accentColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[700]),
                  const SizedBox(height: 16),
                  const Text(
                    'No hay comentarios recibidos aún',
                    style: TextStyle(color: Color(0xFFA0A0A0), fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Desliza hacia abajo para actualizar',
                    style: TextStyle(color: Color(0xFF666666), fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFeedbackList,
      color: _accentColor,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        itemCount: _feedbackList.length,
        itemBuilder: (context, index) {
          final item = _feedbackList[index];
          final images = (item['images'] as List<dynamic>?) ?? [];

          return Container(
            margin: const EdgeInsets.only(bottom: 12.0),
            decoration: BoxDecoration(
              color: const Color(0xFF161616),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF262626)),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => _showFeedbackDetail(item),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fila superior: Usuario y Fecha CDMX
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: _accentColor.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.person, color: _accentColor, size: 16),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item['user_name'] ?? 'Usuario',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 12, color: Color(0xFFA0A0A0)),
                            const SizedBox(width: 4),
                            Text(
                              '${item['created_at'] ?? ''} CDMX',
                              style: const TextStyle(
                                color: Color(0xFFA0A0A0),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Título
                    Text(
                      item['title'] ?? 'Sin título',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    // Mensaje preview
                    Text(
                      item['message'] ?? '',
                      style: const TextStyle(
                        color: Color(0xFFA0A0A0),
                        fontSize: 13,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 12),

                    // Fila inferior: Indicador de imágenes y ver más
                    Row(
                      children: [
                        if (images.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _accentColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.image, size: 13, color: _accentColor),
                                const SizedBox(width: 4),
                                Text(
                                  '${images.length} captura(s)',
                                  style: TextStyle(
                                    color: _accentColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const Spacer(),
                        Text(
                          'Ver detalle',
                          style: TextStyle(color: _accentColor, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.chevron_right, color: _accentColor, size: 18),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Ayuda y comentarios',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        bottom: _isAdmin && _tabController != null
            ? TabBar(
                controller: _tabController,
                indicatorColor: _accentColor,
                labelColor: _accentColor,
                unselectedLabelColor: const Color(0xFFA0A0A0),
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                tabs: [
                  Tab(
                    icon: const Icon(Icons.feedback, size: 20),
                    text: 'Comentarios (${_feedbackList.length})',
                  ),
                  const Tab(
                    icon: Icon(Icons.send, size: 20),
                    text: 'Enviar comentario',
                  ),
                ],
              )
            : null,
      ),
      body: _isAdmin && _tabController != null
          ? TabBarView(
              controller: _tabController,
              children: [
                _buildAdminFeedbackList(),
                _buildFeedbackForm(),
              ],
            )
          : _buildFeedbackForm(),
    );
  }
}

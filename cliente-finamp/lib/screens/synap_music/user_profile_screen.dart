import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../../models/finamp_models.dart';
import '../../models/jellyfin_models.dart';
import '../../services/finamp_user_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/likes_playlist_helper.dart';
import '../../services/music_player_background_task.dart';
import '../../services/synap_api_service.dart';
import '../splash_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final SynapApiService _apiService = SynapApiService();
  final Color _accentColor = const Color(0xFF8B93FF);

  String _userId = '';
  String _username = '';
  String _serverUrl = 'http://100.81.156.126:8096';
  bool _isAdmin = false;
  bool _isLoading = true;
  bool _isUploadingImage = false;
  int _cacheBuster = DateTime.now().millisecondsSinceEpoch;

  // Estadísticas
  int _likesCount = 0;
  int _playlistsCount = 0;
  int _downloadsCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userHelper = GetIt.instance<FinampUserHelper>();
      final currentUser = userHelper.currentUser;
      if (currentUser == null) {
        setState(() => _isLoading = false);
        return;
      }

      _userId = currentUser.id;
      _serverUrl = currentUser.baseUrl;

      // 1. Obtener datos de usuario de Jellyfin
      final url = Uri.parse('$_serverUrl/Users/$_userId');
      final response = await http.get(url, headers: {
        'X-Emby-Token': currentUser.accessToken,
      });

      String name = 'Usuario';
      bool isAdmin = false;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        name = data['Name'] ?? 'Usuario';
        isAdmin = data['Policy']?['IsAdministrator'] ?? false;
      }

      // 2. Obtener conteo de playlists y "My likes"
      int likesCount = 0;
      int playlistsCount = 0;
      try {
        final playlistsData = await _apiService.getUserPlaylists(userId: _userId);
        playlistsCount = playlistsData.length;
        for (final pl in playlistsData) {
          final dto = BaseItemDto.fromJson(pl);
          if (LikesPlaylistHelper.isLikesPlaylist(dto)) {
            final jellyfin = GetIt.instance<JellyfinApiHelper>();
            final items = await jellyfin.getItems(parentItem: dto, isGenres: false) ?? [];
            likesCount = items.length;
            break;
          }
        }
      } catch (_) {}

      // 3. Obtener conteo de descargas offline
      int downloadsCount = 0;
      try {
        if (Hive.isBoxOpen('DownloadedItems')) {
          final box = Hive.box<DownloadedSong>('DownloadedItems');
          downloadsCount = box.length;
        }
      } catch (_) {}

      if (mounted) {
        setState(() {
          _username = name;
          _isAdmin = isAdmin;
          _likesCount = likesCount;
          _playlistsCount = playlistsCount;
          _downloadsCount = downloadsCount;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error al cargar perfil: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result == null || result.files.single.path == null) return;

      setState(() => _isUploadingImage = true);

      final file = File(result.files.single.path!);
      final bytes = await file.readAsBytes();
      final ext = result.files.single.extension?.toLowerCase() ?? 'jpeg';
      final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';

      // 1. Intentar actualizar vía SynapApiService
      bool success = await _apiService.updateUserAvatar(_userId, bytes, mimeType: mimeType);

      // 2. Si falla, intentar directamente con Jellyfin API
      if (!success) {
        final userHelper = GetIt.instance<FinampUserHelper>();
        final currentUser = userHelper.currentUser;
        if (currentUser != null) {
          final url = Uri.parse('${currentUser.baseUrl}/Users/${currentUser.id}/Images/Primary');
          final resp = await http.post(
            url,
            headers: {
              'X-Emby-Token': currentUser.accessToken,
              'Content-Type': mimeType,
            },
            body: bytes,
          );
          if (resp.statusCode == 200 || resp.statusCode == 204) {
            success = true;
          }
        }
      }

      if (success) {
        // Limpiar caché de imágenes de Flutter para ver el cambio de inmediato
        PaintingBinding.instance.imageCache.clear();
        PaintingBinding.instance.imageCache.clearLiveImages();

        if (mounted) {
          setState(() {
            _cacheBuster = DateTime.now().millisecondsSinceEpoch;
            _isUploadingImage = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Foto de perfil actualizada exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        throw Exception('El servidor no aceptó la imagen');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isUploadingImage = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cambiar foto: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showEditUsernameDialog() async {
    final controller = TextEditingController(text: _username);

    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Cambiar nombre de usuario',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Nuevo nombre de usuario',
            hintStyle: const TextStyle(color: Color(0xFFA0A0A0)),
            filled: true,
            fillColor: const Color(0xFF111111),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: _accentColor.withOpacity(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: _accentColor, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar', style: TextStyle(color: Color(0xFFA0A0A0))),
          ),
          ElevatedButton(
            onPressed: () {
              final val = controller.text.trim();
              if (val.isNotEmpty) {
                Navigator.of(context).pop(val);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _accentColor,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Guardar', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (newName != null && newName != _username) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator(color: Color(0xFF8B93FF))),
      );

      // 1. Intentar vía backend
      bool success = await _apiService.updateUserName(_userId, newName);

      // 2. Si falla, intentar directamente con Jellyfin
      if (!success) {
        final userHelper = GetIt.instance<FinampUserHelper>();
        final currentUser = userHelper.currentUser;
        if (currentUser != null) {
          try {
            final getUrl = Uri.parse('${currentUser.baseUrl}/Users/${currentUser.id}');
            final getResp = await http.get(getUrl, headers: {'X-Emby-Token': currentUser.accessToken});
            if (getResp.statusCode == 200) {
              final userData = json.decode(getResp.body);
              userData['Name'] = newName;
              final postResp = await http.post(
                getUrl,
                headers: {
                  'X-Emby-Token': currentUser.accessToken,
                  'Content-Type': 'application/json',
                },
                body: json.encode(userData),
              );
              if (postResp.statusCode == 200 || postResp.statusCode == 204) {
                success = true;
              }
            }
          } catch (_) {}
        }
      }

      Navigator.of(context).pop(); // Cierra loading

      if (success && mounted) {
        setState(() {
          _username = newName;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Nombre actualizado a "$newName"'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo actualizar el nombre de usuario'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text(
          '¿Estás seguro de que deseas cerrar sesión en SynapMusic?',
          style: TextStyle(color: Color(0xFFA0A0A0)),
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar', style: TextStyle(color: Color(0xFFA0A0A0))),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('Cerrar sesión', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      try {
        final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
        if (audioHandler.playbackState.valueOrNull?.playing == true) {
          await audioHandler.stop();
        }
        final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
        await jellyfinApiHelper.logoutCurrentUser().onError((_, __) {});

        if (!mounted) return;
        Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
          SplashScreen.routeName,
          (route) => false,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Widget _buildStatCard({required IconData icon, required String label, required String value}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF222222)),
        ),
        child: Column(
          children: [
            Icon(icon, color: _accentColor, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFFA0A0A0),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userImageUrl = '$_serverUrl/Users/$_userId/Images/Primary?v=$_cacheBuster';

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
          'Perfil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: _accentColor))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  // 1. Avatar circular centrado con botón de lápiz
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: _accentColor, width: 2.5),
                            boxShadow: [
                              BoxShadow(
                                color: _accentColor.withOpacity(0.25),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: _isUploadingImage
                                ? Container(
                                    color: const Color(0xFF1A1A1A),
                                    child: Center(
                                      child: CircularProgressIndicator(color: _accentColor),
                                    ),
                                  )
                                : CachedNetworkImage(
                                    imageUrl: userImageUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: const Color(0xFF1A1A1A),
                                      child: const Icon(Icons.person, size: 60, color: Color(0xFFA0A0A0)),
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                      color: const Color(0xFF1A1A1A),
                                      child: Center(
                                        child: Text(
                                          _username.isNotEmpty ? _username[0].toUpperCase() : 'U',
                                          style: TextStyle(
                                            fontSize: 48,
                                            fontWeight: FontWeight.bold,
                                            color: _accentColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        // Botón flotante de lápiz sobre el avatar
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickAndUploadImage,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: _accentColor,
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFF0A0A0A), width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // 2. Nombre de usuario con botón para editar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          _username,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _showEditUsernameDialog,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF2E2E2E)),
                          ),
                          child: Icon(
                            Icons.edit,
                            size: 16,
                            color: _accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // 3. Insignia de rol
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: _isAdmin ? _accentColor.withOpacity(0.16) : const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _isAdmin ? _accentColor.withOpacity(0.4) : const Color(0xFF333333),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isAdmin ? Icons.verified_user : Icons.person_outline,
                          size: 15,
                          color: _isAdmin ? _accentColor : const Color(0xFFA0A0A0),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _isAdmin ? 'Administrador' : 'Miembro SynapMusic',
                          style: TextStyle(
                            color: _isAdmin ? _accentColor : const Color(0xFFA0A0A0),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // 4. Métricas de música (Estadísticas)
                  Row(
                    children: [
                      _buildStatCard(
                        icon: Icons.favorite,
                        label: 'Favoritas',
                        value: '$_likesCount',
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        icon: Icons.queue_music,
                        label: 'Playlists',
                        value: '$_playlistsCount',
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        icon: Icons.download_done,
                        label: 'Descargas',
                        value: '$_downloadsCount',
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // 5. Tarjeta de Servidor y Estado
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF222222)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Detalles de Conexión',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFA0A0A0),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF121212),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(Icons.dns, color: _accentColor, size: 20),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Servidor Jellyfin',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _serverUrl,
                                    style: const TextStyle(
                                      color: Color(0xFFA0A0A0),
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(radius: 3, backgroundColor: Colors.greenAccent),
                                  SizedBox(width: 5),
                                  Text(
                                    'En línea',
                                    style: TextStyle(color: Colors.greenAccent, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 6. Botón de Cerrar Sesión
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout, color: Colors.redAccent, size: 20),
                      label: const Text(
                        'Cerrar Sesión',
                        style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.redAccent.withOpacity(0.4)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Colors.redAccent.withOpacity(0.08),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }
}

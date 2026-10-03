import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';
import '../../components/synap_marquee_text.dart';
import '../../services/finamp_user_helper.dart';
import '../../services/synap_api_service.dart';
import 'metadata_requests_screen.dart';
import 'admin_user_detail_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  static const routeName = "/admin_dashboard";

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> with SingleTickerProviderStateMixin {
  final SynapApiService _apiService = SynapApiService();
  final Color _accentColor = const Color(0xFF8B93FF);

  late TabController _tabController;

  // Pestaña Usuarios
  List<Map<String, dynamic>> _users = [];
  bool _isLoadingUsers = true;
  String _searchQuery = '';
  String _selectedFilter = 'all'; // 'all', 'active', 'pending'
  String _serverUrl = 'http://100.64.134.104:8096';
  String _currentAdminId = '';

  // Pestaña Biblioteca Global
  Map<String, dynamic>? _libraryStats;
  bool _isLoadingStats = true;
  List<Map<String, dynamic>> _librarySongs = [];
  bool _isLoadingSongs = false;
  bool _isLoadingMoreSongs = false;
  int _totalSongsCount = 0;
  String _songSearchQuery = '';
  String _songSortBy = 'date_added'; // date_added, title, artist, duration_desc, duration_asc
  final ScrollController _libraryScrollController = ScrollController();
  bool _isScanningLibrary = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
      if (_tabController.index == 1 && _libraryStats == null && !_isLoadingStats) {
        _fetchLibraryStats();
        _fetchLibrarySongs(refresh: true);
      }
    });

    try {
      final userHelper = GetIt.instance<FinampUserHelper>();
      _serverUrl = userHelper.currentUser?.baseUrl ?? 'http://100.64.134.104:8096';
      _currentAdminId = userHelper.currentUser?.id ?? '';
    } catch (_) {}

    _fetchUsers();
    _fetchLibraryStats();
    _fetchLibrarySongs(refresh: true);

    _libraryScrollController.addListener(() {
      if (_libraryScrollController.position.pixels >= _libraryScrollController.position.maxScrollExtent - 250) {
        if (!_isLoadingSongs && !_isLoadingMoreSongs && _librarySongs.length < _totalSongsCount) {
          _loadMoreLibrarySongs();
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _libraryScrollController.dispose();
    super.dispose();
  }

  // ==========================================
  // MÉTODOS PESTAÑA USUARIOS
  // ==========================================
  Future<void> _fetchUsers() async {
    setState(() => _isLoadingUsers = true);
    final users = await _apiService.getAdminUsers();
    if (mounted) {
      setState(() {
        _users = users;
        _isLoadingUsers = false;
      });
    }
  }

  List<Map<String, dynamic>> get _filteredUsers {
    return _users.where((u) {
      final name = (u['name'] ?? '').toString().toLowerCase();
      final matchesSearch = _searchQuery.isEmpty || name.contains(_searchQuery.toLowerCase());
      if (!matchesSearch) return false;

      final isActive = u['is_active'] == true;
      if (_selectedFilter == 'active') return isActive;
      if (_selectedFilter == 'pending') return !isActive;
      return true;
    }).toList();
  }

  int get _pendingCount => _users.where((u) => u['is_active'] != true).length;
  int get _activeCount => _users.where((u) => u['is_active'] == true).length;

  Future<void> _openCreateUserDialog() async {
    final nameCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    bool isActive = true;
    bool isAdmin = false;
    bool obscurePass = true;

    final created = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: Row(
            children: [
              Icon(Icons.person_add_alt_1, color: _accentColor),
              const SizedBox(width: 10),
              const Expanded(
                child: Text('Crear nuevo usuario', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Nombre de usuario *',
                    labelStyle: const TextStyle(color: Color(0xFFA0A0A0)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF333333)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: _accentColor),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: passCtrl,
                  obscureText: obscurePass,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Contraseña (opcional)',
                    labelStyle: const TextStyle(color: Color(0xFFA0A0A0)),
                    suffixIcon: IconButton(
                      icon: Icon(obscurePass ? Icons.visibility_off : Icons.visibility, color: Colors.white54),
                      onPressed: () => setDialogState(() => obscurePass = !obscurePass),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF333333)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: _accentColor),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeColor: _accentColor,
                  title: const Text('Activar inmediatamente', style: TextStyle(color: Colors.white, fontSize: 14)),
                  subtitle: const Text('Si se desactiva, irá a sala de espera', style: TextStyle(color: Color(0xFFA0A0A0), fontSize: 12)),
                  value: isActive,
                  onChanged: (val) => setDialogState(() => isActive = val),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeColor: _accentColor,
                  title: const Text('Permisos de Administrador', style: TextStyle(color: Colors.white, fontSize: 14)),
                  subtitle: const Text('Tendrá acceso a este panel', style: TextStyle(color: Color(0xFFA0A0A0), fontSize: 12)),
                  value: isAdmin,
                  onChanged: (val) => setDialogState(() => isAdmin = val),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentColor,
                foregroundColor: Colors.black,
              ),
              onPressed: () async {
                final username = nameCtrl.text.trim();
                if (username.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Por favor ingresa un nombre de usuario')),
                  );
                  return;
                }
                Navigator.pop(ctx, true);
                _executeCreateUser(username, passCtrl.text.trim(), isActive, isAdmin);
              },
              child: const Text('Crear Usuario', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _executeCreateUser(String username, String password, bool isActive, bool isAdmin) async {
    _showLoadingDialog('Creando usuario...');
    final success = await _apiService.createAdminUser(
      username: username,
      password: password,
      isActive: isActive,
      isAdmin: isAdmin,
    );
    if (mounted) Navigator.pop(context);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario "$username" creado exitosamente.')),
      );
      _fetchUsers();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al crear el usuario. Verifica que no exista ya.')),
      );
    }
  }

  Future<void> _quickApproveUser(Map<String, dynamic> user) async {
    final userId = user['id'];
    final name = user['name'] ?? 'Usuario';
    _showLoadingDialog('Aprobando a $name...');
    final success = await _apiService.setAdminUserStatus(userId, true);
    if (mounted) Navigator.pop(context);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario "$name" activado correctamente.')),
      );
      _fetchUsers();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al activar el usuario.')),
      );
    }
  }

  // ==========================================
  // MÉTODOS PESTAÑA BIBLIOTECA GLOBAL
  // ==========================================
  Future<void> _fetchLibraryStats() async {
    setState(() => _isLoadingStats = true);
    final stats = await _apiService.getAdminLibraryStats();
    if (mounted) {
      setState(() {
        _libraryStats = stats;
        _isLoadingStats = false;
      });
    }
  }

  Future<void> _fetchLibrarySongs({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _isLoadingSongs = true;
        _librarySongs = [];
      });
    }
    final res = await _apiService.getAdminLibrarySongs(
      search: _songSearchQuery,
      sortBy: _songSortBy,
      limit: 30,
      startIndex: refresh ? 0 : _librarySongs.length,
    );
    if (mounted) {
      setState(() {
        _isLoadingSongs = false;
        _totalSongsCount = res['total_count'] ?? 0;
        final List<dynamic> raw = res['items'] ?? [];
        final items = raw.cast<Map<String, dynamic>>();
        if (refresh) {
          _librarySongs = items;
        } else {
          _librarySongs.addAll(items);
        }
      });
    }
  }

  Future<void> _loadMoreLibrarySongs() async {
    if (_isLoadingMoreSongs || _librarySongs.length >= _totalSongsCount) return;
    setState(() => _isLoadingMoreSongs = true);
    final res = await _apiService.getAdminLibrarySongs(
      search: _songSearchQuery,
      sortBy: _songSortBy,
      limit: 30,
      startIndex: _librarySongs.length,
    );
    if (mounted) {
      setState(() {
        _isLoadingMoreSongs = false;
        final List<dynamic> raw = res['items'] ?? [];
        _librarySongs.addAll(raw.cast<Map<String, dynamic>>());
      });
    }
  }

  Future<void> _triggerLibraryScan() async {
    setState(() => _isScanningLibrary = true);
    final success = await _apiService.triggerLibraryScan();
    setState(() => _isScanningLibrary = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Escaneo de biblioteca iniciado en segundo plano.' : 'Error al iniciar escaneo.'),
          backgroundColor: success ? Colors.green.shade800 : Colors.red.shade800,
        ),
      );
      if (success) {
        _fetchLibraryStats();
        _fetchLibrarySongs(refresh: true);
      }
    }
  }

  Future<void> _openEditSongModal(Map<String, dynamic> song) async {
    final titleCtrl = TextEditingController(text: song['name'] ?? '');
    final artistCtrl = TextEditingController(text: song['artist'] ?? '');
    final albumCtrl = TextEditingController(text: song['album'] ?? '');

    final updated = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Row(
          children: [
            Icon(Icons.edit_note, color: _accentColor, size: 28),
            const SizedBox(width: 8),
            const Expanded(
              child: Text('Editar Metadatos', style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: _accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _accentColor.withOpacity(0.25)),
                ),
                child: const Text(
                  'Los cambios se reescriben directamente en las etiquetas del archivo físico y se sincronizan con Jellyfin.',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
              TextField(
                controller: titleCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Título de la canción',
                  labelStyle: const TextStyle(color: Color(0xFFA0A0A0)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF333333)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: _accentColor),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: artistCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Artista',
                  labelStyle: const TextStyle(color: Color(0xFFA0A0A0)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF333333)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: _accentColor),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: albumCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Álbum',
                  labelStyle: const TextStyle(color: Color(0xFFA0A0A0)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF333333)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: _accentColor),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _accentColor, foregroundColor: Colors.black),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Guardar', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (updated != true) return;

    final songId = song['id'];
    _showLoadingDialog('Actualizando metadatos físicos...');
    final success = await _apiService.updateAdminSongMetadata(
      songId,
      title: titleCtrl.text.trim(),
      artist: artistCtrl.text.trim(),
      album: albumCtrl.text.trim(),
    );
    if (mounted) Navigator.pop(context);

    if (success) {
      setState(() {
        song['name'] = titleCtrl.text.trim();
        song['artist'] = artistCtrl.text.trim();
        song['album'] = albumCtrl.text.trim();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Metadatos guardados permanentemente.')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al actualizar los metadatos.')),
        );
      }
    }
  }

  Future<void> _openChangeCoverModal(Map<String, dynamic> song) async {
    final urlCtrl = TextEditingController();
    List<int>? pickedBytes;
    String? pickedFileName;

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: Row(
            children: [
              Icon(Icons.image, color: _accentColor, size: 28),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('Cambiar Carátula', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Canción: ${song['name']}',
                  style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 14),
                // Botón Galería
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _accentColor,
                    side: BorderSide(color: _accentColor),
                    minimumSize: const Size(double.infinity, 44),
                  ),
                  icon: const Icon(Icons.photo_library),
                  label: Text(pickedFileName != null ? 'Imagen: $pickedFileName' : 'Seleccionar desde Galería'),
                  onPressed: () async {
                    try {
                      final fileResult = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: false);
                      if (fileResult != null && fileResult.files.single.path != null) {
                        final f = File(fileResult.files.single.path!);
                        final bytes = await f.readAsBytes();
                        setDialogState(() {
                          pickedBytes = bytes;
                          pickedFileName = fileResult.files.single.name;
                          urlCtrl.clear();
                        });
                      }
                    } catch (e) {
                      print('Error seleccionando imagen: $e');
                    }
                  },
                ),
                const SizedBox(height: 14),
                const Center(child: Text('— O mediante enlace web —', style: TextStyle(color: Color(0xFF707070), fontSize: 12))),
                const SizedBox(height: 14),
                TextField(
                  controller: urlCtrl,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (val) {
                    if (val.isNotEmpty && pickedBytes != null) {
                      setDialogState(() {
                        pickedBytes = null;
                        pickedFileName = null;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'URL de la imagen (https://...)',
                    labelStyle: const TextStyle(color: Color(0xFFA0A0A0)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF333333)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: _accentColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: _accentColor, foregroundColor: Colors.black),
              onPressed: () {
                if (pickedBytes == null && urlCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Selecciona una imagen o ingresa una URL válida')),
                  );
                  return;
                }
                Navigator.pop(ctx, true);
              },
              child: const Text('Guardar Portada', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );

    if (result != true) return;

    final songId = song['id'];
    _showLoadingDialog('Incrustando portada en archivo...');
    bool success = false;
    if (pickedBytes != null) {
      success = await _apiService.updateAdminSongCoverBytes(songId, pickedBytes!);
    } else {
      success = await _apiService.updateAdminSongCoverUrl(songId, urlCtrl.text.trim());
    }
    if (mounted) Navigator.pop(context);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Portada actualizada e incrustada en el archivo físico.')),
        );
        _fetchLibrarySongs(refresh: true);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al actualizar la portada.')),
        );
      }
    }
  }

  Future<void> _openDeleteSongModal(Map<String, dynamic> song) async {
    final songName = song['name'] ?? 'Canción';
    final artistName = song['artist'] ?? 'Artista';
    final songId = song['id'];

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 26),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                '¿Eliminar del servidor?',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Estás a punto de eliminar "$songName" ($artistName).', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: const Text(
                'El archivo físico de audio (.mp3/.flac) será borrado permanentemente del disco duro del servidor.',
                style: TextStyle(color: Color(0xFFFFCDD2), fontSize: 13),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar del Servidor', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    _showLoadingDialog('Borrando archivo físico...');
    final success = await _apiService.deleteAdminSong(songId);
    if (mounted) Navigator.pop(context);

    if (success) {
      setState(() {
        _librarySongs.removeWhere((s) => s['id'] == songId);
        _totalSongsCount = (_totalSongsCount - 1).clamp(0, 999999);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Canción "$songName" eliminada del servidor.')),
        );
      }
      _fetchLibraryStats();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar la canción.')),
        );
      }
    }
  }

  void _showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: _accentColor),
              const SizedBox(height: 16),
              Text(message, style: const TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text('Panel de Administrador', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_fix_high, color: Color(0xFF8B93FF)),
            tooltip: 'Solicitudes de Metadatos',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const MetadataRequestsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Actualizar',
            onPressed: () {
              if (_tabController.index == 0) {
                _fetchUsers();
              } else if (_tabController.index == 1) {
                _fetchLibraryStats();
                _fetchLibrarySongs(refresh: true);
              }
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: _accentColor,
          indicatorWeight: 3,
          labelColor: _accentColor,
          unselectedLabelColor: const Color(0xFFA0A0A0),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: [
            Tab(
              icon: const Icon(Icons.people_alt_outlined),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Usuarios'),
                  if (_pendingCount > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$_pendingCount',
                        style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Tab(
              icon: Icon(Icons.public_outlined),
              text: 'Biblioteca global',
            ),
            const Tab(
              icon: Icon(Icons.speaker_outlined),
              text: 'Alexa',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // PESTAÑA 1: USUARIOS
          _buildUsersTab(),

          // PESTAÑA 2: BIBLIOTECA GLOBAL
          _buildGlobalLibraryTab(),

          // PESTAÑA 3: ALEXA
          _buildAlexaTab(),
        ],
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _tabController,
        builder: (context, _) {
          if (_tabController.index == 0) {
            return FloatingActionButton.extended(
              backgroundColor: _accentColor,
              foregroundColor: Colors.black,
              icon: const Icon(Icons.person_add),
              label: const Text('Crear Usuario', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: _openCreateUserDialog,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  // ==========================================
  // PESTAÑA 1: USUARIOS
  // ==========================================
  Widget _buildUsersTab() {
    return Column(
      children: [
        // Barra de búsqueda y filtros
        Container(
          color: const Color(0xFF141414),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            children: [
              TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Buscar usuario por nombre...',
                  hintStyle: const TextStyle(color: Color(0xFF707070), fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFFA0A0A0), size: 20),
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('Todos (${_users.length})', 'all'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Activos ($_activeCount)', 'active'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Pendientes ($_pendingCount)', 'pending', isWarning: _pendingCount > 0),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Lista de usuarios
        Expanded(
          child: _isLoadingUsers
              ? Center(child: CircularProgressIndicator(color: _accentColor))
              : _filteredUsers.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_off_outlined, size: 64, color: Colors.white.withOpacity(0.2)),
                          const SizedBox(height: 12),
                          Text(
                            _searchQuery.isNotEmpty
                                ? 'No se encontraron usuarios con "$_searchQuery"'
                                : 'No hay usuarios en esta categoría.',
                            style: const TextStyle(color: Color(0xFFA0A0A0), fontSize: 15),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 80),
                      itemCount: _filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = _filteredUsers[index];
                        final userId = user['id'];
                        final name = user['name'] ?? 'Usuario';
                        final isActive = user['is_active'] == true;
                        final isAdmin = user['is_admin'] == true;
                        final imageTag = user['primary_image_tag'];
                        final isSelf = userId == _currentAdminId;

                        final avatarUrl = (imageTag != null && imageTag.toString().isNotEmpty)
                            ? '$_serverUrl/Users/$userId/Images/Primary?tag=$imageTag'
                            : '$_serverUrl/Users/$userId/Images/Primary';

                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                          color: const Color(0xFF161616),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: isSelf ? _accentColor.withOpacity(0.4) : const Color(0xFF262626),
                              width: 1,
                            ),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () async {
                              final changed = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AdminUserDetailScreen(
                                    userId: userId,
                                    initialName: name,
                                    initialIsActive: isActive,
                                    initialIsAdmin: isAdmin,
                                    initialImageTag: imageTag,
                                  ),
                                ),
                              );
                              if (changed == true || mounted) {
                                _fetchUsers();
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              child: Row(
                                children: [
                                  // Avatar
                                  Container(
                                    width: 46,
                                    height: 46,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isActive ? Colors.green : Colors.orangeAccent,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: avatarUrl,
                                        fit: BoxFit.cover,
                                        placeholder: (_, __) => Container(
                                          color: const Color(0xFF222222),
                                          child: const Icon(Icons.person, size: 24, color: Colors.white54),
                                        ),
                                        errorWidget: (_, __, ___) => Container(
                                          color: _accentColor.withOpacity(0.2),
                                          child: Center(
                                            child: Text(
                                              name.isNotEmpty ? name[0].toUpperCase() : 'U',
                                              style: TextStyle(color: _accentColor, fontWeight: FontWeight.bold, fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),

                                  // Datos del usuario
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                name,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (isAdmin) ...[
                                              const SizedBox(width: 6),
                                              Icon(Icons.shield, color: _accentColor, size: 16),
                                            ],
                                            if (isSelf) ...[
                                              const SizedBox(width: 6),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                                decoration: BoxDecoration(
                                                  color: _accentColor.withOpacity(0.2),
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  'Tú',
                                                  style: TextStyle(color: _accentColor, fontSize: 10, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: isActive ? Colors.greenAccent : Colors.orangeAccent,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              isActive ? 'Activo' : 'Inactivo / En espera',
                                              style: TextStyle(
                                                color: isActive ? const Color(0xFFA0A0A0) : Colors.orangeAccent,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Acciones rápidas / trailing
                                  if (!isActive)
                                    IconButton(
                                      icon: const Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 26),
                                      tooltip: 'Aprobar acceso',
                                      onPressed: () => _quickApproveUser(user),
                                    )
                                  else
                                    const Icon(Icons.chevron_right, color: Color(0xFF606060)),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, String value, {bool isWarning = false}) {
    final isSelected = _selectedFilter == value;
    return InkWell(
      onTap: () => setState(() => _selectedFilter = value),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? (isWarning ? Colors.orangeAccent.withOpacity(0.2) : _accentColor.withOpacity(0.2))
              : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (isWarning ? Colors.orangeAccent : _accentColor)
                : const Color(0xFF333333),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? (isWarning ? Colors.orangeAccent : _accentColor)
                : const Color(0xFFA0A0A0),
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // ==========================================
  // PESTAÑA 2: BIBLIOTECA GLOBAL
  // ==========================================
  Widget _buildGlobalLibraryTab() {
    return RefreshIndicator(
      color: _accentColor,
      onRefresh: () async {
        await _fetchLibraryStats();
        await _fetchLibrarySongs(refresh: true);
      },
      child: CustomScrollView(
        controller: _libraryScrollController,
        slivers: [
          // 1. Tarjetas de métricas del servidor
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 16, 14, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.dns, color: _accentColor, size: 20),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Estado del Servidor',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _accentColor,
                          side: BorderSide(color: _accentColor.withOpacity(0.5)),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: _isScanningLibrary
                            ? const SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.sync, size: 14),
                        label: Text(_isScanningLibrary ? 'Escaneando...' : 'Escanear', style: const TextStyle(fontSize: 12)),
                        onPressed: _isScanningLibrary ? null : _triggerLibraryScan,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Grid de estadísticas
                  _isLoadingStats
                      ? Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: const Color(0xFF161616),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(child: CircularProgressIndicator(color: _accentColor)),
                        )
                      : GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 2.1,
                          children: [
                            _buildLibStatCard(
                              'Canciones en Catálogo',
                              '${_libraryStats?['total_songs'] ?? 0}',
                              Icons.music_note,
                              Colors.purpleAccent,
                            ),
                            _buildLibStatCard(
                              'Tiempo Total de Música',
                              _libraryStats?['total_duration_formatted'] ?? '0h',
                              Icons.timelapse,
                              Colors.amberAccent,
                            ),
                            _buildLibStatCard(
                              'Espacio en Disco (Música)',
                              '${_libraryStats?['media_folder_formatted'] ?? '0 GB'} / ${_libraryStats?['disk_total_formatted'] ?? '0 GB'}',
                              Icons.storage,
                              Colors.cyanAccent,
                            ),
                            _buildLibStatCard(
                              'Reproducciones Totales',
                              '${_libraryStats?['total_playbacks'] ?? 0}',
                              Icons.headphones,
                              Colors.greenAccent,
                            ),
                          ],
                        ),

                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFF262626)),
                  const SizedBox(height: 8),

                  // Barra de búsqueda y selector de ordenamiento
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onSubmitted: (val) {
                            setState(() => _songSearchQuery = val);
                            _fetchLibrarySongs(refresh: true);
                          },
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Buscar título, artista o álbum...',
                            hintStyle: const TextStyle(color: Color(0xFF707070), fontSize: 13),
                            prefixIcon: const Icon(Icons.search, color: Color(0xFFA0A0A0), size: 18),
                            suffixIcon: _songSearchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 16, color: Colors.white54),
                                    onPressed: () {
                                      setState(() => _songSearchQuery = '');
                                      _fetchLibrarySongs(refresh: true);
                                    },
                                  )
                                : null,
                            filled: true,
                            fillColor: const Color(0xFF161616),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color(0xFF262626)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color(0xFF262626)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Dropdown de ordenamiento
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF161616),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF262626)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _songSortBy,
                            dropdownColor: const Color(0xFF1E1E1E),
                            icon: const Icon(Icons.sort, color: Color(0xFF8B93FF), size: 20),
                            items: const [
                              DropdownMenuItem(value: 'date_added', child: Text('Recientes', style: TextStyle(color: Colors.white, fontSize: 12))),
                              DropdownMenuItem(value: 'title', child: Text('Título (A-Z)', style: TextStyle(color: Colors.white, fontSize: 12))),
                              DropdownMenuItem(value: 'artist', child: Text('Artista (A-Z)', style: TextStyle(color: Colors.white, fontSize: 12))),
                              DropdownMenuItem(value: 'duration_desc', child: Text('⏱️ Mayor duración', style: TextStyle(color: Colors.white, fontSize: 12))),
                              DropdownMenuItem(value: 'duration_asc', child: Text('⏱️ Menor duración', style: TextStyle(color: Colors.white, fontSize: 12))),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _songSortBy = val);
                                _fetchLibrarySongs(refresh: true);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Mostrando ${_librarySongs.length} de $_totalSongsCount canciones',
                    style: const TextStyle(color: Color(0xFFA0A0A0), fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          // 2. Lista de canciones
          if (_isLoadingSongs)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: Color(0xFF8B93FF))),
            )
          else if (_librarySongs.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.music_off_outlined, size: 54, color: Colors.white.withOpacity(0.2)),
                    const SizedBox(height: 12),
                    Text(
                      _songSearchQuery.isNotEmpty
                          ? 'No se encontraron canciones con "$_songSearchQuery"'
                          : 'No hay canciones en la biblioteca.',
                      style: const TextStyle(color: Color(0xFFA0A0A0)),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == _librarySongs.length) {
                    return _isLoadingMoreSongs
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator(color: Color(0xFF8B93FF), strokeWidth: 2)),
                          )
                        : const SizedBox(height: 80);
                  }

                  final song = _librarySongs[index];
                  final songId = song['id'];
                  final title = song['name'] ?? 'Desconocido';
                  final artist = song['artist'] ?? 'Artista desconocido';
                  final album = song['album'] ?? '';
                  final duration = song['duration_formatted'] ?? '0:00';
                  final imageTag = song['primary_image_tag'];

                  final coverUrl = (imageTag != null && imageTag.toString().isNotEmpty)
                      ? '$_serverUrl/Items/$songId/Images/Primary?tag=$imageTag'
                      : '$_serverUrl/Items/$songId/Images/Primary';

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    color: const Color(0xFF161616),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Color(0xFF262626)),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: CachedNetworkImage(
                          imageUrl: coverUrl,
                          width: 46,
                          height: 46,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            color: const Color(0xFF262626),
                            child: const Icon(Icons.music_note, color: Colors.white24, size: 22),
                          ),
                          errorWidget: (_, __, ___) => Container(
                            color: const Color(0xFF262626),
                            child: const Icon(Icons.music_note, color: Colors.white24, size: 22),
                          ),
                        ),
                      ),
                      title: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      subtitle: Text(
                        album.isNotEmpty ? '$artist • $album' : artist,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Color(0xFFA0A0A0), fontSize: 12),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF262626),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              duration,
                              style: const TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'monospace'),
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert, color: Colors.white70, size: 20),
                            color: const Color(0xFF222222),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            onSelected: (val) {
                              if (val == 'edit') {
                                _openEditSongModal(song);
                              } else if (val == 'cover') {
                                _openChangeCoverModal(song);
                              } else if (val == 'delete') {
                                _openDeleteSongModal(song);
                              }
                            },
                            itemBuilder: (ctx) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit_note, color: Color(0xFF8B93FF), size: 18),
                                    SizedBox(width: 10),
                                    Text('Editar metadatos', style: TextStyle(color: Colors.white, fontSize: 13)),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'cover',
                                child: Row(
                                  children: [
                                    Icon(Icons.image_outlined, color: Colors.cyanAccent, size: 18),
                                    SizedBox(width: 10),
                                    Text('Cambiar carátula', style: TextStyle(color: Colors.white, fontSize: 13)),
                                  ],
                                ),
                              ),
                              const PopupMenuDivider(height: 1),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete_forever, color: Colors.redAccent, size: 18),
                                    SizedBox(width: 10),
                                    Text('Eliminar del servidor', style: TextStyle(color: Colors.redAccent, fontSize: 13)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: _librarySongs.length + 1,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLibStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF262626)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color.withOpacity(0.14),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SynapMarqueeText(
                  text: value,
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  velocity: 30.0,
                  pauseDuration: const Duration(seconds: 2),
                ),
                const SizedBox(height: 2),
                SynapMarqueeText(
                  text: label,
                  style: const TextStyle(color: Color(0xFFA0A0A0), fontSize: 10),
                  velocity: 25.0,
                  pauseDuration: const Duration(seconds: 3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // PESTAÑA 3: ALEXA (PRÓXIMAMENTE)
  // ==========================================
  Widget _buildAlexaTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.cyanAccent.withOpacity(0.12),
              ),
              child: const Icon(Icons.speaker_outlined, size: 64, color: Colors.cyanAccent),
            ),
            const SizedBox(height: 20),
            const Text(
              'Integración con Alexa',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Configuración y vinculación de comandos de voz para reproducir tus playlists y canciones en Amazon Echo.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFFA0A0A0), fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF161616),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF2A2A2A)),
              ),
              child: Column(
                children: const [
                  _FeatureBullet(icon: Icons.vpn_key, text: 'Gestión de tokens de autenticación de skill'),
                  SizedBox(height: 10),
                  _FeatureBullet(icon: Icons.multitrack_audio, text: 'Endpoints de streaming de baja latencia para Alexa'),
                  SizedBox(height: 10),
                  _FeatureBullet(icon: Icons.devices, text: 'Dispositivos Alexa enlazados'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureBullet extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureBullet({Key? key, required this.icon, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF8B93FF)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ),
      ],
    );
  }
}

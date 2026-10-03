import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get_it/get_it.dart';
import '../../services/finamp_user_helper.dart';
import '../../services/synap_api_service.dart';

class AdminUserDetailScreen extends StatefulWidget {
  final String userId;
  final String initialName;
  final bool initialIsActive;
  final bool initialIsAdmin;
  final String? initialImageTag;

  const AdminUserDetailScreen({
    Key? key,
    required this.userId,
    required this.initialName,
    required this.initialIsActive,
    required this.initialIsAdmin,
    this.initialImageTag,
  }) : super(key: key);

  @override
  State<AdminUserDetailScreen> createState() => _AdminUserDetailScreenState();
}

class _AdminUserDetailScreenState extends State<AdminUserDetailScreen> {
  final SynapApiService _apiService = SynapApiService();
  final Color _accentColor = const Color(0xFF8B93FF);

  bool _isLoading = true;
  Map<String, dynamic>? _details;
  late String _currentName;
  late bool _currentIsActive;
  late bool _currentIsAdmin;
  String? _currentImageTag;
  String _currentAdminId = '';
  String _serverUrl = 'http://100.64.134.104:8096';

  @override
  void initState() {
    super.initState();
    _currentName = widget.initialName;
    _currentIsActive = widget.initialIsActive;
    _currentIsAdmin = widget.initialIsAdmin;
    _currentImageTag = widget.initialImageTag;

    try {
      final userHelper = GetIt.instance<FinampUserHelper>();
      _currentAdminId = userHelper.currentUser?.id ?? '';
      _serverUrl = userHelper.currentUser?.baseUrl ?? 'http://100.64.134.104:8096';
    } catch (_) {}

    _loadUserDetails();
  }

  bool get _isSelf => _currentAdminId.isNotEmpty && _currentAdminId == widget.userId;

  Future<void> _loadUserDetails() async {
    setState(() => _isLoading = true);
    final data = await _apiService.getAdminUserDetails(widget.userId);
    if (mounted) {
      setState(() {
        _isLoading = false;
        if (data != null) {
          _details = data;
          _currentName = data['name'] ?? _currentName;
          _currentIsActive = data['is_active'] ?? _currentIsActive;
          _currentIsAdmin = data['is_admin'] ?? _currentIsAdmin;
          _currentImageTag = data['primary_image_tag'] ?? _currentImageTag;
        }
      });
    }
  }

  String _formatDate(dynamic dateStr) {
    if (dateStr == null || dateStr.toString().trim().isEmpty) return 'No registrada';
    try {
      final dt = DateTime.parse(dateStr.toString()).toLocal();
      final day = dt.day.toString().padLeft(2, '0');
      final month = dt.month.toString().padLeft(2, '0');
      final year = dt.year;
      final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final min = dt.minute.toString().padLeft(2, '0');
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      return '$day/$month/$year $hour:$min $ampm';
    } catch (_) {
      return dateStr.toString();
    }
  }

  Future<void> _toggleUserStatus() async {
    if (_isSelf) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No puedes desactivar tu propia cuenta de administrador.')),
      );
      return;
    }

    final newStatus = !_currentIsActive;
    final actionText = newStatus ? 'activar' : 'desactivar';

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text('¿Deseas $actionText a $_currentName?', style: const TextStyle(color: Colors.white)),
        content: Text(
          newStatus
              ? 'El usuario podrá iniciar sesión normalmente en la aplicación.'
              : 'El usuario no podrá ingresar a la aplicación hasta que sea activado nuevamente.',
          style: const TextStyle(color: Color(0xFFA0A0A0)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: newStatus ? Colors.green : Colors.orangeAccent,
              foregroundColor: Colors.black,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(newStatus ? 'Activar' : 'Desactivar', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    _showLoadingDialog('Actualizando estado...');
    final success = await _apiService.setAdminUserStatus(widget.userId, newStatus);
    if (mounted) Navigator.pop(context); // Cerrar loading

    if (success) {
      setState(() => _currentIsActive = newStatus);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario ${_currentName} ${newStatus ? 'activado' : 'desactivado'} con éxito.')),
      );
      _loadUserDetails();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cambiar el estado del usuario.')),
      );
    }
  }

  Future<void> _toggleAdminRole() async {
    if (_isSelf) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No puedes quitarte tus propios permisos de administrador.')),
      );
      return;
    }

    final newAdmin = !_currentIsAdmin;
    final actionText = newAdmin ? 'otorgar permisos de Administrador a' : 'quitar permisos de Administrador a';

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text('¿Deseas $actionText $_currentName?', style: const TextStyle(color: Colors.white)),
        content: Text(
          newAdmin
              ? 'Tendrá acceso al panel de administración y control total de usuarios.'
              : 'El usuario volverá a ser un miembro estándar de SynapMusic.',
          style: const TextStyle(color: Color(0xFFA0A0A0)),
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
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(newAdmin ? 'Hacer Admin' : 'Quitar Admin', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    _showLoadingDialog('Actualizando permisos...');
    final success = await _apiService.setAdminUserRole(widget.userId, newAdmin);
    if (mounted) Navigator.pop(context); // Cerrar loading

    if (success) {
      setState(() => _currentIsAdmin = newAdmin);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rol de ${_currentName} actualizado correctamente.')),
      );
      _loadUserDetails();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar el rol del usuario.')),
      );
    }
  }

  Future<void> _changePassword() async {
    final controller = TextEditingController();
    bool obscure = true;

    final newPassword = await showDialog<String>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: Text('Restablecer contraseña de $_currentName', style: const TextStyle(color: Colors.white, fontSize: 18)),
          content: TextField(
            controller: controller,
            obscureText: obscure,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Nueva contraseña',
              labelStyle: const TextStyle(color: Color(0xFFA0A0A0)),
              suffixIcon: IconButton(
                icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: Colors.white54),
                onPressed: () => setDialogState(() => obscure = !obscure),
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
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, null),
              child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentColor,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                final pw = controller.text.trim();
                if (pw.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Por favor ingresa una contraseña')),
                  );
                  return;
                }
                Navigator.pop(ctx, pw);
              },
              child: const Text('Guardar', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );

    if (newPassword == null || newPassword.isEmpty) return;

    _showLoadingDialog('Actualizando contraseña...');
    final success = await _apiService.setAdminUserPassword(widget.userId, newPassword);
    if (mounted) Navigator.pop(context); // Cerrar loading

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contraseña restablecida exitosamente.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cambiar la contraseña del usuario.')),
      );
    }
  }

  Future<void> _editUserName() async {
    final controller = TextEditingController(text: _currentName);

    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Editar nombre de usuario', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Nombre',
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
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, null),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _accentColor,
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              final n = controller.text.trim();
              if (n.isNotEmpty) Navigator.pop(ctx, n);
            },
            child: const Text('Guardar', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (newName == null || newName.isEmpty || newName == _currentName) return;

    _showLoadingDialog('Actualizando nombre...');
    final success = await _apiService.updateAdminUserName(widget.userId, newName);
    if (mounted) Navigator.pop(context); // Cerrar loading

    if (success) {
      setState(() => _currentName = newName);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nombre de usuario actualizado.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar el nombre.')),
      );
    }
  }

  Future<void> _deleteUser() async {
    if (_isSelf) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No puedes eliminar tu propia cuenta de administrador.')),
      );
      return;
    }

    // Paso 1: Primer diálogo de advertencia
    final firstConfirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 28),
            SizedBox(width: 8),
            Expanded(
              child: Text('¿Eliminar usuario?', style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estás a punto de eliminar permanentemente la cuenta de "$_currentName".',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Las canciones descargadas en el servidor PERMANECERÁN INTACTAS para enriquecer la biblioteca común.',
                      style: TextStyle(color: Color(0xFFC8E6C9), fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Se borrarán sus listas de reproducción, favoritos y perfil de Jellyfin.',
              style: TextStyle(color: Color(0xFFA0A0A0), fontSize: 13),
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
            child: const Text('Continuar', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (firstConfirm != true) return;

    // Paso 2: Doble confirmación pidiendo confirmación explícita
    final confirmController = TextEditingController();
    final secondConfirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          final isMatch = confirmController.text.trim().toLowerCase() == _currentName.trim().toLowerCase();
          return AlertDialog(
            backgroundColor: const Color(0xFF1E1E1E),
            title: const Text('Confirmación final requerida', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Para confirmar la eliminación, escribe exactamente el nombre del usuario: "$_currentName"',
                  style: const TextStyle(color: Color(0xFFA0A0A0), fontSize: 14),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: confirmController,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (_) => setDialogState(() {}),
                  decoration: InputDecoration(
                    hintText: _currentName,
                    hintStyle: const TextStyle(color: Colors.white30),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF444444)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.redAccent),
                    ),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: isMatch ? Colors.red : Colors.grey.shade800,
                  foregroundColor: Colors.white,
                ),
                onPressed: isMatch ? () => Navigator.pop(ctx, true) : null,
                child: const Text('Eliminar definitivamente', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );

    if (secondConfirm != true) return;

    _showLoadingDialog('Eliminando usuario...');
    final success = await _apiService.deleteAdminUser(widget.userId);
    if (mounted) Navigator.pop(context); // Cerrar loading

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario "$_currentName" eliminado correctamente.')),
        );
        Navigator.pop(context, true); // Regresar al dashboard indicando cambio
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar el usuario.')),
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
    final avatarUrl = (_currentImageTag != null && _currentImageTag!.isNotEmpty)
        ? '$_serverUrl/Users/${widget.userId}/Images/Primary?tag=$_currentImageTag'
        : '$_serverUrl/Users/${widget.userId}/Images/Primary';

    final playlists = (_details?['playlists'] as List<dynamic>?) ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: const Text('Detalle de Usuario', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Actualizar',
            onPressed: _loadUserDetails,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: _accentColor))
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              children: [
                // ==========================================
                // CABECERA / PERFIL
                // ==========================================
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: _currentIsActive ? _accentColor : Colors.grey, width: 2.5),
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: avatarUrl,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              color: const Color(0xFF222222),
                              child: const Icon(Icons.person, size: 50, color: Colors.white54),
                            ),
                            errorWidget: (_, __, ___) => Container(
                              color: _accentColor.withOpacity(0.2),
                              child: Center(
                                child: Text(
                                  _currentName.isNotEmpty ? _currentName[0].toUpperCase() : 'U',
                                  style: TextStyle(color: _accentColor, fontSize: 36, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              _currentName,
                              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, size: 18, color: Color(0xFFA0A0A0)),
                            tooltip: 'Editar nombre',
                            onPressed: _editUserName,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          // Badge de Estado
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _currentIsActive
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _currentIsActive ? Colors.green : Colors.orange,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _currentIsActive ? Icons.check_circle : Icons.pause_circle_filled,
                                  color: _currentIsActive ? Colors.greenAccent : Colors.orangeAccent,
                                  size: 14,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _currentIsActive ? 'Activo' : 'Inactivo / En espera',
                                  style: TextStyle(
                                    color: _currentIsActive ? Colors.greenAccent : Colors.orangeAccent,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Badge de Rol
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _currentIsAdmin
                                  ? _accentColor.withOpacity(0.2)
                                  : const Color(0xFF2A2A2A),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _currentIsAdmin ? _accentColor : const Color(0xFF444444),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _currentIsAdmin ? Icons.shield : Icons.person_outline,
                                  color: _currentIsAdmin ? _accentColor : Colors.white70,
                                  size: 14,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _currentIsAdmin ? 'Administrador' : 'Miembro',
                                  style: TextStyle(
                                    color: _currentIsAdmin ? _accentColor : Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Advertencia si es la propia cuenta
                if (_isSelf) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: _accentColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _accentColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: _accentColor, size: 22),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'Esta es tu cuenta de administrador en sesión. Las opciones de desactivación y eliminación están deshabilitadas.',
                            style: TextStyle(color: Colors.white70, fontSize: 12.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // ==========================================
                // INFORMACIÓN DE LA CUENTA
                // ==========================================
                _buildSectionTitle('Información de la Cuenta'),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161616),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF262626)),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow('ID de Jellyfin', widget.userId, isMonospace: true),
                      const Divider(color: Color(0xFF262626), height: 24),
                      _buildInfoRow('Fecha de creación', _formatDate(_details?['created_at'])),
                      const Divider(color: Color(0xFF262626), height: 24),
                      _buildInfoRow('Último inicio de sesión', _formatDate(_details?['last_login_date'])),
                      const Divider(color: Color(0xFF262626), height: 24),
                      _buildInfoRow('Última actividad', _formatDate(_details?['last_activity_date'])),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ==========================================
                // MÉTRICAS DE BIBLIOTECA
                // ==========================================
                _buildSectionTitle('Métricas de Biblioteca'),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.1,
                  children: [
                    _buildStatCard('Canciones en Likes', '${_details?['likes_count'] ?? 0}', Icons.favorite, Colors.redAccent),
                    _buildStatCard('Playlists Creadas', '${_details?['playlists_count'] ?? 0}', Icons.queue_music, Colors.cyanAccent),
                    _buildStatCard('Álbumes Favoritos', '${_details?['favorite_albums_count'] ?? 0}', Icons.album, Colors.amberAccent),
                    _buildStatCard('Artistas Favoritos', '${_details?['favorite_artists_count'] ?? 0}', Icons.mic, Colors.purpleAccent),
                  ],
                ),

                const SizedBox(height: 16),

                // ==========================================
                // PLAYLISTS DEL USUARIO
                // ==========================================
                _buildSectionTitle('Playlists del Usuario'),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161616),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF262626)),
                  ),
                  child: playlists.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: Text(
                              'El usuario no ha creado playlists personales aún.',
                              style: TextStyle(color: Color(0xFFA0A0A0), fontSize: 13),
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: playlists.length,
                          separatorBuilder: (_, __) => const Divider(color: Color(0xFF262626), height: 16),
                          itemBuilder: (context, index) {
                            final pl = playlists[index];
                            final plName = pl['name'] ?? 'Playlist';
                            final count = pl['song_count'] ?? 0;
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF262626),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(Icons.playlist_play, color: Colors.white70),
                              ),
                              title: Text(plName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                              subtitle: Text('$count canciones', style: const TextStyle(color: Color(0xFFA0A0A0), fontSize: 12)),
                            );
                          },
                        ),
                ),

                const SizedBox(height: 28),

                // ==========================================
                // ACCIONES DE ADMINISTRADOR
                // ==========================================
                _buildSectionTitle('Acciones de Administrador'),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161616),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF262626)),
                  ),
                  child: Column(
                    children: [
                      // Botón Activar / Desactivar
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          _currentIsActive ? Icons.pause_circle_outline : Icons.play_circle_outline,
                          color: _currentIsActive ? Colors.orangeAccent : Colors.greenAccent,
                          size: 28,
                        ),
                        title: Text(
                          _currentIsActive ? 'Desactivar usuario' : 'Activar / Aprobar usuario',
                          style: TextStyle(
                            color: _isSelf ? Colors.white38 : Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          _currentIsActive ? 'Impedir el acceso a la aplicación' : 'Permitir inicio de sesión inmediato',
                          style: const TextStyle(color: Color(0xFFA0A0A0), fontSize: 12),
                        ),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _currentIsActive ? Colors.orange.withOpacity(0.2) : Colors.green.withOpacity(0.2),
                            foregroundColor: _currentIsActive ? Colors.orangeAccent : Colors.greenAccent,
                            side: BorderSide(color: _currentIsActive ? Colors.orangeAccent : Colors.greenAccent),
                          ),
                          onPressed: _isSelf ? null : _toggleUserStatus,
                          child: Text(_currentIsActive ? 'Desactivar' : 'Activar'),
                        ),
                      ),
                      const Divider(color: Color(0xFF262626), height: 24),

                      // Botón Rol Administrador
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.shield_outlined, color: _accentColor, size: 28),
                        title: Text(
                          _currentIsAdmin ? 'Quitar rol de Administrador' : 'Hacer Administrador',
                          style: TextStyle(
                            color: _isSelf ? Colors.white38 : Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          _currentIsAdmin ? 'Convertir en miembro regular' : 'Dar control total del sistema',
                          style: const TextStyle(color: Color(0xFFA0A0A0), fontSize: 12),
                        ),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _accentColor.withOpacity(0.2),
                            foregroundColor: _accentColor,
                            side: BorderSide(color: _accentColor),
                          ),
                          onPressed: _isSelf ? null : _toggleAdminRole,
                          child: Text(_currentIsAdmin ? 'Quitar Admin' : 'Hacer Admin'),
                        ),
                      ),
                      const Divider(color: Color(0xFF262626), height: 24),

                      // Botón Restablecer Contraseña
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.lock_reset, color: Colors.blueAccent, size: 28),
                        title: const Text('Restablecer contraseña', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        subtitle: const Text('Establecer una nueva clave para este usuario', style: TextStyle(color: Color(0xFFA0A0A0), fontSize: 12)),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent.withOpacity(0.2),
                            foregroundColor: Colors.blueAccent,
                            side: const BorderSide(color: Colors.blueAccent),
                          ),
                          onPressed: _changePassword,
                          child: const Text('Cambiar'),
                        ),
                      ),
                      const Divider(color: Color(0xFF262626), height: 24),

                      // Botón Eliminar Usuario
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.delete_forever, color: Colors.redAccent, size: 28),
                        title: Text(
                          'Eliminar cuenta',
                          style: TextStyle(
                            color: _isSelf ? Colors.white38 : Colors.redAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: const Text(
                          'Borra el perfil y playlists (la música del servidor se conserva)',
                          style: TextStyle(color: Color(0xFFA0A0A0), fontSize: 12),
                        ),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.withOpacity(0.2),
                            foregroundColor: Colors.redAccent,
                            side: const BorderSide(color: Colors.redAccent),
                          ),
                          onPressed: _isSelf ? null : _deleteUser,
                          child: const Text('Eliminar'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isMonospace = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFFA0A0A0), fontSize: 13)),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontFamily: isMonospace ? 'monospace' : null,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF262626)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Text(
                  label,
                  style: const TextStyle(color: Color(0xFFA0A0A0), fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

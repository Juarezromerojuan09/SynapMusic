import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/jellyfin_models.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/downloads_helper.dart';
import 'crop_cover_screen.dart';

class EditPlaylistScreen extends StatefulWidget {
  final BaseItemDto playlist;

  const EditPlaylistScreen({Key? key, required this.playlist}) : super(key: key);

  @override
  _EditPlaylistScreenState createState() => _EditPlaylistScreenState();
}

class _EditPlaylistScreenState extends State<EditPlaylistScreen> with SingleTickerProviderStateMixin {
  late final TextEditingController _nameController;
  late final TabController _tabController;
  final GlobalKey _previewKey = GlobalKey();

  File? _selectedImageFile;
  int _selectedPresetIndex = -1;
  bool _isSaving = false;

  final List<List<Color>> _presets = [
    [const Color(0xFF8B93FF), const Color(0xFF5755FE)],
    [const Color(0xFFFF5E7E), const Color(0xFFFF9966)],
    [const Color(0xFF00F2FE), const Color(0xFF4FACFE)],
    [const Color(0xFF43E97B), const Color(0xFF38F9D7)],
    [const Color(0xFFFA709A), const Color(0xFFFEE140)],
    [const Color(0xFF30CFD0), const Color(0xFF330867)],
    [const Color(0xFFB39DDB), const Color(0xFF512DA8)],
    [const Color(0xFF2C3E50), const Color(0xFF000000)],
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.playlist.name ?? '');
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromDevice() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final originalFile = File(result.files.single.path!);
        await _reopenCropEditor(originalFile);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar imagen: $e')),
      );
    }
  }

  Future<void> _reopenCropEditor(File originalFile) async {
    final croppedFile = await Navigator.of(context).push<File>(
      MaterialPageRoute(
        builder: (_) => CropCoverScreen(imageFile: originalFile),
      ),
    );

    if (croppedFile != null && mounted) {
      setState(() {
        _selectedImageFile = croppedFile;
        _selectedPresetIndex = -1;
      });
    }
  }

  Future<Uint8List?> _captureBoundaryToPng() async {
    try {
      final boundary = _previewKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;
      final image = await boundary.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print('Error al capturar boundary a PNG: $e');
      return null;
    }
  }

  Future<void> _saveChanges() async {
    final newName = _nameController.text.trim();
    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre de la playlist no puede estar vacío.')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final jellyfinHelper = GetIt.instance<JellyfinApiHelper>();

      // 1. Actualizar nombre si cambió
      if (newName != widget.playlist.name) {
        final updated = BaseItemDto.fromJson(widget.playlist.toJson());
        updated.name = newName;
        await jellyfinHelper.updateItem(
          itemId: widget.playlist.id!,
          newItem: updated,
        );
      }

      // 2. Actualizar imagen si se seleccionó una
      Uint8List? imageBytes;
      if (_selectedImageFile != null) {
        imageBytes = await _selectedImageFile!.readAsBytes();
      } else if (_selectedPresetIndex >= 0) {
        imageBytes = await _captureBoundaryToPng();
      }

      if (imageBytes != null) {
        await jellyfinHelper.updateItemImage(
          itemId: widget.playlist.id,
          imageBytes: imageBytes,
          mimeType: 'image/png',
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Playlist actualizada correctamente.')),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar cambios: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Widget _buildLivePreview() {
    Widget coverWidget;

    if (_selectedImageFile != null) {
      coverWidget = Image.file(_selectedImageFile!, fit: BoxFit.cover);
    } else if (_selectedPresetIndex >= 0) {
      final colors = _presets[_selectedPresetIndex];
      coverWidget = Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Icon(Icons.music_note, color: Colors.white, size: 64),
        ),
      );
    } else {
      final downloadsHelper = GetIt.instance<DownloadsHelper>();
      final downloadedImage = downloadsHelper.getDownloadedImage(widget.playlist);
      final uri = downloadedImage?.file.uri ?? GetIt.instance<JellyfinApiHelper>().getImageUrl(item: widget.playlist);

      if (uri != null) {
        coverWidget = Image.network(
          uri.toString(),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: const Color(0xFF1E1E1E),
            child: const Icon(Icons.queue_music, color: Colors.white54, size: 56),
          ),
        );
      } else {
        coverWidget = Container(
          color: const Color(0xFF1E1E1E),
          child: const Icon(Icons.queue_music, color: Colors.white54, size: 56),
        );
      }
    }

    return Column(
      children: [
        Center(
          child: RepaintBoundary(
            key: _previewKey,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: coverWidget,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (_selectedImageFile != null)
          TextButton.icon(
            icon: const Icon(Icons.crop, size: 18),
            label: const Text('Re-recortar imagen'),
            onPressed: () => _reopenCropEditor(_selectedImageFile!),
          ),
      ],
    );
  }

  Widget _buildDevicePickerTab() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF161616),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              children: [
                const Icon(Icons.add_photo_alternate_outlined, size: 64, color: Color(0xFF8B93FF)),
                const SizedBox(height: 16),
                const Text(
                  'Elige una foto de tu biblioteca',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Podrás recortarla y centrarla perfectamente antes de guardarla.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B93FF),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Elegir de la Galería', style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: _pickImageFromDevice,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetGrid() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        itemCount: _presets.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          final isSelected = _selectedPresetIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedPresetIndex = index;
                _selectedImageFile = null;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _presets[index],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(color: Colors.white, width: 3.0)
                    : Border.all(color: Colors.white24, width: 1.0),
              ),
              child: isSelected
                  ? const Center(child: Icon(Icons.check, color: Colors.white, size: 28))
                  : null,
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
        backgroundColor: const Color(0xFF0A0A0A),
        title: const Text('Modificar playlist'),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveChanges,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF8B93FF)),
                  )
                : const Text(
                    'Guardar',
                    style: TextStyle(color: Color(0xFF8B93FF), fontWeight: FontWeight.bold, fontSize: 16),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            _buildLivePreview(),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _nameController,
                style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  labelText: 'Nombre de la lista de reproducción',
                  labelStyle: const TextStyle(color: Color(0xFF8B93FF)),
                  filled: true,
                  fillColor: const Color(0xFF161616),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF8B93FF), width: 1.5),
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(height: 24),
            TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF8B93FF),
              tabs: const [
                Tab(icon: Icon(Icons.photo), text: 'Dispositivo'),
                Tab(icon: Icon(Icons.palette), text: 'Estilos'),
              ],
            ),
            SizedBox(
              height: 280,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDevicePickerTab(),
                  _buildPresetGrid(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

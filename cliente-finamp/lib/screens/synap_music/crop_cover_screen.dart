import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CropCoverScreen extends StatefulWidget {
  final File imageFile;

  const CropCoverScreen({Key? key, required this.imageFile}) : super(key: key);

  @override
  _CropCoverScreenState createState() => _CropCoverScreenState();
}

class _CropCoverScreenState extends State<CropCoverScreen> {
  final TransformationController _controller = TransformationController();
  ui.Image? _loadedImage;
  bool _isLoading = true;
  int _rotationQuarterTurns = 0;
  final GlobalKey _cropAreaKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadImageInfo();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadImageInfo() async {
    try {
      final bytes = await widget.imageFile.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      if (mounted) {
        setState(() {
          _loadedImage = frame.image;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error cargando imagen: $e')),
        );
      }
    }
  }

  void _resetPosition() {
    _controller.value = Matrix4.identity();
    setState(() {
      _rotationQuarterTurns = 0;
    });
  }

  void _rotate90() {
    setState(() {
      _rotationQuarterTurns = (_rotationQuarterTurns + 1) % 4;
    });
  }

  void _applyZoom(double zoom) {
    final matrix = _controller.value.clone();
    matrix.scale(zoom);
    _controller.value = matrix;
  }

  double _calculateCropSize(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double shortestSide = size.width < size.height ? size.width : size.height;
    return shortestSide - 48.0;
  }

  Future<void> _applyCrop() async {
    if (_loadedImage == null) return;

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      const cropOutputSize = 512.0;

      final paint = Paint()..isAntiAlias = true;

      final matrix = _controller.value;
      final scale = matrix.getMaxScaleOnAxis();
      final translationX = matrix.getTranslation().x;
      final translationY = matrix.getTranslation().y;

      final cropBoxSize = _calculateCropSize(context);
      final imgW = (_rotationQuarterTurns % 2 == 0) ? _loadedImage!.width.toDouble() : _loadedImage!.height.toDouble();
      final imgH = (_rotationQuarterTurns % 2 == 0) ? _loadedImage!.height.toDouble() : _loadedImage!.width.toDouble();

      final scaleRatio = cropOutputSize / cropBoxSize;

      canvas.save();
      canvas.scale(scaleRatio);
      canvas.translate(translationX, translationY);

      canvas.scale(scale);

      if (_rotationQuarterTurns != 0) {
        canvas.translate(imgW / 2, imgH / 2);
        canvas.rotate(_rotationQuarterTurns * 3.141592653589793 / 2);
        canvas.translate(-_loadedImage!.width / 2, -_loadedImage!.height / 2);
      }

      canvas.drawImage(_loadedImage!, Offset.zero, paint);
      canvas.restore();

      final picture = recorder.endRecording();
      final img = await picture.toImage(cropOutputSize.toInt(), cropOutputSize.toInt());
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        throw Exception('Error al codificar imagen a PNG');
      }

      final croppedBytes = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final croppedFile = File('${tempDir.path}/cropped_playlist_${DateTime.now().millisecondsSinceEpoch}.png');
      await croppedFile.writeAsBytes(croppedBytes);

      if (mounted) {
        Navigator.of(context).pop(); // Cierra el spinner
        Navigator.of(context).pop(croppedFile); // Retorna el archivo recortado
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Cierra el spinner
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al recortar la imagen: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cropSize = _calculateCropSize(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Recortar portada'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reiniciar',
            onPressed: _resetPosition,
          ),
          IconButton(
            icon: const Icon(Icons.rotate_90_degrees_ccw),
            tooltip: 'Rotar',
            onPressed: _rotate90,
          ),
          IconButton(
            icon: const Icon(Icons.check, color: Color(0xFF8B93FF)),
            tooltip: 'Aplicar',
            onPressed: _applyCrop,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: SizedBox(
                width: cropSize,
                height: cropSize,
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  key: _cropAreaKey,
                  children: [
                    InteractiveViewer(
                      transformationController: _controller,
                      minScale: 0.5,
                      maxScale: 4.0,
                      boundaryMargin: const EdgeInsets.all(double.infinity),
                      child: RotatedBox(
                        quarterTurns: _rotationQuarterTurns,
                        child: RawImage(
                          image: _loadedImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    IgnorePointer(
                      child: CustomPaint(
                        size: Size(cropSize, cropSize),
                        painter: _GridGuidePainter(),
                      ),
                    ),
                    IgnorePointer(
                      child: CustomPaint(
                        size: Size(cropSize, cropSize),
                        painter: _CornerAccentsPainter(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Container(
        color: const Color(0xFF141414),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.zoom_out, color: Colors.white70),
              onPressed: () => _applyZoom(0.85),
            ),
            IconButton(
              icon: const Icon(Icons.zoom_in, color: Colors.white70),
              onPressed: () => _applyZoom(1.15),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B93FF),
                foregroundColor: Colors.black,
              ),
              icon: const Icon(Icons.check),
              label: const Text('Recortar'),
              onPressed: _applyCrop,
            ),
          ],
        ),
      ),
    );
  }
}

class _GridGuidePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.25)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final stepX = size.width / 3.0;
    final stepY = size.height / 3.0;

    canvas.drawLine(Offset(stepX, 0), Offset(stepX, size.height), paint);
    canvas.drawLine(Offset(stepX * 2, 0), Offset(stepX * 2, size.height), paint);
    canvas.drawLine(Offset(0, stepY), Offset(size.width, stepY), paint);
    canvas.drawLine(Offset(0, stepY * 2), Offset(size.width, stepY * 2), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CornerAccentsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF8B93FF)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const len = 24.0;

    // Top Left
    canvas.drawLine(const Offset(0, 0), const Offset(len, 0), paint);
    canvas.drawLine(const Offset(0, 0), const Offset(0, len), paint);

    // Top Right
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - len, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, len), paint);

    // Bottom Left
    canvas.drawLine(Offset(0, size.height), Offset(len, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - len), paint);

    // Bottom Right
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width - len, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width, size.height - len), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

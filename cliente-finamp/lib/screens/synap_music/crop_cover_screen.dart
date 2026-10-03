import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

class CropCoverScreen extends StatefulWidget {
  final File imageFile;

  const CropCoverScreen({Key? key, required this.imageFile}) : super(key: key);

  @override
  _CropCoverScreenState createState() => _CropCoverScreenState();
}

class _CropCoverScreenState extends State<CropCoverScreen> {
  final TransformationController _controller = TransformationController();
  final GlobalKey _cropAreaKey = GlobalKey();
  int _rotationQuarterTurns = 0;
  bool _isCropping = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

  void _applyZoom(double factor) {
    final matrix = _controller.value.clone();
    final currentScale = matrix.getMaxScaleOnAxis();
    if (currentScale * factor < 0.5 || currentScale * factor > 6.0) return;

    final cropSize = _calculateCropSize(context);
    final focalPoint = Offset(cropSize / 2, cropSize / 2);

    final translation = matrix.getTranslation();
    final newScale = currentScale * factor;

    final newX = focalPoint.dx - (focalPoint.dx - translation.x) * factor;
    final newY = focalPoint.dy - (focalPoint.dy - translation.y) * factor;

    _controller.value = Matrix4.identity()
      ..translate(newX, newY)
      ..scale(newScale);
  }

  double _calculateCropSize(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double shortestSide = size.width < size.height ? size.width : size.height;
    return shortestSide - 48.0;
  }

  Future<void> _applyCrop() async {
    if (_isCropping) return;

    final cropSize = _calculateCropSize(context);

    setState(() {
      _isCropping = true;
    });

    try {
      await Future.delayed(const Duration(milliseconds: 50));

      final boundary = _cropAreaKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        throw Exception('No se pudo acceder al área de recorte');
      }

      final pixelRatio = 512.0 / cropSize;
      final image = await boundary.toImage(pixelRatio: pixelRatio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        throw Exception('Error al codificar imagen a PNG');
      }

      final croppedBytes = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final croppedFile = File('${tempDir.path}/cropped_playlist_${DateTime.now().millisecondsSinceEpoch}.png');
      await croppedFile.writeAsBytes(croppedBytes);

      if (mounted) {
        Navigator.of(context).pop(croppedFile);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCropping = false;
        });
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
            onPressed: _isCropping ? null : _resetPosition,
          ),
          IconButton(
            icon: const Icon(Icons.rotate_90_degrees_ccw),
            tooltip: 'Rotar',
            onPressed: _isCropping ? null : _rotate90,
          ),
          IconButton(
            icon: _isCropping
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF8B93FF)),
                  )
                : const Icon(Icons.check, color: Color(0xFF8B93FF)),
            tooltip: 'Aplicar',
            onPressed: _isCropping ? null : _applyCrop,
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: cropSize,
          height: cropSize,
          child: Stack(
            fit: StackFit.expand,
            children: [
              RepaintBoundary(
                key: _cropAreaKey,
                child: ClipRect(
                  child: Container(
                    color: Colors.black,
                    width: cropSize,
                    height: cropSize,
                    child: InteractiveViewer(
                      transformationController: _controller,
                      minScale: 0.5,
                      maxScale: 6.0,
                      boundaryMargin: EdgeInsets.all(cropSize),
                      child: SizedBox(
                        width: cropSize,
                        height: cropSize,
                        child: RotatedBox(
                          quarterTurns: _rotationQuarterTurns,
                          child: Center(
                            child: Image.file(
                              widget.imageFile,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
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
              onPressed: _isCropping ? null : () => _applyZoom(0.85),
            ),
            IconButton(
              icon: const Icon(Icons.zoom_in, color: Colors.white70),
              onPressed: _isCropping ? null : () => _applyZoom(1.15),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B93FF),
                foregroundColor: Colors.black,
              ),
              icon: _isCropping
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                    )
                  : const Icon(Icons.check),
              label: Text(_isCropping ? 'Guardando...' : 'Recortar'),
              onPressed: _isCropping ? null : _applyCrop,
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

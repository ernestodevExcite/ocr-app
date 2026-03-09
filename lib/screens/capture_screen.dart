
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;
import 'package:myapp/models/captured_image.dart';
import 'package:myapp/providers/image_provider.dart';
import 'package:myapp/services/ocr_service.dart';
import 'package:provider/provider.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  final OcrService _ocrService = OcrService();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _controller = CameraController(_cameras![0], ResolutionPreset.high);
      await _controller!.initialize();
      if (!mounted) return;
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _ocrService.dispose();
    super.dispose();
  }

  Map<String, String> _parseOcrText(String text) {
    final lines = text.split('\n');
    String title = '-';
    String author = '-';

    if (lines.isNotEmpty) {
      title = lines[0];
    }

    for (final line in lines) {
      if (line.toLowerCase().contains('by') || line.toLowerCase().contains('por')) {
        author = line.split(RegExp(r'(by|por)\s', caseSensitive: false)).last.trim();
        break;
      }
    }

    return {'Título': title, 'Autor': author};
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    try {
      final XFile imageFile = await _controller!.takePicture();
      final Uint8List imageBytes = await imageFile.readAsBytes();

      // Crear InputImage para ML Kit
      final inputImage = InputImage.fromFilePath(imageFile.path);
      final ocrText = await _ocrService.processImage(inputImage);
      final metadata = _parseOcrText(ocrText);

      // Comprimir la imagen
      final image = img.decodeImage(imageBytes);
      if (image != null) {
        final compressedImage = img.encodeJpg(image, quality: 85);
        final newImage = CapturedImage(
          imageData: Uint8List.fromList(compressedImage),
          metadata: metadata,
        );
        if (!mounted) return;
        context.read<AppImageProvider>().addImage(newImage);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Imagen capturada y procesada con OCR')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al capturar o procesar la imagen: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capturar Carátula'),
        actions: [
          IconButton(
            icon: const Icon(Icons.reviews),
            onPressed: () => context.go('/review'),
            tooltip: 'Ir a la pantalla de revisión',
          ),
        ],
      ),
      body: CameraPreview(_controller!),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}


import 'dart:developer' as developer;
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrService {
  final TextRecognizer _textRecognizer = TextRecognizer();

  Future<String> processImage(InputImage inputImage) async {
    try {
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      return recognizedText.text;
    } catch (e, s) {
      developer.log('Error al procesar la imagen para OCR', name: 'com.example.myapp.ocr', error: e, stackTrace: s);
      return ''; // O manejar el error de otra manera
    }
  }

  void dispose() {
    _textRecognizer.close();
  }
}

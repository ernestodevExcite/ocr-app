
import 'dart:typed_data';

enum ImageStatus { enRevision, completado }

class CapturedImage {
  final Uint8List imageData;
  final Map<String, String> metadata;
  String ocrText;
  ImageStatus status;

  CapturedImage({
    required this.imageData,
    required this.metadata,
    required this.ocrText,
    this.status = ImageStatus.enRevision,
  });
}

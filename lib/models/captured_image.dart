
import 'dart:typed_data';

enum ImageStatus { enRevision, completado }

class CapturedImage {
  final Uint8List imageData;
  final Map<String, String> metadata;
  ImageStatus status;

  CapturedImage({
    required this.imageData,
    required this.metadata,
    this.status = ImageStatus.enRevision,
  });
}

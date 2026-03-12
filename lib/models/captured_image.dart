
import 'dart:typed_data';

enum ImageStatus { enRevision, completado }
enum UploadStatus { pending, uploading, success, error }

class CapturedImage {
  final Uint8List imageData;
  final Map<String, String> metadata;
  ImageStatus status;
  UploadStatus uploadStatus;

  CapturedImage({
    required this.imageData,
    required this.metadata,
    this.status = ImageStatus.enRevision,
    this.uploadStatus = UploadStatus.pending,
  });
}

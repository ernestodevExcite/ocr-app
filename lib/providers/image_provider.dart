
import 'package:flutter/foundation.dart';
import '../models/captured_image.dart';
import '../models/document_type.dart';
import '../services/ocr_service.dart';

class AppImageProvider extends ChangeNotifier {
  final List<CapturedImage> _images = [];
  final OcrService _ocrService = OcrService();
  DocumentSettings? _currentSettings;

  List<CapturedImage> get images => _images;

  DocumentSettings? get currentSettings => _currentSettings;

  void setCurrentSettings(DocumentSettings settings) {
    _currentSettings = settings;
    notifyListeners();
  }

  void addImage(CapturedImage image) {
    _images.add(image);
    notifyListeners();
    uploadImage(_images.length - 1);
  }

  void updateImageStatus(int index, ImageStatus newStatus) {
    if (index >= 0 && index < _images.length) {
      _images[index].status = newStatus;
      notifyListeners();
    }
  }

  void updateUploadStatus(int index, UploadStatus newStatus) {
    if (index >= 0 && index < _images.length) {
      _images[index].uploadStatus = newStatus;
      notifyListeners();
    }
  }

  void updateImageMetadata(int index, Map<String, String> newMetadata) {
    if (index >= 0 && index < _images.length) {
      _images[index].metadata.clear();
      _images[index].metadata.addAll(newMetadata);
      notifyListeners();
    }
  }

  Future<void> uploadImage(int index) async {
    if (index < 0 || index >= _images.length) return;
    
    final image = _images[index];
    if (image.uploadStatus == UploadStatus.uploading || image.uploadStatus == UploadStatus.success) return;

    if (_currentSettings == null) {
      if (kDebugMode) {
        print('Error: currentSettings is null when trying to upload image');
      }
      return;
    }

    updateUploadStatus(index, UploadStatus.uploading);

    final success = await _ocrService.uploadImage(image.imageData, _currentSettings!);
    
    if (success) {
      updateUploadStatus(index, UploadStatus.success);
    } else {
      updateUploadStatus(index, UploadStatus.error);
    }
  }
}

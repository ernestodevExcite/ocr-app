
import 'package:flutter/foundation.dart';
import '../models/captured_image.dart';

class AppImageProvider extends ChangeNotifier {
  final List<CapturedImage> _images = [];

  List<CapturedImage> get images => _images;

  void addImage(CapturedImage image) {
    _images.add(image);
    notifyListeners();
  }

  void updateImageStatus(int index, ImageStatus newStatus) {
    if (index >= 0 && index < _images.length) {
      _images[index].status = newStatus;
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
}

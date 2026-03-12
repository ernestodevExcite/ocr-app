import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/image_provider.dart';
import '../models/captured_image.dart';

class QueueScreen extends StatelessWidget {
  const QueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Imágenes'),
      ),
      body: Consumer<AppImageProvider>(
        builder: (context, provider, child) {
          if (provider.images.isEmpty) {
            return const Center(child: Text('No hay imágenes en el historial.'));
          }

          return ListView.builder(
            itemCount: provider.images.length,
            itemBuilder: (context, index) {
              final image = provider.images[index];
              return ListTile(
                leading: Image.memory(
                  image.imageData,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text('Imagen ${index + 1}'),
                subtitle: Text(_getStatusText(image.uploadStatus)),
                trailing: _buildTrailing(context, provider, index, image.uploadStatus),
              );
            },
          );
        },
      ),
    );
  }

  String _getStatusText(UploadStatus status) {
    switch (status) {
      case UploadStatus.pending:
        return 'Pendiente';
      case UploadStatus.uploading:
        return 'Enviando...';
      case UploadStatus.success:
        return 'Enviado con éxito';
      case UploadStatus.error:
        return 'Error al enviar';
    }
  }

  Widget? _buildTrailing(BuildContext context, AppImageProvider provider, int index, UploadStatus status) {
    switch (status) {
      case UploadStatus.pending:
      case UploadStatus.uploading:
        return const SizedBox(
          width: 24,
          height: 24,
          child: Padding(
            padding: EdgeInsets.all(4.0),
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      case UploadStatus.success:
        return const Icon(Icons.check_circle, color: Colors.green);
      case UploadStatus.error:
        return IconButton(
          icon: const Icon(Icons.refresh, color: Colors.red),
          tooltip: 'Reintentar envío',
          onPressed: () {
            provider.uploadImage(index);
          },
        );
    }
  }
}


import 'package:flutter/material.dart';
import 'package:myapp/models/captured_image.dart';
import 'package:myapp/providers/image_provider.dart';
import 'package:myapp/services/export_service.dart';
import 'package:provider/provider.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  void _showEditDialog(BuildContext context, int index, CapturedImage image) {
    final titleController = TextEditingController(text: image.metadata['Título']);
    final authorController = TextEditingController(text: image.metadata['Autor']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Metadatos'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: authorController,
                decoration: const InputDecoration(labelText: 'Autor'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Guardar'),
              onPressed: () {
                final newMetadata = {
                  'Título': titleController.text,
                  'Autor': authorController.text,
                };
                context.read<AppImageProvider>().updateImageMetadata(index, newMetadata);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final exportService = ExportService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Revisar Capturas'),
      ),
      body: Consumer<AppImageProvider>(
        builder: (context, imageProvider, child) {
          if (imageProvider.images.isEmpty) {
            return const Center(
              child: Text('No hay imágenes para revisar.'),
            );
          }

          return ListView.builder(
            itemCount: imageProvider.images.length,
            itemBuilder: (context, index) {
              final image = imageProvider.images[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Image.memory(image.imageData, width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(image.metadata['Título'] ?? 'Sin título'),
                  subtitle: Text('Autor: ${image.metadata['Autor'] ?? '-'} | Estado: ${image.status.toString().split('.').last}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showEditDialog(context, index, image),
                      ),
                      IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () {
                          context.read<AppImageProvider>().updateImageStatus(index, ImageStatus.completado);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Exportar a CSV',
        onPressed: () {
          final images = context.read<AppImageProvider>().images;
          if (images.isNotEmpty) {
            final csv = exportService.convertToCsv(images);
            exportService.downloadCsv(csv);
          }
        },
        child: const Icon(Icons.download),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:myapp/models/captured_image.dart';
import 'package:myapp/providers/image_provider.dart';
import 'package:myapp/services/export_service.dart';
import 'package:provider/provider.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final Map<int, TextEditingController> _ocrControllers = {};

  TextEditingController _getOcrController(int index, String initialText) {
    return _ocrControllers.putIfAbsent(index, () => TextEditingController(text: initialText));
  }

  @override
  void dispose() {
    for (var controller in _ocrControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

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
              final ocrController = _getOcrController(index, image.ocrText);
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.memory(image.imageData, width: 50, height: 50, fit: BoxFit.cover),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(image.metadata['Título'] ?? 'Sin título', style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text('Autor: ${image.metadata['Autor'] ?? '-'} | Estado: ${image.status.toString().split('.').last}'),
                              ],
                            ),
                          ),
                          Row(
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
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          const Text('Texto reconocido:', style: TextStyle(fontWeight: FontWeight.bold)),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              ocrController.clear();
                              context.read<AppImageProvider>().updateImageOcrText(index, '');
                            },
                            tooltip: 'Eliminar texto',
                          ),
                        ],
                      ),
                      TextField(
                        controller: ocrController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Texto reconocido de la imagen',
                        ),
                        onChanged: (value) {
                          context.read<AppImageProvider>().updateImageOcrText(index, value);
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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/document_type.dart';
import '../services/ocr_service.dart';
import '../providers/image_provider.dart';

class DocumentTypeSelectionScreen extends StatefulWidget {
  const DocumentTypeSelectionScreen({super.key});

  @override
  State<DocumentTypeSelectionScreen> createState() =>
      _DocumentTypeSelectionScreenState();
}

class _DocumentTypeSelectionScreenState
    extends State<DocumentTypeSelectionScreen> {
  final OcrService _ocrService = OcrService();
  List<DocumentType> _documentTypes = [];
  List<DocumentType> _filteredDocumentTypes = [];
  bool _isLoading = true;
  DocumentType? _selectedType;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchDocumentTypes();
    _searchController.addListener(_filterDocumentTypes);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchDocumentTypes() async {
    setState(() => _isLoading = true);
    final types = await _ocrService.fetchDocumentTypes();
    setState(() {
      _documentTypes = types;
      _filteredDocumentTypes = types;
      _isLoading = false;
    });
  }

  void _filterDocumentTypes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredDocumentTypes = _documentTypes.where((type) {
        return type.title.toLowerCase().contains(query) ||
            type.description.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _startCapture() {
    if (_selectedType != null) {
      // Set the selected settings in our provider so CaptureScreen / OcrService can use it
      Provider.of<AppImageProvider>(
        context,
        listen: false,
      ).setCurrentSettings(_selectedType!.settings);

      // Navigate to capture screen
      context.go('/capture');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona el tipo de documento'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Info action
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar tipos de documento',
                  prefixIcon: const Icon(Icons.search, color: Colors.blue),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredDocumentTypes.isEmpty
                  ? const Center(
                      child: Text('No se encontraron tipos de documento.'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: _filteredDocumentTypes.length,
                      itemBuilder: (context, index) {
                        final type = _filteredDocumentTypes[index];
                        final isSelected = _selectedType == type;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey.shade300,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          elevation: 0,
                          color: Colors.white,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              setState(() {
                                _selectedType = type;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              type.icon,
                                              color: Theme.of(context).colorScheme.primary,
                                              size: 24,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                type.title,
                                                style: theme
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black87,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          type.description,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                color: Colors.grey.shade600,
                                              ),
                                        ),
                                        const SizedBox(height: 16),
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              _selectedType = type;
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: isSelected
                                                ? Theme.of(context).colorScheme.primary
                                                : Colors.grey.shade100,
                                            foregroundColor: isSelected
                                                ? Colors.white
                                                : Colors.black87,
                                            elevation: 0,
                                            minimumSize: const Size(
                                              double.infinity,
                                              40,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Text(
                                            isSelected
                                                ? 'Seleccionado'
                                                : 'Seleccionar',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary.withAlpha(
                                        25,
                                      ), // equivalent to withOpacity(0.1) -> 255 * 0.1 =~ 25
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        type.icon,
                                        size: 36,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _selectedType != null ? _startCapture : null,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text(
                    'Iniciar captura',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    disabledForegroundColor: Colors.grey.shade500,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

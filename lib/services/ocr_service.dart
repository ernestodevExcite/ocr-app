
import 'dart:developer' as developer;
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/document_type.dart';
import 'package:flutter/material.dart';

class OcrService {
  final String _ocrEndpoint = 'https://digitalizacion-images-processing-service-289172937432.us-central1.run.app/v1/processing/image-ocr-ia-n8n-flow'; // TODO: Update with real endpoint URL

  Future<List<DocumentType>> fetchDocumentTypes() async {
    try {
      final response = await http.get(Uri.parse('https://digitalizacion-demo-backend-main-289172937432.us-central1.run.app/v1/integrations/app-capture-covers/settings'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final Map<String, dynamic> settingsData = jsonResponse['data'];
        
        final DocumentSettings settings = DocumentSettings.fromJson(settingsData);

        // Mocking the list of document types for now since the API only returns a single setting object
        // Later, this should parse an array of objects from the API.
        return [
          DocumentType(
            id: '1',
            title: 'Juicio Mercantil',
            description: 'Optimized for commercial litigation OCR rules and financial entity data.',
            icon: Icons.account_balance,
            settings: settings,
          ),
          DocumentType(
            id: '2',
            title: 'Juicio Judicial',
            description: 'Standard judicial proceeding document extraction and court records.',
            icon: Icons.gavel,
            settings: settings,
          ),
          DocumentType(
            id: '3',
            title: 'Contrato Civil',
            description: 'Configuration for civil contracts, property agreements, and personal legal bonds.',
            icon: Icons.assignment,
            settings: settings,
          ),
          DocumentType(
            id: '4',
            title: 'Documento General',
            description: 'A flexible engine for scanning miscellaneous legal or identification paperwork.',
            icon: Icons.folder,
            settings: settings,
          ),
        ];

      } else {
        developer.log('Error HTTP al obtener settings: ${response.statusCode}', name: 'com.example.myapp.ocr');
        return [];
      }
    } catch (e, s) {
      developer.log('Error de conexión al obtener settings', name: 'com.example.myapp.ocr', error: e, stackTrace: s);
      return [];
    }
  }

  Future<bool> uploadImage(Uint8List imageBytes, DocumentSettings settings) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(_ocrEndpoint));
      // Use dynamic settings
      request.fields['maxSize'] = settings.maxSize;
      request.fields['maxWidth'] = settings.maxWidth;
      request.fields['imageFormat'] = settings.imageFormat;
      request.fields['promptUser'] = settings.promptUser;
      request.fields['systemMessage'] = settings.systemMessage;
      request.fields['n8nUrlService'] = settings.n8nUrlService;
      request.fields['urlWebhookReturn'] = settings.urlWebhookReturn;

      request.files.add(http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: 'captured_image.jpg',
      ));

      final response = await request.send();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        developer.log('Error HTTP al enviar la imagen: ${response.statusCode}', name: 'com.example.myapp.ocr');
        return false;
      }
    } catch (e, s) {
      developer.log('Error de conexión al enviar la imagen', name: 'com.example.myapp.ocr', error: e, stackTrace: s);
      return false; 
    }
  }

  void dispose() {
    // No resources to dispose
  }
}

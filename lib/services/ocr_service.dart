
import 'dart:developer' as developer;
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class OcrService {
  final String _ocrEndpoint = 'https://digitalizacion-images-processing-service-289172937432.us-central1.run.app/v1/processing/image-ocr-ia-n8n-flow'; // TODO: Update with real endpoint URL

  Future<bool> uploadImage(Uint8List imageBytes) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(_ocrEndpoint));
      request.fields['maxSize'] = '115';
      request.fields['maxWidth'] = '935';
      request.fields['imageFormat'] = 'jpeg';
      request.fields['promptUser'] = 'Hola, me ayudas a obtener el texto de esta imagen';
      request.fields['systemMessage'] = 'Actúa como un motor de OCR. Analiza la imagen adjunta y extrae todo el texto legible. Mantén el formato original lo más posible. Los datos que se deben de extraer son los siguientes: juzgado, numero_de_expediente, demandante, demandado, asunto_expediente, anio, dia, mes, donde_fue_iniciado_el_expediente, nombre_juez, cargo_juez, nombre_secretaria, cargo_secretaria y mesa_trabajo. Si hay datos que no sean mencionados por favor incluyelos en el texto de salida. El formato de salida debe ser en formato JSON. con las siguientes características: [ { [valor (juzgado)]: { \"valor\": string, \"legibilidad\": number } } ]. Los valores de legibilidad son del 1 al 3, donde 1 es legibilidad mas baja y 3 es legibilidad mas alta. No se debe de omitir ningún campo. Respetar siempre el formato de salida. Si no se pueda leer el texto, por favor dejar vacio el valor del campo (cadena vacia). Si crees poder completar el campo con un valor aproximado, por favor incluir el valor aproximado en el valor del campo';
      request.fields['n8nUrlService'] = 'https://n8n.srv930895.hstgr.cloud/webhook/68b64b05-d298-4a16-9d6e-97a54b32f95a';
      request.fields['urlWebhookReturn'] = 'url';

      request.files.add(http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: 'captured_image.jpg',
      ));

      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      print(responseBody.statusCode);
      print(responseBody.body);

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

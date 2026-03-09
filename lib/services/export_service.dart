
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:myapp/models/captured_image.dart';
import 'package:universal_html/html.dart' as html;

class ExportService {
  String convertToCsv(List<CapturedImage> images) {
    final List<List<dynamic>> rows = [];

    // Encabezados
    rows.add(['Título', 'Autor', 'Estado']);

    // Datos
    for (final image in images) {
      rows.add([
        image.metadata['Título'] ?? '-',
        image.metadata['Autor'] ?? '-',
        image.status.toString().split('.').last,
      ]);
    }

    return const ListToCsvConverter().convert(rows);
  }

  void downloadCsv(String csv) {
    final bytes = utf8.encode(csv);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute("download", "juegos.csv")
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

class ReadingsService {
  static Future<Map<String, dynamic>> fetchDailyReadings(String date) async {
    final url =
        'https://publication.evangelizo.ws/SP/days/$date?include=readings,commentary';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final readings = data['data']['readings'] as List;

      // Extraemos el comentario
      final commentary = data['data']['commentary'] != null
          ? {
              'title':
                  data['data']['commentary']['title'] ?? 'No title available',
              'description': data['data']['commentary']['description'] ??
                  'No description available',
              'author': data['data']['commentary']['author']?['name'] ??
                  'Unknown author',
              'source':
                  data['data']['commentary']['source'] ?? 'No source available',
            }
          : null;

      // Procesamos las lecturas
      final processedReadings = readings.map((reading) {
        return {
          'id': reading['id'],
          'reading_code': reading['reading_code'],
          'text': reading['text'],
          'reference': reading['reference_displayed'],
          'book': reading['book']['full_title'],
          'type': reading['type'],
          'chorus': reading['chorus'] ?? 'No chorus available',
          // Default in case there's no chorus
        };
      }).toList();

      // Retornamos tanto las lecturas como el comentario
      return {
        'readings': processedReadings,
        'commentary': commentary,
      };
    } else {
      throw Exception('Error al obtener las lecturas del día');
    }
  }
}

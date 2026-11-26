import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static Future<dynamic> obtenerClima({
    required double longitud,
    required double latitud,
  }) async {
    String url =
        'https://api.open-meteo.com/v1/forecast?latitude=$latitud&longitude=$longitud&current_weather=true';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      return jsonDecode(body);
    } else {
      throw Exception('No se ha podido conectar');
    }
  }
}
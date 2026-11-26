import 'package:paisesgui/data/services/weather_service.dart';

class WeatherRepository {
  static Future<dynamic> obtenerClima({
    required double longitud,
    required double latitud,
  }) async {
    return await WeatherService.obtenerClima(
      longitud: longitud,
      latitud: latitud,
    );
  }
}
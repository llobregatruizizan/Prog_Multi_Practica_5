import 'package:flutter/material.dart';
import 'package:paisesgui/data/repositories/weather_repository.dart';
import 'package:paisesgui/ui/widgets/my_circular_progress_indicator.dart';

class MyWeatherInfo extends StatefulWidget {
  final double? latitud;
  final double? longitud;

  const MyWeatherInfo({
    super.key,
    required this.latitud,
    required this.longitud,
  });

  @override
  State<MyWeatherInfo> createState() => _MyWeatherInfoState();
}

class _MyWeatherInfoState extends State<MyWeatherInfo> {
  late Future<dynamic> _clima;

  @override
  void initState() {
    super.initState();

    _clima = WeatherRepository.obtenerClima(
      latitud: widget.latitud ?? 0.0,
      longitud: widget.longitud ?? 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _clima,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var clima = snapshot.data["current_weather"];

          return Column(
            children: [
              _obtenerIconoTiempo(clima["weathercode"].toString()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.thermostat, size: 35),
                  Text(
                    "${clima["temperature"]}º",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wind_power, size: 35),
                  const SizedBox(width: 30),
                  Text(
                    "${clima["windspeed"]} km/h",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(width: 30),
                  obtenerWidgetDireccionViento(
                    clima["winddirection"].toString(),
                    context,
                  ),
                ],
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          return const MyCircularProgressIndicator();
        }
      },
    );
  }

  Widget obtenerWidgetDireccionViento(
    String direccionViento,
    BuildContext context,
  ) {
    double dir = double.parse(direccionViento);
    late Icon icono;

    late String nombreViento;

    if (dir > 22.5 && dir < 65.5) {
      icono = const Icon(Icons.north_east);
      nombreViento = "Gregal";
    } else if (dir > 67.5 && dir < 112.5) {
      icono = const Icon(Icons.east);
      nombreViento = "Levante";
    } else if (dir > 112.5 && dir < 157.5) {
      icono = const Icon(Icons.south_east);
      nombreViento = "Jaloque";
    } else if (dir > 157.5 && dir < 202.5) {
      icono = const Icon(Icons.south);
      nombreViento = "Mediodía";
    } else if (dir > 202.5 && dir < 247.5) {
      icono = const Icon(Icons.south_west);
      nombreViento = "Lebeche";
    } else if (dir > 247.5 && dir < 292.5) {
      icono = const Icon(Icons.west);
      nombreViento = "Poniente";
    } else if (dir > 292.5 && dir < 337.5) {
      icono = const Icon(Icons.north_west);
      nombreViento = "Mistral";
    } else {
      icono = const Icon(Icons.north);
      nombreViento = "Tramontana";
    }
    return Row(
      children: [
        Text(nombreViento, style: Theme.of(context).textTheme.headlineSmall),
        icono,
      ],
    );
  }

  // Codigos de https://open-meteo.com/en/docs/dwd-api

  Widget _obtenerIconoTiempo(String value) {
    Set<String> sol = <String>{"0"};
    Set<String> pocasNubes = <String>{"1", "2", "3"};
    Set<String> nubes = <String>{"45", "48"};
    Set<String> lluviaSuave = <String>{"51", "53", "55"};
    Set<String> lluvia = <String>{
      "61",
      "63",
      "65",
      "66",
      "67",
      "80",
      "81",
      "82",
      "95",
      "96",
      "99",
    };
    Set<String> neu = <String>{"71", "73", "75", "77", "85", "86"};

    if (sol.contains(value)) {
      return Image.asset("assets/icons/png/soleado.png");
    }
    if (pocasNubes.contains(value)) {
      return Image.asset("assets/icons/png/poco_nublado.png");
    }
    if (nubes.contains(value)) {
      return Image.asset("assets/icons/png/nublado.png");
    }
    if (lluviaSuave.contains(value)) {
      return Image.asset("assets/icons/png/lluvia_debil.png");
    }
    if (lluvia.contains(value)) {
      return Image.asset("assets/icons/png/lluvia.png");
    }
    if (neu.contains(value)) {
      return Image.asset("assets/icons/png/nieve.png");
    }

    return Image.asset("assets/icons/png/poco_nublado.png");
  }
}

import 'package:flutter/material.dart';
import 'package:paisesgui/data/repositories/paises_repository.dart';
import 'package:paisesgui/ui/widgets/my_weather_info.dart';
import 'package:paisesgui/domain/entities/pais.dart';
import 'package:paisesgui/config/config.dart';
import 'package:paisesgui/ui/widgets/my_circular_progress_indicator.dart';

class InfoPaisDetalle extends StatelessWidget {
  final String nombrePais;

  InfoPaisDetalle({super.key, required this.nombrePais});

  // Referencia al repositorio, de donde obtendremos la lista de continentes
  final PaisesRepository _repository = PaisesRepository(Config.urlApi);

  @override
  Widget build(BuildContext context) {
    // TO-DO
    // Añadir la información siguiente sobre el país:
    // Población (num. de habitantes), latitud y longitud.
    // Podéis combinar Column y Row para mostrar la información tabulada

    // Antes de la información, deberemos mostrar la información sobre el tiempo en el país,
    // mediante el widtget personalizado MyWeatherInfo(), que se os proporciona ya implementado
    return Scaffold(
      body: FutureBuilder<Pais?>(
        future: _repository.infoPais(nombrePais),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Pais pais = snapshot.data!;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: MyWeatherInfo(
                        latitud: pais.latitud,
                        longitud: pais.longitud,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        const SizedBox(width: 10),
                        const SizedBox(
                          width: 200,
                          child: Text("          Población:"),
                        ),
                        Expanded(
                          child: Text("${pais.poblacion ?? 'No disponible'}"),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        const SizedBox(width: 10),
                        const SizedBox(
                          width: 200,
                          child: Text("          Latitud:"),
                        ),
                        Text("${pais.latitud ?? 'No disponible'}°"),
                      ],
                    ),

                    Row(
                      children: [
                        const SizedBox(width: 10),
                        const SizedBox(
                          width: 200,
                          child: Text("          Longitud:"),
                        ),
                        Text("${pais.longitud ?? 'No disponible'}°"),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (snapshot.connectionState == ConnectionState.done) {
            return const Text("País no encontrado");
          } else {
            return const Center(child: MyCircularProgressIndicator());
          }
        },
      ),
    );
  }
}

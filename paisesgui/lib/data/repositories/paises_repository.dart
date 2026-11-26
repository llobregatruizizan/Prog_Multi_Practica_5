// Define el repositorio de acceso a los datos
// Esta capa es la que se usa desde la aplicación para abstraer
// el acceso a los datos.
// Hemos cambiado el repositorio.
// Ahora en vez de obtenerlo de la clase PaisesApi lo obtenemos de PaisesEjemplo (ya no jajaja)

import 'package:paisesgui/domain/entities/continente.dart';
import 'package:paisesgui/domain/entities/pais.dart';
import 'package:paisesgui/data/services/paises_api.dart';

class PaisesRepository {
  // Con late indicamos que este valor
  // se inicializar posteriormente (en el constructor)
  late PaisesApi api;

  PaisesRepository(String urlBase) {
    api = PaisesApi(urlBase);
  }
  Future<List<Continente>> getContinentes() async {
    // Devuelve una lista de provincias, obtenidas a partir de la propiedad
    // provincies de RepositoryData.

    List<Continente> continentes = [];
    for (var conti in await api.getContinentes()) {
      continentes.add(
        Continente(nombre: conti["nombre"], imagen: conti["imagen"]),
      );
    }

    return continentes;
  }

  // Implementar el método getPaises a partir del continente
 Future<List<Pais>> getPaises(String nombreContinente) async {
  List<Pais> paises = [];

  for (var paisJSON in await api.getPaises(nombreContinente)) {
    paises.add(Pais.fromJSON(paisJSON));
  }

  return paises;
}

  // TO-DO:
  // Implementar el método infoPais
  Future<Pais?> infoPais(String nombrePais) async {
  var paisJSON = await api.infoPais(nombrePais);

  if (paisJSON != null) {
    return Pais.fromJSON(paisJSON);
  }

  return null;
}
}

import 'package:flutter/material.dart';
import 'package:paisesgui/data/repositories/paises_repository.dart';
import 'package:paisesgui/domain/entities/continente.dart';
import 'package:paisesgui/ui/screens/paises_screen.dart';
import 'package:paisesgui/config/config.dart';

/* Pantalla ContinentesScreen: muestra cinco CircleAvatar con los distintos continentes */

class ContinentesScreen extends StatelessWidget {
  ContinentesScreen({super.key});

  // Referencia al repositorio, de donde obtendremos la lista de continentes
final PaisesRepository _repository = PaisesRepository(Config.urlApi);
  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
      child: FutureBuilder<List<Continente>>(
        future: _repository.getContinentes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _creaListaContinentes(snapshot.data!),
              ),
            );
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    ),
  );
}
}

List<Widget> _creaListaContinentes(List<Continente> listaContinentes) {
  // Devolveremos una lista de widgets
  List<Widget> listaWidgets = [];

  // Recorremos la lista de continentes
  for (Continente continente in listaContinentes) {
    listaWidgets.add(
      // Y añadimos a la lista un widget personalizado de tipo ContinenteRoundButton
      ContinenteRoundButton(
        nombre: continente.nombre,
        imagen: continente.imagen ?? "",
      ),
    );
    listaWidgets.add(
      const SizedBox(height: 20),
    ); // Añadimos un espacio después del widget con el continente
  }
  return listaWidgets;
}

class ContinenteRoundButton extends StatelessWidget {
  const ContinenteRoundButton({
    required this.imagen,
    required this.nombre,
    super.key,
  });

  final String imagen;
  final String nombre;

  @override
  Widget build(BuildContext context) {

    // TO-DO

    // devolveremos un widget de tipo CircleAvatar con las siguientes propiedades
    // radius: 110
    // imagen de fondo: la imagen que nos han proporcionado. Esta imagen se obtendrá de Internet
    // Este widget contendrá como hijo un widget de tipo Text, con el nombre del continente
    // Para darle estilo al texto, puedes utilizar: style: Theme.of(context).textTheme.displayMedium,
    // (en el Main, hemos definido ya un estilo personalizado para la aplicación, por tanto, de aquí hacemos referencia a ese tema)

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaisesScreen(nombreContinente: nombre),
          ),
        );
      },
      child: CircleAvatar(
        backgroundImage: NetworkImage(imagen),
        radius: 110,
        child: Text(nombre, style: Theme.of(context).textTheme.displayMedium),
      ),
    );
  }
}

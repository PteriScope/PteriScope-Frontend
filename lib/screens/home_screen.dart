import 'package:flutter/material.dart';
import 'package:pteriscope_frontend/constants.dart';
//import 'package:tu_app/models/patient.dart'; // Asumiendo que tienes un modelo para el paciente.

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //List<Patient> patients = []; // Este es el listado de pacientes que obtendrías del backend.

  @override
  void initState() {
    super.initState();
    // Aquí deberías llamar a tu función que trae los pacientes del backend y actualizar el estado.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PteriScope',
          style: TextStyle(
            fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          color: Colors.white,
          onPressed: () {
            // Aquí implementarías la lógica para abrir el menú tipo hamburguesa.
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: AppConstants.padding),
            child: Image(
              image: AssetImage('assets/Logo_w.png'),
              height: 40,
            ),
          ),
        ],
        backgroundColor: AppConstants.primaryColor,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.padding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  children: [
                    Text(
                      'Lista de pacientes',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      // TODO
                      //'Total de pacientes: ${patients.length}',
                      'Total de pacientes: 10',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navegación a la pantalla de creación de nuevo paciente.
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Nuevo paciente'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  ),
                ),
              ]
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(left: AppConstants.padding, right: AppConstants.padding, bottom: AppConstants.padding),
            child: Divider(thickness: 1.5,)
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Busca a un paciente',
                hintStyle: const TextStyle(
                  color: Colors.grey
                ),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              onChanged: (value) {
                // Aquí el filtro de búsqueda.
              },
            ),
          ),
          //Expanded(
          //  child: ListView.builder(
          //    itemCount: patients.length,
          //    itemBuilder: (context, index) {
          //      final patient = patients[index];
          //      return ListTile(
          //        title: Text('${patient.firstName} ${patient.lastName}'),
          //        subtitle: Text('${patient.dni}'),
          //        trailing: Text('${patient.reviews.length} Revisiones'),
          //        onTap: () {
          //          // Aquí podrías implementar una acción al tocar cada paciente.
          //        },
          //      );
          //    },
          //  ),
          //),
        ],
      )
    );
  }
}

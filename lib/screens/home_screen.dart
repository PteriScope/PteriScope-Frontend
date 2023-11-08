import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pteriscope_frontend/constants.dart';
import 'package:pteriscope_frontend/services/api_service.dart';
import 'package:pteriscope_frontend/services/shared_preferences_service.dart';

import '../models/patient.dart';
import 'login_screen.dart';
//import 'package:tu_app/models/patient.dart'; // Asumiendo que tienes un modelo para el paciente.

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Patient> patients = [];
  int totalPatients = 0;
  //int? specialistId;

  @override
  void initState() {
    super.initState();
    //var apiService = Provider.of<ApiService>(context, listen: false);
    //apiService.getPatientsFromSpecialist().then(
    //        (value) => {
    //          patients = value,
    //        }
    //);
  }

  void _logout(){
    SharedPreferencesService().removeAuthToken();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
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
            _logout();
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
                Column(
                  children: [
                    const Text(
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
                      'Total de pacientes: $totalPatients',
                      //'Total de pacientes: 10',
                      style: const TextStyle(
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

          Expanded(
            child: Card(
              child: FutureBuilder(
                // ApiService is being called to fetch patients when the future is null
                future: Provider.of<ApiService>(context, listen: false).getPatientsFromSpecialist(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.error != null) {
                    // Handle error state
                    log(snapshot.error.toString());
                    return const Center(child: Text('Error fetching data'));
                  } else if (snapshot.hasData) {
                    log("HAS DATA==============");


                    patients = snapshot.data as List<Patient>;
                    return ListView.builder(
                      itemCount: patients.length,
                      itemBuilder: (context, index) {
                        final patient = patients[index];
                        log(patient.dni);
                        return ListTile(
                          title: Text('${patient.firstName} ${patient.lastName}'),
                          subtitle: Text('DNI: ${patient.dni}'),
                          // Aquí puedes añadir más información sobre el paciente
                        );
                      },
                    );
                  } else {

                    return const Center(child: Text('No patients found'));
                  }
                },
              ),
            ),
          )


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

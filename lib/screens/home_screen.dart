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
  int? totalPatients;
  ApiService apiService = ApiService();
  bool loading = true;
  bool error = false;

  @override
  void initState() {
    super.initState();
    loadPatients();
  }

  void loadPatients() async {
    try {
      var _ = await apiService.getPatientsFromSpecialist().then((value) => {
            setState(() {
              patients = value;
              totalPatients = patients.length;
              loading = false;
            })
          });
    } catch (e) {
      setState(() {
        loading = false;
        error = true;
      });
    }
  }

  void _logout() {
    SharedPreferencesService().removeAuthToken();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'PteriScope',
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
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
                              color: Colors.white),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          // TODO
                          'Total de pacientes: ${totalPatients ?? 0}',
                          style: const TextStyle(
                              fontSize: 15, color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Navegación a la pantalla de creación de nuevo paciente.
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Nuevo paciente'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                      ),
                    ),
                  ]),
            ),

            const Padding(
                padding: EdgeInsets.only(
                    left: AppConstants.padding,
                    right: AppConstants.padding,
                    bottom: AppConstants.padding),
                child: Divider(
                  thickness: 1.5,
                )),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppConstants.padding),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Busca a un paciente',
                  hintStyle: const TextStyle(color: Colors.grey),
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
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : error == true
                        ? const Center(child: Text("Error al cargar los datos"))
                        : ListView.builder(
                            itemCount: patients.length,
                            itemBuilder: (context, index) {
                              final patient = patients[index];
                              return ListTile(
                                title: Text(
                                    '${patient.firstName} ${patient.lastName}'),
                                subtitle: Text('DNI: ${patient.email}'),
                              );
                            },
                          ),
              ),
            )
          ],
        ));
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pteriscope_frontend/util/constants.dart';
import 'package:pteriscope_frontend/screens/patient_detail_screen.dart';
import 'package:pteriscope_frontend/services/api_service.dart';
import 'package:pteriscope_frontend/services/shared_preferences_service.dart';

import '../models/patient.dart';
import '../util/shared.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
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
      var _ = await apiService
          .getPatientsFromSpecialist()
          .then((patientsResponse) async => {
                setState(() {
                  patients = patientsResponse;
                  totalPatients = patients.length;
                  loading = false;
                })
              });
    } catch (e) {
      setState(() {
        loading = false;
        error = true;
        log(e.toString());
      });
    }
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
              Shared.logout(context);
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
                child: Divider(thickness: 1.5)),
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
                  // TODO: Aquí el filtro de búsqueda.
                },
              ),
            ),
            Expanded(
              child: Card(
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : error == true
                        ? const Center(child: Text("Error al cargar los datos"))
                        : Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                    left: AppConstants.padding / 2.0,
                                    right: AppConstants.padding / 2.0,
                                    bottom: AppConstants.padding / 2.0,
                                    top: AppConstants.padding),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          'Datos del paciente',
                                          style: TextStyle(
                                              color: Color(0xFF838793),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Center(
                                        child: Text(
                                          'Última revisión',
                                          style: TextStyle(
                                              color: Color(0xFF838793),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Center(
                                        child: Text(
                                          'Grupo',
                                          style: TextStyle(
                                              color: Color(0xFF838793),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: patients.length,
                                  itemBuilder: (context, index) {
                                    final patient = patients[index];

                                    String? lastReviewDate =
                                    patient.lastReviewDate != null
                                        ? DateFormat('dd/MM/yyyy').format(
                                            patient.lastReviewDate!)
                                        : '-';

                                    String? lastReviewResult =
                                        patient.lastReviewResult ?? '-';

                                    return InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PatientDetailScreen(
                                                    patient: patient),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                              AppConstants.padding / 2.0
                                          ),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 2,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                        '${patient.firstName} ${patient.lastName}',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold
                                                        )
                                                    ),
                                                    Text(
                                                      patient.email,
                                                      style: const TextStyle(
                                                          fontSize: 10),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Center(
                                                    child: Text(
                                                      lastReviewDate,
                                                      style: const TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                          FontWeight.bold
                                                      ),
                                                )),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Center(
                                                    child: Text(
                                                  lastReviewResult!,
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color:
                                                          Shared.getColorResult(
                                                              lastReviewResult),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
              ),
            )
          ],
        ));
  }
}

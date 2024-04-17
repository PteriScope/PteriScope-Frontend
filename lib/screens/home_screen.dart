import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pteriscope_frontend/screens/new_patient_screen.dart';
import 'package:pteriscope_frontend/util/constants.dart';
import 'package:pteriscope_frontend/screens/patient_detail_screen.dart';
import 'package:pteriscope_frontend/services/api_service.dart';
import 'package:pteriscope_frontend/widgets/pteriscope_app_bar.dart';
import 'package:pteriscope_frontend/widgets/pteriscope_menu_bar.dart';

import '../models/patient.dart';
import '../util/pteriscope_screen.dart';
import '../util/shared.dart';
import '../widgets/pteriscope_colum_header.dart';
import '../widgets/pteriscope_header.dart';

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
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        searchQuery = _searchController.text;
      });
    });
    loadPatients();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Patient> _filterPatients(List<Patient> patientList, String query) {
    if (query.isEmpty) return patientList;
    return patientList.where((patient) {
      return patient.firstName.toLowerCase().contains(query.toLowerCase()) ||
          patient.lastName.toLowerCase().contains(query.toLowerCase());
    }).toList();
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
        appBar: const PteriscopeAppBar(title: 'PteriScope'),
        drawer: const PteriscopeMenuBar(currentView: PteriscopeScreen.patientList),
        body: Column(
          children: [
            PteriscopeHeader(
              title: 'Lista de pacientes',
              subtitle: 'Total de pacientes: ${totalPatients ?? 0}',
              buttonTitle: 'Nuevo paciente',
              action: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const NewPatient(),
                  ),
                );
              },
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
                controller: _searchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Busca a un paciente',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : error == true
                        ? const Center(child: Text("Error al cargar los datos"))
                        : _buildPatientList(),
              ),
            )
          ],
        ));
  }

  Widget _buildPatientList() {
    return Column(
      children: [
        const PteriScopeColumnHeader(
          firstTitle: 'Datos del paciente',
          secondTitle: 'Última revisión',
          thirdTitle: 'Resultado',
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                loading = true;
              });
              loadPatients();
            },
            child: ListView.builder(
              itemCount:
                  _filterPatients(patients, _searchController.text).length,
              itemBuilder: (context, index) {
                final patient =
                    _filterPatients(patients, _searchController.text)[index];

                String? lastReviewDate = patient.lastReviewDate != null
                    ? DateFormat('dd/MM/yyyy').format(patient.lastReviewDate!)
                    : '-';

                String? lastReviewResult = patient.lastReviewResult ?? '-';

                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            PatientDetailScreen(patient: patient),
                      ),
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.padding / 2.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text('${patient.firstName} ${patient.lastName}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                Text(
                                  patient.email,
                                  style: const TextStyle(fontSize: 10),
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
                                  fontSize: 10, fontWeight: FontWeight.bold),
                            )),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                                child: Text(
                              lastReviewResult,
                              style: TextStyle(
                                  fontSize: 10,
                                  color:
                                      Shared.getColorResult(lastReviewResult),
                                  fontWeight: FontWeight.bold),
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
        ),
      ],
    );
  }
}

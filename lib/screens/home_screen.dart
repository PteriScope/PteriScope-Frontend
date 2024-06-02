import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pteriscope_frontend/screens/patient/new_patient_screen.dart';
import 'package:pteriscope_frontend/screens/patient/patient_detail_screen.dart';
import 'package:pteriscope_frontend/util/constants.dart';
import 'package:pteriscope_frontend/services/api_service.dart';
import 'package:pteriscope_frontend/util/enum/dialog_type.dart';
import 'package:pteriscope_frontend/util/ps_exception.dart';
import 'package:pteriscope_frontend/util/ps_token_exception.dart';
import 'package:pteriscope_frontend/widgets/ps_app_bar.dart';
import 'package:pteriscope_frontend/widgets/ps_elevated_button_icon.dart';
import 'package:pteriscope_frontend/widgets/ps_menu_bar.dart';

import '../models/patient.dart';
import '../util/enum/current_screen.dart';
import '../util/shared.dart';
import '../widgets/ps_colum_header.dart';
import '../widgets/ps_header.dart';

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
  bool serverError = false;
  bool internetError = false;
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
    setState(() {
      loading = true;
      internetError = false;
      serverError = false;
    });

    try {
      bool __ = await Shared.checkConnectivity();

      var _ = await apiService
          .getPatientsFromSpecialist()
          .then((patientsResponse) async => {
                setState(() {
                  patients = patientsResponse;
                  totalPatients = patients.length;
                  loading = false;
                  serverError = false;
                  internetError = false;
                })
              });
    } on PsTokenException catch (e) {
      Shared.showPsDialog(context, DialogType.warning, e.message,
          "Volver al login", () => {Shared.logout(context)}, Icons.logout);
    } on PsException catch (e) {
      setState(() {
        loading = false;
        internetError = true;
        log(e.toString());
      });
    } catch (e) {
      setState(() {
        loading = false;
        serverError = true;
        log(e.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        SystemNavigator.pop();
      },
      child: Scaffold(
          appBar: const PsAppBar(
              title: 'PteriScope',
              titleSize: AppConstants.bigAppBarTitleSize,
              disabled: false),
          drawer: const PsMenuBar(currentView: CurrentScreen.patientList),
          body: Column(
            children: [
              PsHeader(
                title: 'Lista de pacientes',
                subtitle: 'Total de pacientes: ${totalPatients ?? 0}',
                buttonTitle: 'Nuevo paciente',
                action: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NewPatientScreen(),
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
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.padding),
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
                        : !internetError && !serverError
                            ? _buildPatientList()
                            : Center(
                                child: Padding(
                                padding: const EdgeInsetsDirectional.symmetric(
                                    horizontal: 5 * AppConstants.padding,
                                    vertical: AppConstants.padding),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Error al cargar los datos. ${internetError ? "Compruebe su conexión a Internet" : "Inténtelo más tarde, por favor"} ",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      ),
                                      const SizedBox(height: 20),
                                      PsElevatedButtonIcon(
                                          isPrimary: true,
                                          icon: Icons.refresh,
                                          text: "Reintentar",
                                          onTap: () {
                                            loadPatients();
                                          })
                                    ]),
                              ))),
              )
            ],
          )),
    );
  }

  Widget _buildPatientList() {
    return Column(
      children: [
        const PsColumnHeader(
          firstTitle: 'Datos del paciente',
          secondTitle: 'Última revisión',
          thirdTitle: 'Resultado',
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              loadPatients();
            },
            child: patients.isEmpty
                ? const Padding(
                    padding: EdgeInsets.only(
                        left: AppConstants.padding,
                        right: AppConstants.padding,
                        bottom: AppConstants.padding,
                        top: AppConstants.padding * 8),
                    child: Text(
                      "No existen pacientes registrados.\n\nPresione el botón “Nuevo paciente” para añadir uno",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filterPatients(patients, _searchController.text)
                        .length,
                    itemBuilder: (context, index) {
                      final patient = _filterPatients(
                          patients, _searchController.text)[index];

                      String? lastReviewDate = patient.lastReviewDate != null
                          ? DateFormat('dd/MM/yyyy')
                              .format(patient.lastReviewDate!)
                          : '-';

                      String? lastReviewResult =
                          patient.lastReviewResult ?? '-';

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
                            padding: const EdgeInsets.all(
                                AppConstants.padding / 2.0),
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
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        patient.email == ""
                                            ? "-"
                                            : patient.email,
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
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  )),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                      child: Text(
                                    lastReviewResult,
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Shared.getColorResult(
                                            lastReviewResult),
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

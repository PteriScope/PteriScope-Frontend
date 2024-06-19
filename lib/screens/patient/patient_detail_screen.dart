import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pteriscope_frontend/screens/patient/edit_patient_screen.dart';
import 'package:pteriscope_frontend/screens/review/camera_screen.dart';
import 'package:pteriscope_frontend/screens/review/review_detail_screen.dart';
import 'package:pteriscope_frontend/services/api_service.dart';
import 'package:pteriscope_frontend/util/enum/button_type.dart';
import 'package:pteriscope_frontend/util/enum/dialog_type.dart';
import 'package:pteriscope_frontend/util/enum/snack_bar_type.dart';
import 'package:pteriscope_frontend/widgets/ps_app_bar.dart';
import 'package:pteriscope_frontend/widgets/ps_colum_header.dart';
import 'package:pteriscope_frontend/widgets/ps_floating_button.dart';
import 'package:pteriscope_frontend/widgets/ps_header.dart';

import '../../models/patient.dart';
import '../../models/review.dart';
import '../../services/shared_preferences_service.dart';
import '../../util/constants.dart';
import '../../util/ps_exception.dart';
import '../../widgets/ps_elevated_button_icon.dart';
import '../../widgets/ps_menu_bar.dart';
import '../../util/enum/current_screen.dart';
import '../../util/shared.dart';
import '../home_screen.dart';

class PatientDetailScreen extends StatefulWidget {
  final Patient patient;

  const PatientDetailScreen({Key? key, required this.patient})
      : super(key: key);

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreen();
}

class _PatientDetailScreen extends State<PatientDetailScreen> {
  late Patient patient;
  List<Review> reviews = [];
  int? totalReviews;
  ApiService apiService = ApiService();
  bool loading = true;
  bool serverError = false;
  bool internetError = false;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    patient = widget.patient;
    loadReviews();
  }

  Future<void> loadReviews() async {
    setState(() {
      loading = true;
      serverError = false;
      internetError = false;
    });

    try {
      bool __ = await Shared.checkConnectivity();

      var _ = await apiService
          .getReviewsFromPatient(patient.id)
          .then((reviewsResponse) async => {
                setState(() {
                  reviews = reviewsResponse;
                  totalReviews = reviews.length;
                  loading = false;
                  serverError = false;
                  internetError = false;
                })
              });
    } on PsException catch (e) {
      setState(() {
        loading = false;
        internetError = true;
        serverError = false;
        log(e.toString());
      });
    } catch (e) {
      setState(() {
        loading = false;
        internetError = false;
        serverError = true;
        log(e.toString());
      });
    }
  }

  void goToCameraScreen() async {
    bool cameraAccessPermission = await Shared.checkCameraPermission();
    bool isFirstAccessPermission =
        SharedPreferencesService().isFirstAccessPermission();

    if (cameraAccessPermission || isFirstAccessPermission) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CameraScreen(patient: patient),
        ),
      );
    } else {
      Shared.showPsDialog(
          context,
          DialogType.error,
          "La aplicación no cuenta con acceso a la cámara del dispositivo",
          "Aceptar",
          () => {
                Navigator.of(context).pop(),
                Permission.camera.onGrantedCallback(() {
                  MaterialPageRoute(
                    builder: (context) => CameraScreen(patient: patient),
                  );
                }).onLimitedCallback(() {
                  MaterialPageRoute(
                    builder: (context) => CameraScreen(patient: patient),
                  );
                }).onProvisionalCallback(() {
                  MaterialPageRoute(
                    builder: (context) => CameraScreen(patient: patient),
                  );
                }).onProvisionalCallback(() {
                  MaterialPageRoute(
                    builder: (context) => CameraScreen(patient: patient),
                  );
                }).request()
              },
          Icons.check_circle,
          "Configuraciones", () async {
        if (await Permission.camera.isPermanentlyDenied) {
          openAppSettings();
        }
      }, Icons.settings);
    }
  }

  void goToEditPatientScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditPatientScreen(patient: widget.patient),
      ),
    );
  }

  void showAlertDialog() {
    Shared.showPsDialog(
        context,
        DialogType.warning,
        "¿Estás seguro que deseas eliminar este paciente?",
        "Eliminar",
        () => {_deletePatient(), Navigator.of(context).pop()},
        Icons.check_circle,
        "Cancelar",
        () => {Navigator.of(context).pop()},
        Icons.cancel);
  }

  Future<void> _deletePatient() async {
    if (internetError || serverError) {
      await loadReviews();
      if (internetError || serverError) {
        Shared.showPSSnackBar(
            context,
            internetError
                ? "Compruebe su conexión a Internet"
                : "Hubo un error al tratar de conectarse al servidor. Inténtelo más tarde, por favor",
            SnackBarType.onlyText,
            AppConstants.shortSnackBarDuration);
        return;
      }
    }

    setState(() {
      _isDeleting = true;
    });

    try {
      bool __ = await Shared.checkConnectivity();

      var apiService = Provider.of<ApiService>(context, listen: false);
      Shared.showPSSnackBar(context, 'Eliminando paciente...',
          SnackBarType.loading, AppConstants.longSnackBarDuration);

      await apiService.deletePatient(widget.patient.id);

      Shared.showPSSnackBar(context, 'Eliminación exitosa',
          SnackBarType.onlyText, AppConstants.shortSnackBarDuration);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } on PsException catch (e) {
      Shared.showPSSnackBar(context, 'Error: ${e.message}',
          SnackBarType.onlyText, AppConstants.shortSnackBarDuration);
    } on SocketException catch (_) {
      Shared.showPSSnackBar(
          context,
          'Hubo un error al tratar de conectarse al servidor. Inténtelo más tarde, por favor',
          SnackBarType.onlyText,
          AppConstants.shortSnackBarDuration);
    } catch (e) {
      Shared.showPSSnackBar(context, 'Eliminación fallida',
          SnackBarType.onlyText, AppConstants.shortSnackBarDuration);
    }
    setState(() {
      _isDeleting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      },
      child: Scaffold(
        appBar: PsAppBar(
            title: '${patient.firstName} ${patient.lastName}',
            titleSize: AppConstants.smallAppBarTitleSize,
            disabled: _isDeleting),
        drawer: const PsMenuBar(currentView: CurrentScreen.other),
        body: Column(
          children: [
            PsHeader(
              title: 'Revisiones',
              subtitle: 'Total de revisiones: ${totalReviews ?? 0}',
              //buttonTitle: 'Nueva revisión',
              //action: goToCameraScreen,
            ),
            const Padding(
                padding: EdgeInsets.only(
                    left: AppConstants.padding,
                    right: AppConstants.padding,
                    bottom: AppConstants.padding),
                child: Divider(thickness: 1.5)),
            Expanded(
                child: Stack(
              children: [
                Card(
                    child: loading
                        ? const Center(child: CircularProgressIndicator())
                        : !internetError && !serverError
                            ? _buildReviewList()
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
                                            loadReviews();
                                          })
                                    ]),
                              ))),
                Positioned(
                  bottom: 20.0,
                  left: 20.0,
                  right: 20.0,
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.padding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        PsFloatingButton(
                            heroTag: 'deletePatient',
                            buttonType: ButtonType.severe,
                            onTap: showAlertDialog,
                            iconData: Icons.delete,
                            disabled: false),
                        PsFloatingButton(
                            heroTag: 'editPatient',
                            buttonType: ButtonType.secondary,
                            onTap: goToEditPatientScreen,
                            iconData: Icons.edit,
                            disabled: false),
                        PsFloatingButton(
                            heroTag: 'backToHomeFromPatient',
                            buttonType: ButtonType.primary,
                            onTap: () => {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const HomeScreen(),
                                    ),
                                  )
                                },
                            iconData: Icons.arrow_back,
                            disabled: false),
                      ],
                    ),
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }

  Widget _buildReviewList() {
    return Column(
      children: [
        const PsColumnHeader(
          firstTitle: 'Imagen',
          secondTitle: 'Fecha',
          thirdTitle: 'Resultado',
        ),
        Expanded(
            child: RefreshIndicator(
          onRefresh: () async {
            loadReviews();
          },
          child: reviews.isEmpty
              ? const Padding(
                  padding: EdgeInsets.only(
                      left: AppConstants.padding,
                      right: AppConstants.padding,
                      bottom: AppConstants.padding,
                      top: AppConstants.padding * 8),
                  child: Text(
                    "Este paciente aún no cuenta con revisiones.\n\nPresione el botón “Nueva revisión” para añadir una",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  // TODO: Retrieve only an initial amount an get on demand when scrolling
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];

                    String reviewDate =
                        DateFormat('dd/MM/yyyy').format(review.reviewDate!);

                    String reviewResult = review.reviewResult!;

                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ReviewDetailScreen(
                                review: review, patient: patient),
                          ),
                        );
                      },
                      child: Card(
                        child: Padding(
                          padding:
                              const EdgeInsets.all(AppConstants.padding / 2.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: review.imageBase64!.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.memory(
                                              base64Decode(review.imageBase64!),
                                              fit: BoxFit.cover,
                                              height: 125.0,
                                              width: 125.0,
                                            ),
                                          )
                                        : const SizedBox(
                                            height: 100.0,
                                            width: 100.0,
                                            child: Icon(
                                              Icons.image,
                                              size: 60,
                                            ),
                                          ),
                                  )),
                              Expanded(
                                flex: 1,
                                child: Center(
                                    child: Text(
                                  reviewDate,
                                  style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                              Expanded(
                                flex: 1,
                                child: Center(
                                    child: Text(
                                  reviewResult,
                                  style: TextStyle(
                                      fontSize: 10,
                                      color:
                                          Shared.getColorResult(reviewResult),
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
        ))
      ],
    );
  }
}

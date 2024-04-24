import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pteriscope_frontend/models/patient.dart';
import 'package:pteriscope_frontend/models/specialist.dart';
import 'package:pteriscope_frontend/services/shared_preferences_service.dart';
import 'package:pteriscope_frontend/widgets/ps_app_bar.dart';

import '../../models/review.dart';
import '../../services/api_service.dart';
import '../../util/advice.dart';
import '../../util/constants.dart';
import '../../util/enum/button_type.dart';
import '../../util/enum/current_screen.dart';
import '../../util/enum/dialog_type.dart';
import '../../util/enum/snack_bar_type.dart';
import '../../util/ps_exception.dart';
import '../../util/shared.dart';
import '../../widgets/ps_advice_dialog.dart';
import '../../widgets/ps_column_text.dart';
import '../../widgets/ps_elevated_button_icon.dart';
import '../../widgets/ps_floating_button.dart';
import '../../widgets/ps_menu_bar.dart';
import '../patient/patient_detail_screen.dart';

class ReviewDetailScreen extends StatefulWidget {
  final Review review;
  final Patient patient;

  const ReviewDetailScreen(
      {Key? key, required this.review, required this.patient})
      : super(key: key);

  @override
  State<ReviewDetailScreen> createState() => _ReviewDetailScreenState();
}

class _ReviewDetailScreenState extends State<ReviewDetailScreen> {
  Specialist? specialist;
  ApiService apiService = ApiService();
  bool serverError = false;
  bool internetError = false;
  bool _isDeleting = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    initializeSpecialist();
  }

  Future<void> initializeSpecialist() async {
    setState(() {
      loading = true;
      internetError = false;
      serverError = false;
    });

    try {
      bool __ = await Shared.checkConnectivity();

      final specialistId = SharedPreferencesService().getId();
      await apiService.getSpecialist(specialistId!).then((value) => {
            setState(() {
              specialist = value;
              loading = false;
              internetError = false;
              serverError = false;
            })
          });
    } on PsException catch (_) {
      setState(() {
        loading = false;
        internetError = true;
      });
    } catch (e) {
      setState(() {
        loading = false;
        serverError = true;
      });
    }
  }

  void showAlertDialog() {
    Shared.showPsDialog(
        context,
        DialogType.warning,
        "¿Estás seguro que deseas eliminar esta revisión?",
        "Eliminar",
        () => {_deleteReview(), Navigator.of(context).pop()},
        Icons.check_circle,
        "Cancelar",
        () => {Navigator.of(context).pop()},
        Icons.cancel);
  }

  Future<void> _deleteReview() async {
    if (internetError || serverError) {
      await initializeSpecialist();
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
      Shared.showPSSnackBar(
          context,
          //TODO: CHECK WITH EXCEL
          'Eliminando revisión...',
          SnackBarType.loading,
          AppConstants.longSnackBarDuration);

      await apiService.deleteReview(widget.review.id!);

      Shared.showPSSnackBar(context, 'Eliminación exitosa',
          SnackBarType.onlyText, AppConstants.shortSnackBarDuration);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PatientDetailScreen(patient: widget.patient),
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

  void viewAdvices() {
    List<Advice> advices = [];

    if (widget.review.reviewResult == AppConstants.noPterygium) {
      advices = [
        Advice(adviceMessage: AppConstants.noPterygiumAdvice1),
        Advice(adviceMessage: AppConstants.noPterygiumAdvice2),
        Advice(adviceMessage: AppConstants.noPterygiumAdvice3),
        Advice(adviceMessage: AppConstants.noPterygiumAdvice4),
      ];
    } else if (widget.review.reviewResult == AppConstants.mildPterygium) {
      advices = [
        Advice(adviceMessage: AppConstants.mildPterygiumAdvice1),
        Advice(adviceMessage: AppConstants.mildPterygiumAdvice2),
        Advice(adviceMessage: AppConstants.mildPterygiumAdvice3),
        Advice(adviceMessage: AppConstants.mildPterygiumAdvice4),
        Advice(adviceMessage: AppConstants.mildPterygiumAdvice5),
      ];
    } else if (widget.review.reviewResult == AppConstants.severePterygium) {
      advices = [
        Advice(adviceMessage: AppConstants.severePterygiumAdvice1),
        Advice(adviceMessage: AppConstants.severePterygiumAdvice2),
        Advice(adviceMessage: AppConstants.severePterygiumAdvice3),
        Advice(adviceMessage: AppConstants.severePterygiumAdvice4),
      ];
    }

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return PsAdviceDialog(advices: advices, isResultAdvice: true);
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PatientDetailScreen(patient: widget.patient),
          ),
        );
      },
      child: Scaffold(
        appBar: PsAppBar(
            title: '${widget.patient.firstName} ${widget.patient.lastName}',
            titleSize: AppConstants.smallAppBarTitleSize,
            disabled: _isDeleting),
        drawer: const PsMenuBar(currentView: CurrentScreen.other),
        body: Stack(children: [
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(AppConstants.padding / 2.0),
                  child: Image.memory(
                    base64Decode(widget.review.imageBase64!),
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                const SizedBox(height: AppConstants.padding * 2.0),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.padding),
                    child: Column(
                      children: [
                        Table(
                          children: [
                            TableRow(children: [
                              const PsColumnText(
                                  text: "Nombre del paciente: ", isBold: true),
                              PsColumnText(
                                  text:
                                      "${widget.patient.firstName}-${widget.patient.lastName}",
                                  isBold: false),
                            ]),
                            TableRow(children: [
                              const PsColumnText(
                                  text: "Fecha de la revisión: ", isBold: true),
                              PsColumnText(
                                  text: "${widget.review.reviewDate!}",
                                  isBold: false,
                                  isDate: true),
                            ]),
                            TableRow(children: [
                              const PsColumnText(
                                  text: "Resultado de la revisión: ",
                                  isBold: true),
                              PsColumnText(
                                  text: widget.review.reviewResult!,
                                  isBold: false,
                                  isResult: true),
                            ]),
                            TableRow(children: [
                              const PsColumnText(
                                  text: "Encargado de la revisión: ",
                                  isBold: true),
                              PsColumnText(
                                  text: specialist == null
                                      ? "-"
                                      : specialist!.name,
                                  isBold: false),
                            ]),
                          ],
                        ),
                        const SizedBox(height: AppConstants.padding * 2),
                        PsElevatedButtonIcon(
                            isPrimary: true,
                            icon: Icons.health_and_safety_sharp,
                            text: "Sugerencias",
                            onTap: viewAdvices),
                        if (loading)
                          const Center(child: CircularProgressIndicator())
                        else if (internetError || serverError)
                          Center(
                              child: Padding(
                            padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: 5 * AppConstants.padding,
                                vertical: AppConstants.padding),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Error al cargar los datos: ${internetError ? "Compruebe su conexión a Internet" : "Inténtelo más tarde, por favor"} ",
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
                                        initializeSpecialist();
                                      })
                                ]),
                          ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
                      heroTag: 'deleteReview',
                      buttonType: ButtonType.severe,
                      onTap: showAlertDialog,
                      iconData: Icons.delete,
                      disabled: false),
                  PsFloatingButton(
                      heroTag: 'sendEmail',
                      buttonType: ButtonType.secondary,
                      onTap: () => {
                            //TODO: Implement functionality
                          },
                      iconData: Icons.email_outlined),
                  PsFloatingButton(
                      heroTag: 'backToPatient',
                      buttonType: ButtonType.primary,
                      onTap: () => {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PatientDetailScreen(
                                    patient: widget.patient),
                              ),
                            )
                          },
                      iconData: Icons.arrow_back),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

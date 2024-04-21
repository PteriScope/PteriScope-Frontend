import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pteriscope_frontend/models/patient.dart';
import 'package:pteriscope_frontend/models/specialist.dart';
import 'package:pteriscope_frontend/services/shared_preferences_service.dart';
import 'package:pteriscope_frontend/widgets/ps_app_bar.dart';

import '../../models/review.dart';
import '../../services/api_service.dart';
import '../../util/constants.dart';
import '../../util/enum/button_type.dart';
import '../../util/enum/current_screen.dart';
import '../../util/shared.dart';
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

  @override
  void initState() {
    super.initState();
    initializeSpecialist();
  }

  Future<void> initializeSpecialist() async {
    final specialistId = SharedPreferencesService().getId();
    await apiService.getSpecialist(specialistId!).then((value) => {
          setState(() {
            specialist = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PsAppBar(
          title: '${widget.patient.firstName} ${widget.patient.lastName}',
          titleSize: AppConstants.smallAppBarTitleSize,
          disabled: false),
      drawer: const PsMenuBar(currentView: CurrentScreen.other),
      body: Stack(children: [
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.padding / 2.0),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: AppConstants.padding / 4),
                            child: Text(
                              "Nombre del paciente: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: AppConstants.padding / 4),
                            child: Text(
                              "Fecha de la revisión: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: AppConstants.padding / 4),
                            child: Text(
                              "Resultado de la revisión: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: AppConstants.padding / 4),
                            child: Text(
                              "Encargado de la revisión: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: AppConstants.padding / 4),
                            child: Text(
                                "${widget.patient.firstName} ${widget.patient.lastName}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: AppConstants.padding / 4),
                            child: Text(DateFormat('dd/MM/yyyy')
                                .format(widget.review.reviewDate!)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: AppConstants.padding / 4),
                            child: Text(
                              widget.review.reviewResult!,
                              style: TextStyle(
                                  color: Shared.getColorResult(
                                      widget.review.reviewResult!),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: AppConstants.padding / 4),
                            child: Text(
                              specialist == null ? "-" : specialist!.name,
                            ),
                          ),
                        ],
                      )
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
                              builder: (context) =>
                                  PatientDetailScreen(patient: widget.patient),
                            ),
                          )
                        },
                    iconData: Icons.arrow_back),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pteriscope_frontend/screens/review/camera_screen.dart';
import 'package:pteriscope_frontend/screens/review/review_detail_screen.dart';
import 'package:pteriscope_frontend/services/api_service.dart';
import 'package:pteriscope_frontend/widgets/ps_app_bar.dart';
import 'package:pteriscope_frontend/widgets/ps_colum_header.dart';
import 'package:pteriscope_frontend/widgets/ps_header.dart';

import '../../models/patient.dart';
import '../../models/review.dart';
import '../../util/constants.dart';
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
  bool error = false;

  @override
  void initState() {
    super.initState();
    patient = widget.patient;
    loadReviews();
  }

  void loadReviews() async {
    try {
      var _ = await apiService
          .getReviewsFromPatient(patient.id)
          .then((reviewsResponse) async => {
                setState(() {
                  reviews = reviewsResponse;
                  totalReviews = reviews.length;
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
      appBar:
          PsAppBar(title: '${patient.firstName} ${patient.lastName}', titleSize: AppConstants.smallAppBarTitleSize,),
      drawer: const PsMenuBar(currentView: CurrentScreen.other),
      body: Column(
        children: [
          PsHeader(
            title: 'Revisiones',
            subtitle: 'Total de revisiones: ${totalReviews ?? 0}',
            buttonTitle: 'Nueva revisión',
            action: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CameraScreen(patient: patient),
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
          Expanded(
              child: Stack(
            children: [
              Card(
                  child: loading
                      ? const Center(child: CircularProgressIndicator())
                      : error == true
                          ? const Center(
                              child: Text("Error al cargar los datos"))
                          : _buildReviewList()),
              Positioned(
                bottom: 20.0,
                left: 20.0,
                right: 20.0,
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.padding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //TODO: Implement functionality
                      FloatingActionButton(
                        heroTag: 'sendEmail',
                        backgroundColor: AppConstants.severeColor,
                        onPressed: () => {},
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      FloatingActionButton(
                        heroTag: 'backToPatient',
                        backgroundColor: AppConstants.primaryColor,
                        onPressed: () => {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          )
                        },
                        child:
                            const Icon(Icons.arrow_back, color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ))
        ],
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
                setState(() {
                  loading = true;
                });
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
                  "Este paciente aún no cuenta con revisiones.\n\nPresiona el botón “Nueva revisión” para añadir una",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              )
              : ListView.builder(
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
                        padding: const EdgeInsets.all(AppConstants.padding / 2.0),
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
                                    fontSize: 10, fontWeight: FontWeight.bold),
                              )),
                            ),
                            Expanded(
                              flex: 1,
                              child: Center(
                                  child: Text(
                                reviewResult,
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Shared.getColorResult(reviewResult),
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

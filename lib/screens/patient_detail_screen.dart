import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pteriscope_frontend/screens/camera_screen.dart';
import 'package:pteriscope_frontend/screens/review_detail.dart';
import 'package:pteriscope_frontend/services/api_service.dart';

import '../models/patient.dart';
import '../models/review.dart';
import '../util/constants.dart';
import '../util/shared.dart';

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
      // TODO: Turn to Widget
      appBar: AppBar(
        title: Text(
          '${patient.firstName} ${patient.lastName}',
          style: const TextStyle(
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
          // TODO: Turn to Widget from here
          Padding(
            padding: const EdgeInsets.all(AppConstants.padding),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Revisiones',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        'Total de revisiones: ${totalReviews ?? 0}',
                        style:
                            const TextStyle(fontSize: 15, color: Colors.white),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              CameraScreen(patient: patient)
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Nueva revisión'),
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
          // TODO: Until here

          Expanded(
              child: Card(
                  child: loading
                      ? const Center(child: CircularProgressIndicator())
                      : error == true
                          ? const Center(
                              child: Text("Error al cargar los datos"))
                                      // TODO: Button to recharge
                          : Column(
                              children: [
                                // TODO: Turn to widget
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
                                            'Imagen',
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
                                            'Fecha',
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
                                        itemCount: reviews.length,
                                        itemBuilder: (context, index) {
                                          final review = reviews[index];

                                          String reviewDate =
                                              DateFormat('dd/MM/yyyy')
                                                  .format(review.reviewDate!);

                                          String reviewResult =
                                              review.reviewResult!;

                                          return InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ReviewDetailScreen(
                                                          review: review,
                                                          patient: patient
                                                      ),
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
                                                        child: Center(
                                                          child: review
                                                                  .imageBase64!
                                                                  .isNotEmpty
                                                              ? ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  child: Image
                                                                      .memory(
                                                                    base64Decode(
                                                                        review
                                                                            .imageBase64!),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    height:
                                                                        100.0,
                                                                    width:
                                                                        100.0,
                                                                  ),
                                                                )
                                                              : const SizedBox(
                                                                  height:
                                                                      100.0,
                                                                  width:
                                                                      100.0,
                                                                  child: Icon(
                                                                    Icons
                                                                        .image,
                                                                    size:
                                                                        60,
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
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Center(
                                                          child: Text(
                                                        reviewResult,
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: Shared
                                                                .getColorResult(
                                                                    reviewResult),
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }))
                              ],
                            )))
        ],
      ),
    );
  }
}

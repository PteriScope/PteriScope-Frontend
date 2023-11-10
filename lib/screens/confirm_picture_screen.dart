import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pteriscope_frontend/screens/review_detail.dart';

import '../models/review.dart';
import '../services/api_service.dart';

class ConfirmPictureScreen extends StatelessWidget {
  final String imageBase64;
  final int patientId;

  const ConfirmPictureScreen({
    Key? key,
    required this.imageBase64,
    required this.patientId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Transform.scale(
            scale: 1,
            child: Center(
              child: Image.memory(base64Decode(imageBase64)),
            ),
          ),

          Positioned(
            bottom: 40.0,
            left: 20.0,
            right: 20.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FloatingActionButton(
                  heroTag: 'retake',
                  backgroundColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                FloatingActionButton(
                  heroTag: 'takePicture',
                  backgroundColor: Colors.white,
                  onPressed: () => {
                    // Confirmar y subir la imagen, luego mostrar el procesamiento
                    uploadPicture(context)
                  },
                  child: const Icon(Icons.check, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> uploadPicture(BuildContext context) async {
    try {
      log("=========uploadPicture==========");
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Se está procesando su imagen.\nEspere un momento por favor'),
                CircularProgressIndicator(),
              ],
            ),
          ),
        );

      log("=========before call==========");
      // Llama al ApiService para crear la revisión
      String reviewResponse = await Provider.of<ApiService>(context, listen: false)
          .createReview(patientId, {'imageBase64': imageBase64});

      log("=========response==========");
      // Parsea la respuesta y obtén el ID de la revisión
      final reviewData = jsonDecode(reviewResponse);
      Review review = Review.fromJson(reviewData);

      log("=========hide==========");
      // Oculta el SnackBar actual
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      log("=========moving to ReviewDetailScreen==========");
      // Navega a la pantalla de detalles de la revisión
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReviewDetailScreen(review: review),
        ),
      );
    } catch (e) {
      // Oculta el SnackBar actual y muestra un mensaje de error
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Error al crear la revisión: $e'),
          ),
        );
    }
  }
}

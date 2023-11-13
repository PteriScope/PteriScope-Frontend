import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pteriscope_frontend/screens/review_detail.dart';

import '../models/patient.dart';
import '../models/review.dart';
import '../services/api_service.dart';

class ConfirmPictureScreen extends StatefulWidget {
  final String imageBase64;
  final Patient patient;

  const ConfirmPictureScreen({
    Key? key,
    required this.imageBase64,
    required this.patient,
  }) : super(key: key);

  @override
  State<ConfirmPictureScreen> createState() => _ConfirmPictureScreenState();
}

class _ConfirmPictureScreenState extends State<ConfirmPictureScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Transform.scale(
            scale: 1,
            child: Center(
              child: Image.memory(base64Decode(widget.imageBase64)),
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 24),
                Expanded(child: Text('Se está procesando su imagen.\nEspere un momento...')),
              ],
            ),
          ),
        );
      },
    );

    try {
      String reviewResponse = await Provider.of<ApiService>(context, listen: false)
          .createReview(widget.patient.id, {'imageBase64': widget.imageBase64});

      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // Usa rootNavigator para cerrar el diálogo
        final reviewData = jsonDecode(reviewResponse);
        Review review = Review.fromJson(reviewData);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ReviewDetailScreen(
                review: review,
                patient: widget.patient,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // Cierra el diálogo

        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('Error al crear la revisión: $e'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cerrar'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }
}

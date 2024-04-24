import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pteriscope_frontend/screens/review/camera_screen.dart';
import 'package:pteriscope_frontend/screens/review/review_detail_screen.dart';
import 'package:pteriscope_frontend/util/enum/dialog_type.dart';
import 'package:pteriscope_frontend/widgets/ps_floating_button.dart';

import '../../../models/patient.dart';
import '../../../models/review.dart';
import '../../../services/api_service.dart';
import '../../util/enum/button_type.dart';
import '../../util/ps_exception.dart';
import '../../util/shared.dart';

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
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CameraScreen(patient: widget.patient),
          ),
        );
      },
      child: Scaffold(
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
                  PsFloatingButton(
                      heroTag: 'retake',
                      buttonType: ButtonType.neutral,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      iconData: Icons.arrow_back),
                  PsFloatingButton(
                      heroTag: 'loadPicture',
                      buttonType: ButtonType.neutral,
                      onTap: () => {uploadPicture(context)},
                      iconData: Icons.check),
                ],
              ),
            ),
          ],
        ),
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
                Expanded(
                    child: Text(
                        'Se está procesando su imagen.\nEspere un momento...')),
              ],
            ),
          ),
        );
      },
    );

    try {
      bool _ = await Shared.checkConnectivity();

      Review reviewResponse =
          await Provider.of<ApiService>(context, listen: false).createReview(
              widget.patient.id, {'imageBase64': widget.imageBase64});

      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ReviewDetailScreen(
              review: reviewResponse,
              patient: widget.patient,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();

        Shared.showPsDialog(
            context,
            DialogType.error,
            'Error al crear la revisión: ${e is PsException ? e.message : "Inténtelo más tarde, por favor"}',
            'Cerrar',
                () => {Navigator.of(context).pop()},
            Icons.close
        );
      }
    }
  }
}

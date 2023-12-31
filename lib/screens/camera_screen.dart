import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;

import '../models/patient.dart';
import 'confirm_picture_screen.dart';

class CameraScreen extends StatefulWidget {
  final Patient patient;

  const CameraScreen({Key? key, required this.patient}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  late int _selectedCameraIdx;
  FlashMode _flashMode = FlashMode.off;
  double _currentZoomLevel = 1.0;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 3.0;
  img.Image? originalImage;
  late img.Image rotatedImage;
  late String base64Image;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras!.isNotEmpty) {
      setState(() {
        _selectedCameraIdx = 0;
      });

      _controller = CameraController(
        _cameras![_selectedCameraIdx],
        ResolutionPreset.max,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await _controller!.initialize();
      _minAvailableZoom = await _controller!.getMinZoomLevel();
      _maxAvailableZoom = await _controller!.getMaxZoomLevel();

      if (!mounted) {
        return;
      }

      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _onCapturePressed(context) async {
    try {
      if (!_controller!.value.isInitialized) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error: la cámara no está lista aún")),
        );
        return;
      }

      await _controller!.takePicture().then((image) async => {
        await image.readAsBytes().then((imageBytes) => {
          setState(() {
            originalImage = img.decodeImage(imageBytes);
            rotatedImage = img.copyRotate(originalImage!, angle: 270);
            base64Image = base64Encode(img.encodeJpg(rotatedImage));
          })
        }),
      });

      if (_flashMode == FlashMode.torch) {
        _controller!.setFlashMode(FlashMode.off);
        setState(() {
          _flashMode = FlashMode.off;
        });
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmPictureScreen(
            imageBase64: base64Image,
            patient: widget.patient,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al capturar la imagen: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Transform.scale(
            scale: 1,
            child: Center(
              child: CameraPreview(_controller!),
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
                  heroTag: 'closeCamera',
                  backgroundColor: Colors.white,
                  onPressed: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Colors.black),
                ),
                FloatingActionButton(
                  heroTag: 'takePicture',
                  backgroundColor: Colors.white,
                  onPressed: () => _onCapturePressed(context),
                  child: const Icon(Icons.camera, color: Colors.black),
                ),
                FloatingActionButton(
                  heroTag: 'enableDisableFlash',
                  backgroundColor: Colors.white,
                  onPressed: () {
                    if (_flashMode == FlashMode.off) {
                      _controller!.setFlashMode(FlashMode.torch);
                      setState(() {
                        _flashMode = FlashMode.torch;
                      });
                    } else {
                      _controller!.setFlashMode(FlashMode.off);
                      setState(() {
                        _flashMode = FlashMode.off;
                      });
                    }
                  },
                  child: Icon(
                    _flashMode == FlashMode.off ? Icons.flash_off : Icons.flash_on,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 120.0,
            left: 20.0,
            right: 20.0,
            child: Slider(
              value: _currentZoomLevel,
              min: _minAvailableZoom,
              max: _maxAvailableZoom,
              onChanged: (newZoomLevel) {
                setState(() {
                  _currentZoomLevel = newZoomLevel;
                });
                _controller!.setZoomLevel(_currentZoomLevel);
              },
            ),
          ),
        ],
      ),
    );
  }
}
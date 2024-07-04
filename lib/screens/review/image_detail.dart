import 'dart:convert';

import 'package:flutter/material.dart';

class ImageDetail extends StatelessWidget {
  final String tag;
  final String imageBase64;

  const ImageDetail({
    required this.tag,
    required this.imageBase64,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: tag,
            child: InteractiveViewer(
              minScale: 1.0,
              maxScale: 4.0,
              child: RotatedBox(
                quarterTurns: 1,
                child: Container(
                  width: MediaQuery.of(context).size.height * 0.90,
                  height: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: MemoryImage(base64Decode(imageBase64)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
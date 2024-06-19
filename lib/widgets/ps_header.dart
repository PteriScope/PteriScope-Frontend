import 'package:flutter/material.dart';
import 'package:pteriscope_frontend/util/constants.dart';

class PsHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const PsHeader({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(right: AppConstants.padding, left: AppConstants.padding, bottom: AppConstants.padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize:
                      screenWidth * 22 / AppConstants.referenceDeviceWidth,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.start,
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

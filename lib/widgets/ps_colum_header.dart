import 'package:flutter/material.dart';
import 'package:pteriscope_frontend/util/constants.dart';

class PsColumnHeader extends StatelessWidget {
  final String firstTitle;
  final String secondTitle;
  final String thirdTitle;

  const PsColumnHeader({
    Key? key,
    required this.firstTitle,
    required this.secondTitle,
    required this.thirdTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppConstants.padding / 2.0,
        right: AppConstants.padding / 2.0,
        bottom: AppConstants.padding / 2.0,
        top: AppConstants.padding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                firstTitle,
                style: const TextStyle(
                  color: Color(0xFF838793),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Center(
              child: Text(
                secondTitle,
                style: const TextStyle(
                  color: Color(0xFF838793),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Center(
              child: Text(
                thirdTitle,
                style: const TextStyle(
                  color: Color(0xFF838793),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

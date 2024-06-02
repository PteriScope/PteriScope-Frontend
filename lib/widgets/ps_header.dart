import 'package:flutter/material.dart';
import 'package:pteriscope_frontend/util/constants.dart';
import 'package:pteriscope_frontend/widgets/ps_elevated_button_icon.dart';

class PsHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonTitle;
  final VoidCallback action;

  const PsHeader({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.buttonTitle,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(AppConstants.padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
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
          PsElevatedButtonIcon(
              isPrimary: false,
              icon: Icons.add,
              text: buttonTitle,
              onTap: action)
        ],
      ),
    );
  }
}

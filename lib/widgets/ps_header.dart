import 'package:flutter/material.dart';
import 'package:pteriscope_frontend/util/constants.dart';

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
    return Padding(
      padding: const EdgeInsets.all(AppConstants.padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
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
          ElevatedButton.icon(
            onPressed: action,
            icon: const Icon(Icons.add),
            label: Text(buttonTitle),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

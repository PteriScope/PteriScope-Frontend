import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pteriscope_frontend/widgets/ps_column_text.dart';

import '../util/constants.dart';
import '../util/shared.dart';

class PsItemCard extends StatelessWidget {
  final String patientName;
  final String base64Image;
  final String lastReviewDate;
  final String reviewDate;
  final String result;

  const PsItemCard(
      {Key? key,
      this.patientName = "",
      this.base64Image = "",
      this.lastReviewDate = "",
      this.reviewDate = "",
      required this.result})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.padding / 1.5),
      child: Card(
        margin: EdgeInsets.zero,
          child: Row(
        children: [
          if (base64Image.isNotEmpty)
            Center(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                ),
                child: Image.memory(
                  base64Decode(base64Image),
                  fit: BoxFit.cover,
                  height: 125.0,
                  width: 125.0,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(AppConstants.padding / 1.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (patientName.isNotEmpty)
                  PsColumnText(
                    text: patientName,
                    isBold: true,
                    isLong: true,
                  ),
                if (lastReviewDate.isNotEmpty)
                  Text(
                    'Última revisión: $lastReviewDate',
                    style: const TextStyle(
                      color: Color(0xFF838793),
                      fontSize: 15,
                    ),
                  ),
                if (reviewDate.isNotEmpty)
                  Row(
                    children: [
                      const Text(
                        'Fecha: ',
                        style: TextStyle(
                          color: Color(0xFF838793),
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        reviewDate,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                if (reviewDate.isNotEmpty)
                  const SizedBox(
                    height: 10,
                  ),
                Row(
                  children: [
                    const Text(
                      'Resultado: ',
                      style: TextStyle(
                        color: Color(0xFF838793),
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      result,
                      style: TextStyle(
                        color: Shared.getColorResult(result),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pteriscope_frontend/util/enum/ps_font_type.dart';
import 'package:pteriscope_frontend/util/enum/ps_font_weight.dart';
import 'package:pteriscope_frontend/widgets/ps_column_text.dart';

import '../util/constants.dart';
import '../util/enum/ps_container_size.dart';
import '../util/shared.dart';

class PsItemCard extends StatelessWidget {
  final String patientName;
  final String base64Image;
  final String lastReviewDate;
  final String reviewDate;
  final String result;
  final String imageTag;

  const PsItemCard(
      {Key? key,
      this.patientName = "",
      this.base64Image = "",
      this.lastReviewDate = "",
      this.reviewDate = "",
      required this.result,
      this.imageTag = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.padding / 1.5),
      child: Card(
          margin: EdgeInsets.zero,
          color: const Color(0xFFFAFAFA),
          elevation: 0,
          child: Row(
            children: [
              if (base64Image.isNotEmpty)
                Center(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                    ),
                    child: Hero(
                      tag: imageTag,
                      child: Image.memory(
                        base64Decode(base64Image),
                        fit: BoxFit.cover,
                        height: 125.0,
                        width: 125.0,
                      ),
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
                        size: PsContainerSize.long,
                      ),
                    if (lastReviewDate.isNotEmpty)
                      Text(
                        'Última revisión: $lastReviewDate',
                        style: TextStyle(
                          color: AppConstants.greyColor,
                          fontSize: Shared.psFontSize(
                              16, PsFontType.sfProText, PsFontWeight.medium),
                        ),
                      ),
                    if (reviewDate.isNotEmpty)
                      Row(
                        children: [
                          Text(
                            'Fecha: ',
                            style: TextStyle(
                              color: AppConstants.greyColor,
                              fontSize: Shared.psFontSize(16,
                                  PsFontType.sfProText, PsFontWeight.medium),
                            ),
                          ),
                          Text(
                            reviewDate,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: Shared.psFontSize(16,
                                  PsFontType.sfProText, PsFontWeight.medium),
                            ),
                          ),
                        ],
                      ),
                    if (reviewDate.isNotEmpty)
                      const SizedBox(
                        height: 2.5,
                      ),
                    Row(
                      children: [
                        Text(
                          'Resultado: ',
                          style: TextStyle(
                            color: AppConstants.greyColor,
                            fontSize: Shared.psFontSize(
                                16, PsFontType.sfProText, PsFontWeight.medium),
                          ),
                        ),
                        Text(
                          result,
                          style: TextStyle(
                            color: Shared.getColorResult(result),
                            fontWeight: result != "-" ? FontWeight.w600 : FontWeight.normal,
                            fontSize: Shared.psFontSize(16,
                                PsFontType.sfProText, PsFontWeight.semibold),
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

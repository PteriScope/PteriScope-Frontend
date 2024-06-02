import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../util/constants.dart';
import '../util/shared.dart';

class PsColumnText extends StatelessWidget {
  final String text;
  final bool isBold;
  final bool isDate;
  final bool isResult;

  const PsColumnText({
    super.key,
    required this.text,
    required this.isBold,
    this.isDate = false,
    this.isResult = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.padding / 4),
      width: MediaQuery.of(context).size.width * 0.49,
      child: Text(
        !isDate
            ? text
            : DateFormat('dd/MM/yyyy').format(DateTime.tryParse(text)!),
        style: (isBold || isResult)
            ? TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width *
                    14 /
                    AppConstants.referenceDeviceWidth,
                color: isResult ? Shared.getColorResult(text) : null)
            : null,
      ),
    );
  }
}

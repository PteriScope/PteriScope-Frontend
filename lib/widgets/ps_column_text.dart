import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:pteriscope_frontend/util/enum/ps_container_size.dart';
import 'package:pteriscope_frontend/util/enum/ps_font_type.dart';
import 'package:pteriscope_frontend/util/enum/ps_font_weight.dart';

import '../util/shared.dart';

class PsColumnText extends StatelessWidget {
  final String text;
  final bool isBold;
  final bool isDate;
  final bool isResult;
  final PsContainerSize size;
  final double bottomPadding;

  const PsColumnText({
    super.key,
    required this.text,
    required this.isBold,
    this.isDate = false,
    this.isResult = false,
    this.size = PsContainerSize.short,
    this.bottomPadding = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.only(bottom: bottomPadding),
      width: MediaQuery.of(context).size.width * factorSize(size),
      child: Text(
        !isDate
            ? text
            : DateFormat('dd/MM/yyyy').format(DateTime.tryParse(text)!),
        style: (isBold || isResult)
            ? TextStyle(
                fontWeight: FontWeight.bold,
                fontSize:
                    Shared.psFontSize(
                        16, PsFontType.roboto, PsFontWeight.semibold),
                color: isResult ? Shared.getColorResult(text) : null)
            : TextStyle(
                fontSize: Shared.psFontSize(
                    16, PsFontType.roboto, PsFontWeight.semibold),
              ),
      ),
    );
  }

  double factorSize(PsContainerSize psContainerSize) {
    switch (psContainerSize) {
      case PsContainerSize.short:
        return 0.49;
      case PsContainerSize.long:
        return 0.8;
      case PsContainerSize.full:
        return 1;
    }
  }
}

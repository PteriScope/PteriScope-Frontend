import 'package:flutter/cupertino.dart';

import '../util/constants.dart';

class PsColumnText extends StatelessWidget {
  final String text;
  final bool isBold;

  const PsColumnText({
    super.key,
    required this.text,
    required this.isBold,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: AppConstants.padding / 4),
      width: MediaQuery.of(context).size.width*0.49,
      child: Text(
        text,
        style: isBold ? const TextStyle(fontWeight: FontWeight.bold) : null,
      ),
    );
  }
}
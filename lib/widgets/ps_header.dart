import 'package:flutter/material.dart';
import 'package:pteriscope_frontend/util/constants.dart';
import 'package:pteriscope_frontend/util/enum/ps_font_weight.dart';

import '../util/enum/ps_font_type.dart';
import '../util/shared.dart';

class PsHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool hasBack;
  final StatefulWidget? widgetToBack;

  const PsHeader(
      {Key? key,
      required this.title,
      this.subtitle = "",
      this.hasBack = false,
      this.widgetToBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(
          right: AppConstants.padding,
          left: hasBack ? AppConstants.padding / 2.5 : AppConstants.padding,
          bottom: AppConstants.padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (hasBack)
            Center(
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () => {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => widgetToBack!,
                    ),
                  )
                },
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TODO: Generalizar con PsColumnText
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.padding / 4),
                width: MediaQuery.of(context).size.width * 0.75,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: Shared.psFontSize(
                        18, PsFontType.roboto, PsFontWeight.semibold),
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: Shared.psFontSize(
                        16, PsFontType.sfProText, PsFontWeight.medium),
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

import 'package:flutter/material.dart';

import '../util/constants.dart';

class PsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double titleSize;
  final bool disabled;

  const PsAppBar(
      {super.key, this.title = "", this.titleSize = 0, required this.disabled});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu),
        color: Colors.white,
        onPressed: () {
          if (!disabled) {
            Scaffold.of(context).openDrawer();
          }
        },
      ),
      backgroundColor: AppConstants.primaryColor,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../util/constants.dart';

class PsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double titleSize;
  final bool disabled;

  const PsAppBar(
      {super.key,
      required this.title,
      required this.titleSize,
      required this.disabled});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
            fontSize: titleSize,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
      leading: IconButton(
        icon: const Icon(Icons.menu),
        color: Colors.white,
        onPressed: () {
          if (!disabled) {
            Scaffold.of(context).openDrawer();
          }
        },
      ),
      actions: [
        InkWell(
          onTap: () {
            if (!disabled) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            }
          },
          child: const Padding(
            padding: EdgeInsets.only(right: AppConstants.padding),
            child: Image(
              image: AssetImage('assets/Logo_w.png'),
              height: 40,
            ),
          ),
        ),
      ],
      backgroundColor: AppConstants.primaryColor,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

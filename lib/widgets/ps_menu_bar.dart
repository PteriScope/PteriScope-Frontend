import 'package:flutter/material.dart';
import 'package:pteriscope_frontend/util/enum/current_screen.dart';

import '../screens/home_screen.dart';
import '../screens/patient/new_patient_screen.dart';
import '../screens/specialist/profile_screen.dart';
import '../util/constants.dart';
import '../util/shared.dart';

class PsMenuBar extends StatelessWidget {
  final CurrentScreen currentView;

  const PsMenuBar({Key? key, required this.currentView}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.padding),
          shrinkWrap: true,
          children: <Widget>[
            _buildMenuItem(
              icon: Icons.list,
              text: 'Lista de pacientes',
              isSelected: currentView == CurrentScreen.patientList,
              onTap: () {
                if (currentView != CurrentScreen.patientList) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                }
              },
            ),
            _buildMenuItem(
              icon: Icons.add,
              text: 'Nuevo paciente',
              isSelected: currentView == CurrentScreen.newPatient,
              onTap: () {
                if (currentView != CurrentScreen.newPatient) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NewPatientScreen(),
                    ),
                  );
                }
              },
            ),
            const Divider(),
            _buildMenuItem(
              icon: Icons.person,
              text: 'Perfil',
              isSelected: currentView == CurrentScreen.profile,
              onTap: () {
                if (currentView != CurrentScreen.profile) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                }
              },
            ),
            _buildMenuItem(
              icon: Icons.logout,
              text: 'Cerrar sesión',
              isSelected: false,
              onTap: () {
                Shared.logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required bool isSelected,
    required void Function() onTap,
  }) {
    return Material(
      borderRadius: BorderRadius.circular(25),
      color: isSelected ? AppConstants.primaryColor : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25),
        child: ListTile(
          leading: Icon(icon, color: isSelected ? Colors.white : null),
          title: Text(
            text,
            style: TextStyle(color: isSelected ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}

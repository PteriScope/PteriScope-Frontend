import 'package:flutter/material.dart';
import 'package:pteriscope_frontend/util/pteriscope_screen.dart';

import '../screens/home_screen.dart';
import '../screens/new_patient_screen.dart';
import '../util/constants.dart';
import '../util/shared.dart';

class PteriscopeMenuBar extends StatelessWidget {
  final PteriscopeScreen currentView;

  const PteriscopeMenuBar({
    Key? key,
    required this.currentView
  }) : super(key: key);

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
              isSelected: currentView == PteriscopeScreen.patientList,
              onTap: () {
                if(currentView != PteriscopeScreen.patientList) {
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
              isSelected: currentView == PteriscopeScreen.newPatient,
              onTap: () {
                if(currentView != PteriscopeScreen.newPatient) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NewPatient(),
                    ),
                  );
                }
              },
            ),
            const Divider(),
            _buildMenuItem(
              icon: Icons.person,
              text: 'Perfil',
              isSelected: currentView == PteriscopeScreen.profile,
              onTap: () {
                // TODO
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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pteriscope_frontend/screens/specialist/edit_profile_screen.dart';
import 'package:pteriscope_frontend/widgets/ps_app_bar.dart';
import 'package:pteriscope_frontend/widgets/ps_column_text.dart';
import 'package:pteriscope_frontend/widgets/ps_elevated_button.dart';

import '../../models/specialist.dart';
import '../../services/api_service.dart';
import '../../services/shared_preferences_service.dart';
import '../../util/constants.dart';
import '../../util/enum/button_type.dart';
import '../../util/enum/current_screen.dart';
import '../../util/enum/snack_bar_type.dart';
import '../../util/ps_exception.dart';
import '../../util/shared.dart';
import '../../widgets/ps_floating_button.dart';
import '../../widgets/ps_menu_bar.dart';
import '../home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Specialist? specialist;
  ApiService apiService = ApiService();
  bool error = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeSpecialist();
  }

  void initializeSpecialist() async {
    setState(() {
      isLoading = true;
    });

    try {
      bool __ = await Shared.checkConnectivity();

      Shared.showPSSnackBar(context, 'Obteniendo datos', SnackBarType.loading,
          AppConstants.longSnackBarDuration);
      final specialistId = SharedPreferencesService().getId();
      await apiService.getSpecialist(specialistId!).then((value) => {
            setState(() {
              specialist = value;
              error = false;
              isLoading = false;
            }),
            ScaffoldMessenger.of(context).hideCurrentSnackBar()
          });
    } on PsException catch (e) {
      Shared.showPSSnackBar(context, 'Error: ${e.message}',
          SnackBarType.onlyText, AppConstants.shortSnackBarDuration);
      setState(() {
        isLoading = false;
        error = true;
      });
    } on SocketException catch (_) {
      Shared.showPSSnackBar(
          context,
          'Hubo un error al tratar de conectarse al servidor. Inténtelo más tarde, por favor',
          SnackBarType.onlyText,
          AppConstants.shortSnackBarDuration);
      setState(() {
        isLoading = false;
        error = true;
      });
    } catch (e) {
      Shared.showPSSnackBar(context, 'Consulta fallida', SnackBarType.onlyText,
          AppConstants.shortSnackBarDuration);
      setState(() {
        isLoading = false;
        error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      },
      child: Scaffold(
        appBar: const PsAppBar(
            title: "Perfil de especialista",
            titleSize: AppConstants.smallAppBarTitleSize,
            disabled: false),
        drawer: const PsMenuBar(currentView: CurrentScreen.profile),
        body: Stack(
          children: [
            Card(
              elevation: 0,
              color: Colors.white,
              margin: const EdgeInsets.only(
                top: AppConstants.padding,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppConstants.padding),
                    child: Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(
                        top: AppConstants.padding,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 0,
                          right: AppConstants.padding,
                          bottom: AppConstants.padding,
                          top: AppConstants.padding,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  AppConstants.padding / 2.0),
                              child: const Image(
                                image: AssetImage('assets/specialist_icon.png'),
                                height: 150,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const PsColumnText(
                                    text: "Nombre del especialista: ",
                                    isBold: true),
                                PsColumnText(
                                    text: specialist == null
                                        ? "-"
                                        : specialist!.name,
                                    isBold: false),
                                const PsColumnText(text: "DNI: ", isBold: true),
                                PsColumnText(
                                    text: specialist == null
                                        ? "-"
                                        : specialist!.dni,
                                    isBold: false),
                                const PsColumnText(
                                    text: "Cargo: ", isBold: true),
                                PsColumnText(
                                    text: specialist == null
                                        ? "-"
                                        : specialist!.position,
                                    isBold: false),
                                const PsColumnText(
                                    text: "Hospital: ", isBold: true),
                                PsColumnText(
                                    text: specialist == null
                                        ? "-"
                                        : specialist!.hospital,
                                    isBold: false),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.padding),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PsElevatedButton(
                          width: 200,
                          disabled: isLoading,
                          onTap: () {
                            error
                                ? initializeSpecialist()
                                : Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => EditProfileScreen(
                                          specialist: specialist!),
                                    ),
                                  );
                          },
                          text: error ? "Reintentar" : "Editar perfil")
                    ],
                  ),
                  const SizedBox(height: AppConstants.padding * 5.0),
                ],
              ),
            ),
            Positioned(
              bottom: 20.0,
              left: 20.0,
              right: 20.0,
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.padding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    PsFloatingButton(
                        heroTag: 'backToHomeFromProfile',
                        buttonType: ButtonType.primary,
                        onTap: () => {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              )
                            },
                        iconData: Icons.arrow_back),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

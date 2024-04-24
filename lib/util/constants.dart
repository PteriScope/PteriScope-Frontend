import 'package:flutter/material.dart';

class AppConstants {
  static const int splashDelay = 2;
  static const Color primaryColor = Color(0xFF475BD8);
  static const Color secondaryColor = Color(0xFFFFFBFE);
  static const double padding = 16.0;

  static const String severePterygium = "Pterigión grave";
  static const Color severeColor = Color(0xFFD70505);

  static const String mildPterygium = "Pterigión leve";
  static const Color mildColor = Color(0xFFECBA26);

  static const String noPterygium = "Sin pterigión";
  static const Color normalColor = Color(0xFF4CAF50);

  static const int longSnackBarDuration = 30;
  static const int shortSnackBarDuration = 5;

  static const double bigAppBarTitleSize = 30;
  static const double smallAppBarTitleSize = 20;

  static const String advice1 = "Coloque la cámara de forma horizontal.";
  static const String advice2 =
      "Debe haber entre 10 y 15 cm entre el ojo del paciente y el celular.";
  static const String advice3 =
      "Use el zoom hasta que el iris se muestre en su totalidad. Los párpados deben mostrarse lo menos posible.";
  static const String advice4 = "De preferencia, active el flash.";
  static const String advice5 = "Asegurese que la imagen esté bien enfocada.";

  static const String advice1ImagePath = 'assets/advice1.png';
  static const String advice2ImagePath = 'assets/advice2.png';
  static const String advice3ImagePath = 'assets/advice3.png';
  static const String advice4ImagePath = 'assets/advice4.png';
  static const String advice5ImagePath = 'assets/advice5.png';

  static const String noPterygiumAdvice1 =
      "Usar gafas de sol para proteger los ojos de los rayos UV.";
  static const String noPterygiumAdvice2 =
      "Mantener una buena higiene ocular lavando los ojos regularmente con agua limpia.";
  static const String noPterygiumAdvice3 =
      "Visitar al oftalmólogo regularmente para chequeos oculares de rutina.";
  static const String noPterygiumAdvice4 =
      "Buscar educación al paciente sobre la importancia de la protección ocular y el cuidado preventivo.";

  static const String mildPterygiumAdvice1 =
      "Utilizar gafas de sol de estilo envolvente para proteger los ojos del sol y el viento.";
  static const String mildPterygiumAdvice2 =
      "Utilizar lágrimas artificiales o gotas lubricantes para aliviar la sequedad ocular y las molestias asociadas.";
  static const String mildPterygiumAdvice3 =
      "Monitorear regularmente el crecimiento del pterigión y su impacto en la visión.";
  static const String mildPterygiumAdvice4 =
      "Buscar educación al paciente sobre la importancia de la protección ocular y el cuidado preventivo.";
  static const String mildPterygiumAdvice5 =
      "Evaluar la necesidad de tratamiento basado en las preferencias estéticas y/o molestias del paciente y el impacto en su calidad de vida.";

  static const String severePterygiumAdvice1 =
      "Programar una consulta con un oftalmólogo para evaluar opciones de tratamiento, que pueden incluir cirugía.";
  static const String severePterygiumAdvice2 =
      "Evitar la exposición excesiva a los factores desencadenantes, como el sol y el viento.";
  static const String severePterygiumAdvice3 =
      "Seguir las indicaciones del oftalmólogo para el cuidado postoperatorio después de la cirugía.";
  static const String severePterygiumAdvice4 =
      "Mantener una buena higiene ocular y usar gafas de sol de calidad para proteger los ojos.";
}

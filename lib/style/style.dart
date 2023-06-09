import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyle {
  // App Images ..
  static const String profile = "assets/images/profile.jpg";
  static const String image1 = "assets/images/image1.png";
  static const String maleIcon = "assets/images/male.png";
  static const String femaleIcon = "assets/images/female.png";
  static const String ellipseShape = "assets/images/ellipse.png";
  static const String hanHyoJoo = "assets/images/hanhyojoo.jpg";
  static const String oogwayProfile = "assets/images/oogway.jpg";
  static const String triangleShape = "assets/images/triangle.png";
  static const String appLogo = "assets/images/meditopia_app_logo.png";
  static const String appFullLogo = "assets/images/meditopia_logo.png";

  /// App Icons.
  static const String filterIcon = "assets/icons/adjust-horizontal-alt.svg";
  static const String searchIcon = "assets/icons/search.svg";

  // Bottom Bar icons
  static const String homeIcon = "assets/icons/home.svg";
  static const String profileIcon = "assets/icons/profile.svg";
  static const String reportIcon = "assets/icons/report.svg";
  static const String notificationsIcon = "assets/icons/notifications.svg";
  static const String dotsIcon = "assets/icons/dots-icon.svg";
  static const String messageIcon = "assets/icons/message-icon.svg";
  static const String doctorIcon = "assets/icons/doctor-Icon.svg";
  static const String checkListIcon = "assets/icons/noun-medical-test.svg";
  static const String bmiIcon = "assets/icons/bmi-Icon.svg";

  // App Colors
  static const primarySwatch = Color(0xff1C6BA4);
  static const inputFillColor = Color(0xffEEF6FC);

  // App Theme Data..
  static ThemeData? theme = ThemeData(
    textTheme: GoogleFonts.nunitoSansTextTheme().apply(
      bodyColor: const Color(0xff0E1012),
      displayColor: const Color(0xff0E1012),
    ),
  );
}

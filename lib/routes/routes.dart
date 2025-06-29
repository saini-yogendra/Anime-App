import 'package:flutter/material.dart';

// Screens
import 'package:anime_app/view/Screens/auth%20screens/Sign%20In/sign_In.dart';
import 'package:anime_app/view/Screens/auth%20screens/Sign%20Up/signUp_Screen.dart';
import 'package:anime_app/view/Screens/auth%20screens/otp/otp_varification.dart';
import 'package:anime_app/view/Screens/auth%20screens/forget%20password/forget_password.dart';
import 'package:anime_app/view/Screens/auth%20screens/forget%20password/create_new_password.dart';
import 'package:anime_app/view/Screens/home/home_screen.dart';
import 'package:anime_app/view/Screens/myList/my_list_screen.dart';
import 'package:anime_app/view/Screens/setting/setting_screen.dart';
import 'package:anime_app/view/Screens/bottomNav/bottom_nav.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/home': (context) => const HomePage(),
    '/sign-in': (context) => const SignInScreen(),
    '/sign-up': (context) => const SignUpScreen(),
    '/otp': (context) => const OtpVerificationScreen(),
    // '/forgot-password': (context) => const ForgetPasswordScreen(),
    // '/create-password': (context) => const CreateNewPasswordScreen(),
    '/my-list': (context) => const MyListScreen(),
    '/settings': (context) => const SettingsScreen(),
    '/bottom-nav': (context) => const BottomNavScreen(),
  };
}

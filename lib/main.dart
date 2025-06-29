// import 'package:anime_app/view/Screens/anime_details_screen.dart';
// import 'package:anime_app/view/Screens/auth%20screens/Sign%20In/sign_In.dart';
// import 'package:anime_app/view/Screens/auth%20screens/Sign%20Up/signUp_Screen.dart';
// import 'package:anime_app/view/Screens/auth%20screens/forget%20password/create_new_password.dart';
// import 'package:anime_app/view/Screens/auth%20screens/forget%20password/forget_password.dart';
// import 'package:anime_app/view/Screens/auth%20screens/otp/otp_varification.dart';
// import 'package:anime_app/view/Screens/bottomNav/bottom_nav.dart';
// import 'package:anime_app/view/Screens/home/home_screen.dart';
// import 'package:anime_app/view/Screens/myList/my_list_screen.dart';
// import 'package:anime_app/view/Screens/onboard_screen.dart';
// import 'package:anime_app/view/Screens/setting/setting_screen.dart';
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Anime App',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       debugShowCheckedModeBanner: false,
//       home: HomePage(),
//     );
//   }
// }





// import 'package:flutter/material.dart';
// import 'package:anime_app/view/Screens/home/home_screen.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Anime App',
//       theme: ThemeData(
//         scaffoldBackgroundColor: const Color(0xFF0D0D0D),
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         fontFamily: 'Poppins',
//         useMaterial3: true,
//       ),
//       debugShowCheckedModeBanner: false,
//       home: const HomePage(), // 👈 Directly launching HomePage
//     );
//   }
// }











import 'package:anime_app/firebase_options.dart';
import 'package:anime_app/view/Screens/bottomNav/bottom_nav.dart';
import 'package:anime_app/view/Screens/home/home_screen.dart';
import 'package:anime_app/view/Screens/onBoard/onboard_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anime App',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: BottomNavScreen(),
      // initialRoute: '/bottom-nav', //  Route name to launch
      // routes: AppRoutes.routes, //  Use route map
    );
  }
}

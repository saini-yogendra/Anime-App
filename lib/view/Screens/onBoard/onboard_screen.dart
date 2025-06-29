
import 'package:flutter/material.dart';
import '../../widgets/custom button/custom_button.dart';

class OnboardScreen extends StatelessWidget {
  const OnboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallDevice = size.height < 700;

    return Scaffold(
      backgroundColor: const Color(0xff18122B),
      body: Stack(
        children: [
          // 🔹 Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/images/onboard.png",
              fit: BoxFit.cover,
            ),
          ),

          // 🔹 Dark Overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.6),
            ),
          ),

          // 🔹 UI Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Skip Button (top right)
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        // Handle skip
                      },
                      child: const Text(
                        "Skip",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // App Title
                  Text(
                    "Nikko Flix",
                    style: TextStyle(
                      fontSize: isSmallDevice ? 26 : 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.purpleAccent.withOpacity(0.85),
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  // Buttons
                  Column(
                    children: [
                      // 🔸 Sign In Button
                      CustomButton(
                        text: 'Sign In',
                        onPressed: () {
                          // Navigate to Sign In
                        },
                        useGradient: true,
                      ),
                      const SizedBox(height: 15),

                      // 🔸 Sign Up Button
                      CustomButton(
                        text: 'Sign Up',
                        onPressed: () {
                          // Navigate to Sign Up
                        },
                        useGradient: false,
                        singleColor: Colors.white,
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: isSmallDevice ? 20 : 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

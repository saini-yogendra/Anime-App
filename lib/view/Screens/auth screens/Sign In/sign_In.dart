import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../widgets/custom button/custom_button.dart';
import '../../../widgets/custom textfeild/custom_textfield.dart';
import '../../bottomNav/bottom_nav.dart';
import '../../home/home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _obscureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xff09090F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text("Sign In", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 🔵 Background Circles
          Positioned.fill(
            child: Stack(
              children: [
                Positioned(top: -50, left: -30, child: _buildBlurCircle(250)),
                Positioned(top: 100, right: -60, child: _buildBlurCircle(250)),
                Positioned(bottom: -40, left: -30, child: _buildBlurCircle(250)),
              ],
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: size.height - kToolbarHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),

                      // Email
                      CustomTextField(
                        label: "Email",
                        hintText: "example@example.com",
                        controller: _emailController,
                      ),
                      const SizedBox(height: 20),

                      // Password
                      CustomTextField(
                        label: "Password",
                        hintText: "Password",
                        obscureText: _obscureText,
                        controller: _passwordController,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white54,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Continue Button
                      CustomButton(
                        text: 'Continue',
                        onPressed: () async {
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();

                          if (email.isEmpty || password.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please enter email and password')),
                            );
                            return;
                          }

                          try {
                            await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: email,
                              password: password,
                            );

                            // ✅ Navigate to Home Screen
                            if (!mounted) return;
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const BottomNavScreen()),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Login successful')),
                            );
                          } on FirebaseAuthException catch (e) {
                            String errorMessage = 'Login failed';
                            if (e.code == 'user-not-found') {
                              errorMessage = 'No user found for that email.';
                            } else if (e.code == 'wrong-password') {
                              errorMessage = 'Wrong password provided.';
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(errorMessage)),
                            );
                          }
                        },


                        useGradient: true,
                      ),
                      const SizedBox(height: 10),

                      Center(
                        child: TextButton(
                          onPressed: () {
                            // Forgot password logic
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Divider
                      Row(
                        children: const [
                          Expanded(child: Divider(color: Colors.white24)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text("or", style: TextStyle(color: Colors.white54)),
                          ),
                          Expanded(child: Divider(color: Colors.white24)),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Social Buttons
                      _buildSocialButton(
                        label: "Continue with Google",
                        imagePath: 'assets/images/google.png',
                        onPressed: () {},
                      ),
                      const SizedBox(height: 12),
                      _buildSocialButton(
                        icon: Icons.apple,
                        label: "Continue with Apple",
                        onPressed: () {},
                      ),
                      const SizedBox(height: 12),
                      _buildSocialButton(
                        icon: Icons.facebook,
                        label: "Continue with Facebook",
                        onPressed: () {},
                      ),

                      const Spacer(),

                      // Sign Up Text
                      Center(
                        child: Text.rich(
                          TextSpan(
                            text: "Don't have account? ",
                            style: const TextStyle(color: Colors.white38),
                            children: [
                              TextSpan(
                                text: "Sign Up",
                                style: const TextStyle(color: Colors.blueAccent),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlurCircle(double size) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFFFFFFF).withAlpha(15),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    IconData? icon,
    String? imagePath,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFF1E1C2A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.zero,
          side: BorderSide.none,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath != null)
              Image.asset(imagePath, height: 22, width: 22)
            else if (icon != null)
              Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

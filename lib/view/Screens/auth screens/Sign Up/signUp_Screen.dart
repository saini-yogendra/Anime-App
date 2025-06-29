import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../widgets/custom button/custom_button.dart';
import '../../../widgets/custom textfeild/custom_textfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _birthdayController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthday(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(data: ThemeData.dark(), child: child!);
      },
    );

    if (pickedDate != null) {
      _birthdayController.text = DateFormat('MM/dd/yyyy').format(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF09090F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text("Sign Up", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Blur Circles
          Positioned.fill(
            child: Stack(
              children: [
                Positioned(top: -50, left: -30, child: _buildBlurCircle(250)),
                Positioned(top: 100, right: -60, child: _buildBlurCircle(250)),
                Positioned(
                  bottom: -40,
                  left: -30,
                  child: _buildBlurCircle(250),
                ),
              ],
            ),
          ),

          // Foreground Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: size.height - kToolbarHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // Email
                      CustomTextField(
                        label: "Email",
                        hintText: "example@example.com",
                        controller: _emailController,
                      ),
                      const SizedBox(height: 20),

                      // Birthday
                      GestureDetector(
                        onTap: () => _selectBirthday(context),
                        child: AbsorbPointer(
                          child: CustomTextField(
                            label: "Birthday",
                            hintText: "MM/DD/YYYY",
                            controller: _birthdayController,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Password
                      CustomTextField(
                        label: "Password",
                        hintText: "Password",
                        obscureText: _obscurePassword,
                        controller: _passwordController,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white54,
                          ),
                          onPressed: () {
                            setState(
                              () => _obscurePassword = !_obscurePassword,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Confirm Password
                      CustomTextField(
                        label: "Confirm Password",
                        hintText: "Password",
                        obscureText: _obscureConfirmPassword,
                        controller: _confirmPasswordController,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white54,
                          ),
                          onPressed: () {
                            setState(
                              () =>
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Password Rule
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(top: 3),
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 18,
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Password must be at least 8 character, uppercase, lowercase, and unique code like #%!",
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Terms & Conditions
                      const Text.rich(
                        TextSpan(
                          text:
                              "By clicking the agree and continue button, you agree to Moves' ",
                          style: TextStyle(color: Colors.white60, fontSize: 13),
                          children: [
                            TextSpan(
                              text: "Terms and Service",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: " and acknowledge the "),
                            TextSpan(
                              text: "Privacy and Policy",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Button
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: CustomButton(
                          text: 'Agree and continue',
                          onPressed: () async {
                            final email = _emailController.text.trim();
                            final password = _passwordController.text.trim();
                            final confirmPassword =
                                _confirmPasswordController.text.trim();

                            if (email.isEmpty ||
                                password.isEmpty ||
                                confirmPassword.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please fill all fields"),
                                ),
                              );
                              return;
                            }

                            if (password != confirmPassword) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Passwords do not match"),
                                ),
                              );
                              return;
                            }

                            try {
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Signup Successful"),
                                ),
                              );

                              // TODO: Navigate to home screen or verify email screen
                            } on FirebaseAuthException catch (e) {
                              String errorMessage = "Signup Failed";
                              if (e.code == 'email-already-in-use') {
                                errorMessage = "Email already in use";
                              } else if (e.code == 'invalid-email') {
                                errorMessage = "Invalid email address";
                              } else if (e.code == 'weak-password') {
                                errorMessage =
                                    "Password should be at least 6 characters";
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(errorMessage)),
                              );
                            }
                          },

                          useGradient: true,
                          width: double.infinity,
                          height: 55,
                        ),
                      ),
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
            color: Colors.white.withAlpha(15),
          ),
        ),
      ),
    );
  }
}

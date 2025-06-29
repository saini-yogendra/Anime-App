
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../controller/create_password/create_password_bloc.dart';
import '../../../../controller/create_password/create_password_event.dart';
import '../../../../controller/create_password/create_password_state.dart';
import '../../../widgets/custom button/custom_button.dart';
import '../../../widgets/custom textfeild/custom_textfield.dart';

class CreateNewPassword extends StatelessWidget {
  const CreateNewPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreatePasswordBloc(),
      child: Scaffold(
        backgroundColor: const Color(0xff09090F),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(color: Colors.white),
          centerTitle: true,
          title: const Text(
            "Create New Password",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Stack(
          children: [
            // 🔵 Blur Circles
            Positioned(top: -50, left: -30, child: _buildBlurCircle(250)),
            Positioned(top: 100, right: -60, child: _buildBlurCircle(250)),
            Positioned(bottom: -40, left: -30, child: _buildBlurCircle(250)),

            // 🟣 Main Content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    const Text(
                      "Set the new password for your account\nso you can login and access all features",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 40),

                    BlocBuilder<CreatePasswordBloc, CreatePasswordState>(
                      builder: (context, state) {
                        return Column(
                          children: [
                            CustomTextField(
                              label: "New Password",
                              hintText: "Password",
                              obscureText: state.isObscure,
                              controller:
                              TextEditingController(text: state.newPassword),
                              onChanged: (val) => context
                                  .read<CreatePasswordBloc>()
                                  .add(NewPasswordChanged(val)),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  state.isObscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white54,
                                ),
                                onPressed: () {
                                  context.read<CreatePasswordBloc>().emit(
                                      state.copyWith(isObscure: !state.isObscure));
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              label: "Confirm New Password",
                              hintText: "",
                              obscureText: state.isObscure,
                              controller: TextEditingController(
                                  text: state.confirmPassword),
                              onChanged: (val) => context
                                  .read<CreatePasswordBloc>()
                                  .add(ConfirmPasswordChanged(val)),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  state.isObscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white54,
                                ),
                                onPressed: () {
                                  context.read<CreatePasswordBloc>().emit(
                                      state.copyWith(isObscure: !state.isObscure));
                                },
                              ),
                            ),
                            if (state.error != null) ...[
                              const SizedBox(height: 12),
                              Text(
                                state.error!,
                                style: const TextStyle(color: Colors.redAccent),
                              ),
                            ]
                          ],
                        );
                      },
                    ),

                    const Spacer(),

                    BlocBuilder<CreatePasswordBloc, CreatePasswordState>(
                      builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: CustomButton(
                            text: state.isSubmitting ? 'Loading...' : 'Continue',
                            onPressed: state.isSubmitting
                                ? () {}
                                : () {
                              context
                                  .read<CreatePasswordBloc>()
                                  .add(SubmitPassword());
                            },
                            useGradient: true,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
}

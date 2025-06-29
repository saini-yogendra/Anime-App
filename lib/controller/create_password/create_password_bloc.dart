import 'package:flutter_bloc/flutter_bloc.dart';
import 'create_password_event.dart';
import 'create_password_state.dart';

class CreatePasswordBloc extends Bloc<CreatePasswordEvent, CreatePasswordState> {
  CreatePasswordBloc() : super(CreatePasswordState()) {
    on<NewPasswordChanged>((event, emit) {
      emit(state.copyWith(newPassword: event.password));
    });

    on<ConfirmPasswordChanged>((event, emit) {
      emit(state.copyWith(confirmPassword: event.confirmPassword));
    });

    on<SubmitPassword>((event, emit) async {
      emit(state.copyWith(isSubmitting: true));

      await Future.delayed(const Duration(seconds: 1)); // Fake API Call

      emit(state.copyWith(isSubmitting: false));
    });
  }

  void toggleObscureText() {
    emit(state.copyWith(isObscure: !state.isObscure));
  }
}

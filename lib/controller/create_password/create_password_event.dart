abstract class CreatePasswordEvent {}

class NewPasswordChanged extends CreatePasswordEvent {
  final String password;
  NewPasswordChanged(this.password);
}

class ConfirmPasswordChanged extends CreatePasswordEvent {
  final String confirmPassword;
  ConfirmPasswordChanged(this.confirmPassword);
}

class SubmitPassword extends CreatePasswordEvent {}

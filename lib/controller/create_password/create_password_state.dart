// class CreatePasswordState {
//   final String newPassword;
//   final String confirmPassword;
//   final bool isObscure;
//   final bool isSubmitting;
//
//   const CreatePasswordState({
//     this.newPassword = '',
//     this.confirmPassword = '',
//     this.isObscure = true,
//     this.isSubmitting = false,
//   });
//
//   CreatePasswordState copyWith({
//     String? newPassword,
//     String? confirmPassword,
//     bool? isObscure,
//     bool? isSubmitting,
//   }) {
//     return CreatePasswordState(
//       newPassword: newPassword ?? this.newPassword,
//       confirmPassword: confirmPassword ?? this.confirmPassword,
//       isObscure: isObscure ?? this.isObscure,
//       isSubmitting: isSubmitting ?? this.isSubmitting,
//     );
//   }
// }



class CreatePasswordState {
  final String newPassword;
  final String confirmPassword;
  final bool isObscure;
  final bool isSubmitting;
  final String? error; // ✅ ADD THIS LINE

  CreatePasswordState({
    this.newPassword = '',
    this.confirmPassword = '',
    this.isObscure = true,
    this.isSubmitting = false,
    this.error, // ✅ Add here too
  });

  CreatePasswordState copyWith({
    String? newPassword,
    String? confirmPassword,
    bool? isObscure,
    bool? isSubmitting,
    String? error, // ✅
  }) {
    return CreatePasswordState(
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isObscure: isObscure ?? this.isObscure,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error, // ✅
    );
  }
}

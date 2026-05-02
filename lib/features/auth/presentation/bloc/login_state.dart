class LoginState {
  const LoginState({
    required this.isSubmitting,
    required this.rememberMe,
    this.errorMessage,
  });

  factory LoginState.initial() =>
      const LoginState(isSubmitting: false, rememberMe: true);

  final bool isSubmitting;
  final bool rememberMe;
  final String? errorMessage;

  LoginState copyWith({
    bool? isSubmitting,
    bool? rememberMe,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LoginState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      rememberMe: rememberMe ?? this.rememberMe,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

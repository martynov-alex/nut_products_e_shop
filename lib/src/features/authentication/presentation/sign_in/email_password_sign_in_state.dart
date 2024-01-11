import 'package:nut_products_e_shop/src/features/authentication/presentation/sign_in/string_validators.dart';
import 'package:nut_products_e_shop/src/localization/string_hardcoded.dart';

/// Form type for email & password authentication
enum EmailPasswordSignInFormType { signIn, register }

/// Mixin class to be used for client-side email & password validation
mixin EmailAndPasswordValidators {
  final StringValidator emailSubmitValidator = EmailSubmitRegexValidator();
  final StringValidator passwordRegisterSubmitValidator =
      PasswordSubmitRegexValidator();
  final StringValidator passwordSignInSubmitValidator =
      NonEmptyStringValidator();
}

/// State class for the email & password form.
class EmailPasswordSignInState with EmailAndPasswordValidators {
  EmailPasswordSignInState({
    this.formType = EmailPasswordSignInFormType.signIn,
    this.isLoading = false,
  });

  final EmailPasswordSignInFormType formType;
  final bool isLoading;

  EmailPasswordSignInState copyWith({
    EmailPasswordSignInFormType? formType,
    bool? isLoading,
  }) {
    return EmailPasswordSignInState(
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  String toString() =>
      'EmailPasswordSignInState(formType: $formType, isLoading: $isLoading)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EmailPasswordSignInState &&
        other.formType == formType &&
        other.isLoading == isLoading;
  }

  @override
  int get hashCode => formType.hashCode ^ isLoading.hashCode;
}

extension EmailPasswordSignInStateX on EmailPasswordSignInState {
  String get passwordLabelText => switch (formType) {
        EmailPasswordSignInFormType.register =>
          'Password (8+ characters without spaces)'.hardcoded,
        EmailPasswordSignInFormType.signIn => 'Password'.hardcoded,
      };

  String get primaryButtonText => switch (formType) {
        EmailPasswordSignInFormType.register => 'Create an account'.hardcoded,
        EmailPasswordSignInFormType.signIn => 'Sign in'.hardcoded,
      };

  String get secondaryButtonText => switch (formType) {
        EmailPasswordSignInFormType.register =>
          'Have an account? Sign in'.hardcoded,
        EmailPasswordSignInFormType.signIn =>
          'Need an account? Register'.hardcoded,
      };

  String get errorAlertTitle => switch (formType) {
        EmailPasswordSignInFormType.register => 'Registration failed'.hardcoded,
        EmailPasswordSignInFormType.signIn => 'Sign in failed'.hardcoded,
      };

  String get title => switch (formType) {
        EmailPasswordSignInFormType.register => 'Register'.hardcoded,
        EmailPasswordSignInFormType.signIn => 'Sign in'.hardcoded,
      };

  EmailPasswordSignInFormType get secondaryActionFormType => switch (formType) {
        EmailPasswordSignInFormType.register =>
          EmailPasswordSignInFormType.signIn,
        EmailPasswordSignInFormType.signIn =>
          EmailPasswordSignInFormType.register,
      };

  bool canSubmitEmail(String email) => emailSubmitValidator.isValid(email);

  bool canSubmitPassword(String password) => switch (formType) {
        EmailPasswordSignInFormType.register =>
          passwordRegisterSubmitValidator.isValid(password),
        EmailPasswordSignInFormType.signIn =>
          passwordSignInSubmitValidator.isValid(password),
      };

  String? emailErrorText(String email) {
    final bool showErrorText = !canSubmitEmail(email);
    final String errorText = email.isEmpty
        ? 'Email can\'t be empty'.hardcoded
        : 'Invalid email'.hardcoded;
    return showErrorText ? errorText : null;
  }

  String? passwordErrorText(String password) {
    final bool showErrorText = !canSubmitPassword(password);
    final String errorText = password.isEmpty
        ? 'Password can\'t be empty'.hardcoded
        : 'Password is too short or contains spaces'.hardcoded;
    return showErrorText ? errorText : null;
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
@immutable
class EmailPasswordSignInState with EmailAndPasswordValidators {
  final EmailPasswordSignInFormType formType;
  final AsyncValue<void> value;

  EmailPasswordSignInState({
    this.formType = EmailPasswordSignInFormType.signIn,
    this.value = const AsyncValue.data(null),
  });

  bool get isLoading => value.isLoading;

  EmailPasswordSignInState copyWith({
    EmailPasswordSignInFormType? formType,
    AsyncValue<void>? value,
  }) {
    return EmailPasswordSignInState(
      formType: formType ?? this.formType,
      value: value ?? this.value,
    );
  }

  @override
  String toString() =>
      'EmailPasswordSignInState(formType: $formType, value: $value)';

  @override
  bool operator ==(covariant EmailPasswordSignInState other) {
    if (identical(this, other)) return true;

    return other.formType == formType && other.value == value;
  }

  @override
  int get hashCode => formType.hashCode ^ value.hashCode;
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
    final showErrorText = !canSubmitEmail(email);
    final errorText = email.isEmpty
        ? "Email can't be empty".hardcoded
        : 'Invalid email'.hardcoded;
    return showErrorText ? errorText : null;
  }

  String? passwordErrorText(String password) {
    final showErrorText = !canSubmitPassword(password);
    final errorText = password.isEmpty
        ? "Password can't be empty".hardcoded
        : 'Password is too short or contains spaces'.hardcoded;
    return showErrorText ? errorText : null;
  }
}

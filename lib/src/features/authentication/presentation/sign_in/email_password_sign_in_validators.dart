import 'package:nut_products_e_shop/src/features/authentication/presentation/sign_in/email_password_sign_in_form_type.dart';
import 'package:nut_products_e_shop/src/features/authentication/presentation/sign_in/string_validators.dart';
import 'package:nut_products_e_shop/src/localization/string_hardcoded.dart';

/// Mixin class to be used for client-side email & password validation
mixin EmailAndPasswordValidators {
  final StringValidator emailSubmitValidator = EmailSubmitRegexValidator();
  final StringValidator passwordRegisterSubmitValidator =
      PasswordSubmitRegexValidator();
  final StringValidator passwordSignInSubmitValidator =
      NonEmptyStringValidator();

  bool canSubmitEmail(String email) => emailSubmitValidator.isValid(email);

  bool canSubmitPassword(
    String password,
    EmailPasswordSignInFormType formType,
  ) =>
      switch (formType) {
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

  String? passwordErrorText(
    String password,
    EmailPasswordSignInFormType formType,
  ) {
    final showErrorText = !canSubmitPassword(password, formType);
    final errorText = password.isEmpty
        ? "Password can't be empty".hardcoded
        : 'Password is too short or contains spaces'.hardcoded;
    return showErrorText ? errorText : null;
  }
}

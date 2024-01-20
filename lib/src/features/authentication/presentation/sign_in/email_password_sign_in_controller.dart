import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nut_products_e_shop/src/features/authentication/data/fake_auth_repository.dart';
import 'package:nut_products_e_shop/src/features/authentication/presentation/sign_in/email_password_sign_in_form_type.dart';

class EmailPasswordSignInController extends StateNotifier<AsyncValue<void>> {
  EmailPasswordSignInController(this.ref) : super(const AsyncData<void>(null));
  final Ref ref;

  Future<bool> submit(
      {required String email,
      required String password,
      required EmailPasswordSignInFormType formType}) async {
    state = const AsyncValue.loading();
    state =
        await AsyncValue.guard(() => _authenticate(email, password, formType));
    return state.hasError == false;
  }

  Future<void> _authenticate(
      String email, String password, EmailPasswordSignInFormType formType) {
    final authRepository = ref.read(authRepositoryProvider);
    return switch (formType) {
      EmailPasswordSignInFormType.signIn =>
        authRepository.signInWithEmailAndPassword(email, password),
      EmailPasswordSignInFormType.register =>
        authRepository.createUserWithEmailAndPassword(email, password),
    };
  }
}

final emailPasswordSignInControllerProvider = StateNotifierProvider.autoDispose<
    EmailPasswordSignInController, AsyncValue<void>>((ref) {
  return EmailPasswordSignInController(ref);
});

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nut_products_e_shop/src/features/authentication/domain/app_user.dart';
import 'package:nut_products_e_shop/src/utils/delay.dart';
import 'package:nut_products_e_shop/src/utils/in_memory_state.dart';

class FakeAuthRepository {
  final bool addDelay;
  final _authState = InMemoryStore<AppUser?>(null);

  FakeAuthRepository({this.addDelay = true});

  // `null` means the user is not authenticated
  Stream<AppUser?> authStateChanges() => _authState.stream;
  AppUser? get currentUser => _authState.value;

  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    await delay(addDelay: addDelay);
    _createNewUser(email);
  }

  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    await delay(addDelay: addDelay);
    _createNewUser(email);
  }

  Future<void> signOut() async {
    await delay(addDelay: addDelay);
    _authState.value = null;
  }

  void dispose() => _authState.close();

  void _createNewUser(String email) {
    _authState.value = AppUser(
      uid: email.split('').reversed.join(),
      email: email,
    );
  }
}

final authRepositoryProvider = Provider<FakeAuthRepository>((ref) {
  final auth = FakeAuthRepository();
  ref.onDispose(auth.dispose);
  return auth;
});

final authStateChangesProvider = StreamProvider<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});

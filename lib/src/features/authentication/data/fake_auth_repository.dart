import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nut_products_e_shop/src/features/authentication/domain/app_user.dart';

class FakeAuthRepository {
  // `null` means the user is not authenticated
  Stream<AppUser?> authStateChanges() => Stream.value(null); // TODO: update
  AppUser? get currentUser => null; // TODO: update

  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    // TODO: implement signInWithEmailAndPassword
  }

  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    // TODO: implement createUserWithEmailAndPassword
  }

  Future<void> signOut() async {
    // TODO: implement signOut
  }
}

final authRepositoryProvider = Provider<FakeAuthRepository>((ref) {
  return FakeAuthRepository();
});

final authStateChangesProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});

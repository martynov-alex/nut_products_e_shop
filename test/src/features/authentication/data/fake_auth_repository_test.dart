import 'package:flutter_test/flutter_test.dart';
import 'package:nut_products_e_shop/src/features/authentication/data/fake_auth_repository.dart';
import 'package:nut_products_e_shop/src/features/authentication/domain/app_user.dart';

void main() {
  const testEmail = 'test@test.ru';
  const testPassword = 'testPassword';
  final testUser = AppUser(
    uid: testEmail.split('').reversed.join(),
    email: testEmail,
  );

  FakeAuthRepository makeFakeAuthRepository() =>
      FakeAuthRepository(addDelay: false);
  group('FakeAuthRepository', () {
    test('currentUser is null', () {
      final authRepository = makeFakeAuthRepository();
      expect(authRepository.currentUser, null);
      expect(authRepository.authStateChanges(), emits(null));
    });

    test('currentUser is not null after sign in', () async {
      final authRepository = makeFakeAuthRepository();
      await authRepository.signInWithEmailAndPassword(testEmail, testPassword);
      expect(authRepository.currentUser, testUser);
      expect(authRepository.authStateChanges(), emits(testUser));
    });

    test('currentUser is not null after registration', () async {
      final authRepository = makeFakeAuthRepository();
      await authRepository.createUserWithEmailAndPassword(
        testEmail,
        testPassword,
      );
      expect(authRepository.currentUser, testUser);
      expect(authRepository.authStateChanges(), emits(testUser));
    });

    test('currentUser is null after signOut', () async {
      final authRepository = makeFakeAuthRepository();
      await authRepository.signInWithEmailAndPassword(testEmail, testPassword);
      expect(authRepository.currentUser, testUser);
      expect(authRepository.authStateChanges(), emits(testUser));
      // * also there is another way to test this, but expect should be here,
      // * because of BehaviorSubject (emitsInOrder will wait for the second event)
      // expect(
      //   authRepository.authStateChanges(),
      //   emitsInOrder([
      //     testUser, // after signIn
      //     null, // after signOut
      //   ]),
      // );

      await authRepository.signOut();
      expect(authRepository.currentUser, null);
      expect(authRepository.authStateChanges(), emits(null));
    });

    test('signIn after dispose throws exception', () {
      final authRepository = makeFakeAuthRepository()..dispose();
      expect(
        () async => authRepository.signInWithEmailAndPassword(
          testEmail,
          testPassword,
        ),
        throwsStateError,
      );
    });
  });
}
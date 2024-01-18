import 'package:flutter_test/flutter_test.dart';
import 'package:nut_products_e_shop/src/exceptions/app_exception.dart';
import 'package:nut_products_e_shop/src/features/authentication/data/fake_auth_repository.dart';

import '../../../mocks.dart';

void main() {
  FakeAuthRepository makeFakeAuthRepository() =>
      FakeAuthRepository(addDelay: false);
  group('FakeAuthRepository', () {
    test('currentUser is null', () {
      final authRepository = makeFakeAuthRepository();
      addTearDown(authRepository.dispose);
      expect(authRepository.currentUser, null);
      expect(authRepository.authStateChanges(), emits(null));
    });

    test('sign in throws when user not found', () async {
      final authRepository = makeFakeAuthRepository();
      addTearDown(authRepository.dispose);
      await expectLater(
        () => authRepository.signInWithEmailAndPassword(
          testEmail,
          testPassword,
        ),
        throwsA(isA<UserNotFoundException>()),
      );
      expect(authRepository.currentUser, null);
      expect(authRepository.authStateChanges(), emits(null));
    });

    test('currentUser is not null after registration', () async {
      final authRepository = makeFakeAuthRepository();
      addTearDown(authRepository.dispose);
      await authRepository.createUserWithEmailAndPassword(
        testEmail,
        testPassword,
      );
      expect(authRepository.currentUser, testUser);
      expect(authRepository.authStateChanges(), emits(testUser));
    });

    test('currentUser is null after signOut', () async {
      final authRepository = makeFakeAuthRepository();
      addTearDown(authRepository.dispose);
      await authRepository.createUserWithEmailAndPassword(
        testEmail,
        testPassword,
      );
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

    test('create user after dispose throws exception', () {
      final authRepository = makeFakeAuthRepository()..dispose();
      expect(
        () async => authRepository.createUserWithEmailAndPassword(
          testEmail,
          testPassword,
        ),
        throwsStateError,
      );
    });
  });
}

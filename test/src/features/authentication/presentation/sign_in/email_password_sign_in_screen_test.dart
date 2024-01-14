import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nut_products_e_shop/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';

import '../../../../mocks.dart';
import '../../auth_robot.dart';

void main() {
  late MockAuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
  });

  group('Sign in', () {
    testWidgets('''
        GIVEN formType is signIn
        WHEN tap on the sign-in button
        THEN signInWithEmailAndPassword is not called
        AND the user should be taken to the home screen
        ''', (tester) async {
      final r = AuthRobot(tester);
      await r.pumpEmailPasswordSignInContents(
        authRepository: authRepository,
        formType: EmailPasswordSignInFormType.signIn,
      );
      await r.tapEmailAndPasswordSubmitButton();
      verifyNever(
        () => authRepository.signInWithEmailAndPassword(any(), any()),
      );
    });

    testWidgets('''
        GIVEN formType is signIn
        WHEN enter valid email and password
        AND tap on the sign-in button
        THEN signInWithEmailAndPassword is called
        AND the user should be taken to the home screen
        AND onSignedIn callback is called
        AND error alert is not shown
        ''', (tester) async {
      var didSignIn = false;
      final r = AuthRobot(tester);
      when(() => authRepository.signInWithEmailAndPassword(
            testEmail,
            testPassword,
          )).thenAnswer((_) => Future.value());
      await r.pumpEmailPasswordSignInContents(
        authRepository: authRepository,
        formType: EmailPasswordSignInFormType.signIn,
        onSignedIn: () => didSignIn = true,
      );
      await r.enterEmail(testEmail);
      await r.enterPassword(testPassword);
      await r.tapEmailAndPasswordSubmitButton();
      verify(
        () => authRepository.signInWithEmailAndPassword(
          testEmail,
          testPassword,
        ),
      ).called(1);
      r.expectErrorAlertNotFound();
      expect(didSignIn, true);
    });
  });
}

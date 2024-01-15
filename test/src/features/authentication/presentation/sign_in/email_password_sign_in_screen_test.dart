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

  group('register', () {
    testWidgets('''
        GIVEN formType is register
        WHEN tap on the sign-in button
        THEN createUserWithEmailAndPassword is not called
        ''', (tester) async {
      final r = AuthRobot(tester);
      await r.pumpEmailPasswordSignInContents(
        authRepository: authRepository,
        formType: EmailPasswordSignInFormType.register,
      );
      await r.tapEmailAndPasswordSubmitButton();
      verifyNever(() => authRepository.createUserWithEmailAndPassword(
            any(),
            any(),
          ));
    });
    testWidgets('''
        GIVEN formType is register
        WHEN enter valid email
        AND enter password that is too short
        AND tap on the sign-in button
        THEN createUserWithEmailAndPassword is called
        AND onSignedIn callback is called
        AND error alert is not shown
        ''', (tester) async {
      final r = AuthRobot(tester);
      const shortPassword = '1234';
      when(() => authRepository.createUserWithEmailAndPassword(
            testEmail,
            shortPassword,
          )).thenAnswer((_) => Future.value());
      await r.pumpEmailPasswordSignInContents(
        authRepository: authRepository,
        formType: EmailPasswordSignInFormType.register,
      );
      await r.enterEmail(testEmail);
      await r.enterPassword(shortPassword);
      await r.tapEmailAndPasswordSubmitButton();
      verifyNever(() => authRepository.createUserWithEmailAndPassword(
            any(),
            any(),
          ));
    });
    testWidgets('''
        GIVEN formType is register
        WHEN enter valid email
        AND enter password that is long enough
        AND tap on the sign-in button
        THEN createUserWithEmailAndPassword is called
        AND onSignedIn callback is called
        AND error alert is not shown
        ''', (tester) async {
      var didSignIn = false;
      final r = AuthRobot(tester);
      when(() => authRepository.createUserWithEmailAndPassword(
            testEmail,
            testPassword,
          )).thenAnswer((_) => Future.value());
      await r.pumpEmailPasswordSignInContents(
        authRepository: authRepository,
        formType: EmailPasswordSignInFormType.register,
        onSignedIn: () => didSignIn = true,
      );
      await r.enterEmail(testEmail);
      await r.enterPassword(testPassword);
      await r.tapEmailAndPasswordSubmitButton();
      verify(() => authRepository.createUserWithEmailAndPassword(
            testEmail,
            testPassword,
          )).called(1);
      r.expectErrorAlertNotFound();
      expect(didSignIn, true);
    });
  });

  group('updateFormType', () {
    testWidgets('''
        GIVEN formType is sign in
        WHEN tap on the form toggle button
        THEN create account button is found
        ''', (tester) async {
      final r = AuthRobot(tester);
      await r.pumpEmailPasswordSignInContents(
        authRepository: authRepository,
        formType: EmailPasswordSignInFormType.signIn,
      );
      await r.tapFormToggleButton();
      r.expectCreateAccountButtonFound();
    });
    testWidgets('''
        GIVEN formType is sign in
        WHEN tap on the form toggle button
        THEN create account button is found
        ''', (tester) async {
      final r = AuthRobot(tester);
      await r.pumpEmailPasswordSignInContents(
        authRepository: authRepository,
        formType: EmailPasswordSignInFormType.register,
      );
      await r.tapFormToggleButton();
      r.expectCreateAccountButtonNotFound();
    });
  });
}

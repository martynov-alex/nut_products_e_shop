import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../../auth_robot.dart';

void main() {
  testWidgets('Cancel logout', (tester) async {
    final r = AuthRobot(tester);
    await r.pumpAccountScreen();
    await r.tapLogoutButton();
    r.expectLogoutDialogFound();
    await r.tapCancelButton();
    r.expectLogoutDialogNotFound();
  });

  testWidgets('Confirm logout, success', (tester) async {
    final r = AuthRobot(tester);
    await r.pumpAccountScreen();
    await tester.runAsync(() async {
      await r.tapLogoutButton();
      r.expectLogoutDialogFound();
      await r.tapDialogLogoutButton();
    });
    r
      ..expectLogoutDialogNotFound()
      ..expectErrorAlertNotFound();
  });

  testWidgets('Confirm logout, failure', (tester) async {
    final authRepository = MockAuthRepository();
    final exception = Exception('Connection fail');
    when(authRepository.authStateChanges).thenAnswer(
      (_) => Stream.value(testUser),
    );
    when(authRepository.signOut).thenThrow(exception);
    final r = AuthRobot(tester);
    await r.pumpAccountScreen(authRepository: authRepository);
    await r.tapLogoutButton();
    r.expectLogoutDialogFound();
    await r.tapDialogLogoutButton();
    r.expectErrorAlertFound();
  });

  testWidgets('Confirm logout, loading', (tester) async {
    final authRepository = MockAuthRepository();
    when(authRepository.authStateChanges).thenAnswer(
      (_) => Stream.value(testUser),
    );
    when(authRepository.signOut).thenAnswer(
      (_) => Future.delayed(const Duration(seconds: 2)),
    );
    final r = AuthRobot(tester);
    await r.pumpAccountScreen(authRepository: authRepository);
    await tester.runAsync(() async {
      await r.tapLogoutButton();
      r.expectLogoutDialogFound();
      await r.tapDialogLogoutButton();
    });

    r.expectCircularProgressIndicatorFound();
  });
}

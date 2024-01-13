@Timeout(Duration(milliseconds: 500))
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nut_products_e_shop/src/features/authentication/presentation/account/account_screen_controller.dart';

import '../../../../mocks.dart';

void main() {
  late MockAuthRepository authRepository;
  late AccountScreenController controller;

  setUp(() {
    authRepository = MockAuthRepository();
    controller = AccountScreenController(authRepository: authRepository);
  });

  tearDown(() {
    authRepository.dispose();
    controller.dispose();
  });

  group('AccountScreenController', () {
    test('initial state is AsyncValue.data', () {
      verifyNever(authRepository.signOut);
      expect(controller.state, const AsyncData<void>(null));
    });

    test('signOut success', () async {
      // setup
      when(authRepository.signOut).thenAnswer((_) => Future.value());

      // expect later
      unawaited(expectLater(
        controller.stream,
        emitsInOrder(const [
          AsyncLoading<void>(),
          AsyncData<void>(null),
        ]),
      ));

      // run
      await controller.signOut();

      // verify
      verify(authRepository.signOut).called(1);
    });

    test('signOut failure', () async {
      // setup
      final exception = Exception('Connection failure');
      when(authRepository.signOut).thenThrow(exception);

      // expect later
      unawaited(expectLater(
        controller.stream,
        emitsInOrder([
          const AsyncLoading<void>(),
          // isA<AsyncError>(),
          // or
          // predicate<AsyncValue<void>>((value) {
          //   return value is AsyncError && value.error == exception;
          // }),
          predicate<AsyncValue<void>>((value) {
            expect(value.hasError, true);
            expect(value.error, exception);
            return true;
          }),
        ]),
      ));

      // run
      await controller.signOut();

      // verify
      verify(authRepository.signOut).called(1);
    });
  });
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nut_products_e_shop/src/features/authentication/data/fake_auth_repository.dart';
import 'package:nut_products_e_shop/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:nut_products_e_shop/src/features/cart/domain/cart.dart';
import 'package:nut_products_e_shop/src/features/checkout/service/fake_checkout_service.dart';
import 'package:nut_products_e_shop/src/features/orders/data/fake_orders_repository.dart';
import 'package:nut_products_e_shop/src/features/orders/domain/order.dart';
import 'package:nut_products_e_shop/src/utils/current_date_builder_provider.dart';

import '../../../mocks.dart';

void main() {
  final testDate = DateTime(2022, 7, 13);
  setUpAll(() {
    // needed for MockOrdersRepository
    registerFallbackValue(Order(
      id: '1',
      userId: testUser.uid,
      items: {'1': 1},
      orderStatus: OrderStatus.confirmed,
      orderDate: testDate,
      total: 15,
    ));
    // needed for MockRemoteCartRepository
    registerFallbackValue(const Cart());
  });

  late MockAuthRepository authRepository;
  late MockRemoteCartRepository remoteCartRepository;
  late MockOrdersRepository ordersRepository;
  setUp(() {
    authRepository = MockAuthRepository();
    remoteCartRepository = MockRemoteCartRepository();
    ordersRepository = MockOrdersRepository();
  });

  FakeCheckoutService makeCheckoutService() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        remoteCartRepositoryProvider.overrideWithValue(remoteCartRepository),
        ordersRepositoryProvider.overrideWithValue(ordersRepository),
        currentDateBuilderProvider.overrideWithValue(() => testDate),
      ],
    );
    addTearDown(container.dispose);
    return container.read(checkoutServiceProvider);
  }

  group('placeOrder', () {
    test('null user, throws', () async {
      // setup
      when(() => authRepository.currentUser).thenReturn(null);
      final checkoutService = makeCheckoutService();
      // run
      expect(checkoutService.placeOrder, throwsA(isA<TypeError>()));
    });

    test('empty cart, throws', () async {
      // setup
      when(() => authRepository.currentUser).thenReturn(testUser);
      when(() => remoteCartRepository.fetchCart(testUser.uid)).thenAnswer(
        (_) => Future.value(const Cart()),
      );
      final checkoutService = makeCheckoutService();
      // run
      expect(checkoutService.placeOrder, throwsStateError);
    });

    test('non-empty cart and purchase, empties cart, creates order', () async {
      // setup
      when(() => authRepository.currentUser).thenReturn(testUser);
      when(() => remoteCartRepository.fetchCart(testUser.uid)).thenAnswer(
        (_) => Future.value(const Cart({'1': 1})),
      );
      when(() => ordersRepository.addOrder(testUser.uid, any())).thenAnswer(
        (_) => Future.value(),
      );
      when(() => remoteCartRepository.setCart(testUser.uid, const Cart()))
          .thenAnswer(
        (_) => Future.value(),
      );
      final checkoutService = makeCheckoutService();
      // run
      await checkoutService.placeOrder();
      // verify
      verify(() => ordersRepository.addOrder(testUser.uid, any())).called(1);
      verify(() => remoteCartRepository.setCart(testUser.uid, const Cart()))
          .called(1);
    });
  });
}

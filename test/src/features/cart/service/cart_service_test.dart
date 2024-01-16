import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nut_products_e_shop/src/features/cart/domain/cart.dart';
import 'package:nut_products_e_shop/src/features/cart/domain/item.dart';
import 'package:nut_products_e_shop/src/features/cart/service/cart_service.dart';

import '../../../mocks.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(const Cart());
  });

  late MockAuthRepository authRepository;
  late MockRemoteCartRepository remoteCartRepository;
  late MockLocalCartRepository localCartRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    remoteCartRepository = MockRemoteCartRepository();
    localCartRepository = MockLocalCartRepository();
  });

  CartService makeCartService() {
    return CartService(
      authRepository: authRepository,
      remoteCartRepository: remoteCartRepository,
      localCartRepository: localCartRepository,
    );

    // * Another way if we use Ref for ID instead of repos separately
    // final container = ProviderContainer(
    //   overrides: [
    //     authRepositoryProvider.overrideWithValue(authRepository),
    //     remoteCartRepositoryProvider.overrideWithValue(remoteCartRepository),
    //     localCartRepositoryProvider.overrideWithValue(localCartRepository),
    //   ],
    // );
    // addTearDown(container.dispose);
    // return container.read(cartServiceProvider);
  }

  group('setItem', () {
    test('null user, writes item to local cart', () async {
      // setup
      const expectedCart = Cart({'123': 1});
      when(() => authRepository.currentUser).thenReturn(null);
      when(localCartRepository.fetchCart).thenAnswer(
        (_) => Future.value(const Cart()),
      );
      when(() => localCartRepository.setCart(expectedCart)).thenAnswer(
        (_) => Future.value(),
      );
      final cartService = makeCartService();

      // run
      await cartService.setItem(const Item(productId: '123', quantity: 1));

      // verify
      verify(() => localCartRepository.setCart(expectedCart)).called(1);
      verifyNever(() => remoteCartRepository.setCart(any(), any()));
    });

    test('non-null user, writes item to local cart', () async {
      // setup
      const expectedCart = Cart({'123': 1});
      when(() => authRepository.currentUser).thenReturn(testUser);
      when(
        () => remoteCartRepository.fetchCart(testUser.uid),
      ).thenAnswer(
        (_) => Future.value(const Cart()),
      );
      when(
        () => remoteCartRepository.setCart(testUser.uid, expectedCart),
      ).thenAnswer(
        (_) => Future.value(),
      );
      final cartService = makeCartService();

      // run
      await cartService.setItem(const Item(productId: '123', quantity: 1));

      // verify
      verify(
        () => remoteCartRepository.setCart(testUser.uid, expectedCart),
      ).called(1);
      verifyNever(() => localCartRepository.setCart(any()));
    });
  });
}

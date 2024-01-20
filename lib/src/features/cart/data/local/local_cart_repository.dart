import 'package:nut_products_e_shop/src/features/cart/domain/cart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_cart_repository.g.dart';

/// API for reading, watching and writing local cart data (guest user)
abstract class LocalCartRepository {
  Future<Cart> fetchCart();

  Stream<Cart> watchCart();

  Future<void> setCart(Cart cart);
}

@Riverpod(keepAlive: true)
LocalCartRepository localCartRepository(LocalCartRepositoryRef ref) {
  // The provider is overridden in main.dart which helps to get the
  // repository synchronously.
  throw UnimplementedError();
}

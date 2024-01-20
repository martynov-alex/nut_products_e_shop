import 'package:nut_products_e_shop/src/features/cart/data/remote/fake_remote_cart_repository.dart';
import 'package:nut_products_e_shop/src/features/cart/domain/cart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_cart_repository.g.dart';

/// API for reading, watching and writing cart data for a specific user ID
abstract class RemoteCartRepository {
  Future<Cart> fetchCart(String uid);

  Stream<Cart> watchCart(String uid);

  Future<void> setCart(String uid, Cart cart);
}

@Riverpod(keepAlive: true)
RemoteCartRepository remoteCartRepository(RemoteCartRepositoryRef ref) {
  // TODO(martynov): replace with "real" remote cart repository
  return FakeRemoteCartRepository(addDelay: false);
}

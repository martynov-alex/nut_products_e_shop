import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nut_products_e_shop/src/features/cart/domain/item.dart';
import 'package:nut_products_e_shop/src/features/cart/service/cart_service.dart';
import 'package:nut_products_e_shop/src/features/products/domain/product.dart';

class ShoppingCartScreenController extends StateNotifier<AsyncValue<void>> {
  ShoppingCartScreenController({required this.cartService})
      : super(const AsyncData(null));
  final CartService cartService;

  Future<void> updateItemQuantity(ProductId productId, int quantity) async {
    state = const AsyncLoading();
    final updated = Item(productId: productId, quantity: quantity);
    state = await AsyncValue.guard(() => cartService.setItem(updated));
  }

  Future<void> removeItemById(ProductId productId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => cartService.removeItemById(productId));
  }
}

final shoppingCartScreenControllerProvider =
    StateNotifierProvider<ShoppingCartScreenController, AsyncValue<void>>(
  (ref) {
    final cartService = ref.watch(cartServiceProvider);
    return ShoppingCartScreenController(cartService: cartService);
  },
);

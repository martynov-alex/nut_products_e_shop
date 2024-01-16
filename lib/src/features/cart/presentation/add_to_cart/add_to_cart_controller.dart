import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nut_products_e_shop/src/features/cart/domain/item.dart';
import 'package:nut_products_e_shop/src/features/cart/service/cart_service.dart';
import 'package:nut_products_e_shop/src/features/products/domain/product.dart';

class AddToCartController extends StateNotifier<AsyncValue<int>> {
  AddToCartController({required this.cartService}) : super(const AsyncData(1));

  final CartService cartService;

  void updateQuantity(int quantity) {
    state = AsyncData(quantity);
  }

  Future<void> addItem(ProductID productID) async {
    final item = Item(productId: productID, quantity: state.value!);
    state = const AsyncLoading<int>().copyWithPrevious(state);
    final value = await AsyncValue.guard<void>(() => cartService.addItem(item));
    if (value.hasError) {
      state = AsyncError<int>(value.error!, value.stackTrace!)
          .copyWithPrevious(state);
    } else {
      state = const AsyncData(1);
    }
  }
}

final addToCartControllerProvider =
    StateNotifierProvider.autoDispose<AddToCartController, AsyncValue<int>>(
        (ref) {
  final cartService = ref.watch(cartServiceProvider);
  return AddToCartController(cartService: cartService);
});

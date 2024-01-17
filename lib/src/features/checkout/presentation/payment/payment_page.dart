import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nut_products_e_shop/src/common_widgets/async_value_widget.dart';
import 'package:nut_products_e_shop/src/features/cart/domain/cart.dart';
import 'package:nut_products_e_shop/src/features/cart/presentation/shopping_cart/shopping_cart_item.dart';
import 'package:nut_products_e_shop/src/features/cart/presentation/shopping_cart/shopping_cart_items_builder.dart';
import 'package:nut_products_e_shop/src/features/cart/service/cart_service.dart';
import 'package:nut_products_e_shop/src/features/checkout/presentation/payment/payment_button.dart';
import 'package:nut_products_e_shop/src/routing/app_router.dart';

/// Payment screen showing the items in the cart (with read-only quantities) and
/// a button to checkout.
class PaymentPage extends ConsumerWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<double>(cartTotalProvider, (_, cartTotal) {
      // If the cart total becomes 0, it means that the order has been fullfilled
      // because all the items have been removed from the cart.
      // So we should go to the orders page.
      if (cartTotal == 0.0) {
        context.goNamed(AppRoute.orders.name);
      }
    });

    final cartValue = ref.watch(cartProvider);

    return AsyncValueWidget<Cart>(
      value: cartValue,
      data: (cart) => ShoppingCartItemsBuilder(
        items: cart.toItemsList(),
        itemBuilder: (_, item, index) => ShoppingCartItem(
          item: item,
          itemIndex: index,
          isEditable: false,
        ),
        ctaBuilder: (_) => const PaymentButton(),
      ),
    );
  }
}

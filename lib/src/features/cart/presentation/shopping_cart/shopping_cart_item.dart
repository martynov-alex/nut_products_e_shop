import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nut_products_e_shop/src/common_widgets/alert_dialogs.dart';
import 'package:nut_products_e_shop/src/common_widgets/async_value_widget.dart';
import 'package:nut_products_e_shop/src/common_widgets/custom_image.dart';
import 'package:nut_products_e_shop/src/common_widgets/empty_placeholder_widget.dart';
import 'package:nut_products_e_shop/src/common_widgets/item_quantity_selector.dart';
import 'package:nut_products_e_shop/src/common_widgets/responsive_two_column_layout.dart';
import 'package:nut_products_e_shop/src/constants/app_sizes.dart';
import 'package:nut_products_e_shop/src/features/cart/domain/item.dart';
import 'package:nut_products_e_shop/src/features/checkout/presentation/payment/payment_page.dart';
import 'package:nut_products_e_shop/src/features/products/data/fake_products_repository.dart';
import 'package:nut_products_e_shop/src/features/products/domain/product.dart';
import 'package:nut_products_e_shop/src/localization/string_hardcoded.dart';

/// Shows a shopping cart item (or loading/error UI if needed)
class ShoppingCartItem extends ConsumerWidget {
  const ShoppingCartItem({
    required this.item,
    required this.itemIndex,
    this.isEditable = true,
    super.key,
  });

  final Item item;
  final int itemIndex;

  /// if true, an [ItemQuantitySelector] and a delete button will be shown
  /// if false, the quantity will be shown as a read-only label (used in the
  /// [PaymentPage])
  final bool isEditable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productValue = ref.watch(productProvider(item.productId));

    return AsyncValueWidget<Product?>(
      value: productValue,
      data: (product) => product == null
          ? EmptyPlaceholderWidget(
              message: 'Product not found'.hardcoded,
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.p16),
                  child: ShoppingCartItemContents(
                    product: product,
                    item: item,
                    itemIndex: itemIndex,
                    isEditable: isEditable,
                  ),
                ),
              ),
            ),
    );
  }
}

/// Shows a shopping cart item for a given product
class ShoppingCartItemContents extends StatelessWidget {
  const ShoppingCartItemContents({
    required this.product,
    required this.item,
    required this.itemIndex,
    required this.isEditable,
    super.key,
  });

  final Product product;
  final Item item;
  final int itemIndex;
  final bool isEditable;

  // * Keys for testing using find.byKey()
  static Key deleteKey(int index) => Key('delete-$index');

  @override
  Widget build(BuildContext context) {
    // TODO(martynov): error handling
    // TODO(martynov): Inject formatter
    final priceFormatted = NumberFormat.simpleCurrency().format(product.price);
    return ResponsiveTwoColumnLayout(
      endFlex: 2,
      breakpoint: 320,
      startContent: CustomImage(imageUrl: product.imageUrl),
      spacing: Sizes.p24,
      endContent: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(product.title, style: Theme.of(context).textTheme.headlineSmall),
          gapH24,
          Text(priceFormatted,
              style: Theme.of(context).textTheme.headlineSmall),
          gapH24,
          if (isEditable)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ItemQuantitySelector(
                  quantity: item.quantity,
                  maxQuantity: min(product.availableQuantity, 10),
                  itemIndex: itemIndex,
                  // TODO(martynov): Implement onChanged
                  onChanged: (value) {
                    showNotImplementedAlertDialog(context: context);
                  },
                ),
                IconButton(
                  key: deleteKey(itemIndex),
                  icon: Icon(Icons.delete, color: Colors.red[700]),
                  // TODO(martynov): Implement onPressed
                  onPressed: () {
                    showNotImplementedAlertDialog(context: context);
                  },
                ),
                const Spacer(),
              ],
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
              child: Text(
                'Quantity: ${item.quantity}'.hardcoded,
              ),
            ),
        ],
      ),
    );
  }
}

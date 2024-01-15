import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nut_products_e_shop/src/common_widgets/alert_dialogs.dart';
import 'package:nut_products_e_shop/src/common_widgets/item_quantity_selector.dart';
import 'package:nut_products_e_shop/src/common_widgets/primary_button.dart';
import 'package:nut_products_e_shop/src/constants/app_sizes.dart';
import 'package:nut_products_e_shop/src/features/products/domain/product.dart';
import 'package:nut_products_e_shop/src/localization/string_hardcoded.dart';

/// A widget that shows an [ItemQuantitySelector] along with a [PrimaryButton]
/// to add the selected quantity of the item to the cart.
class AddToCartWidget extends StatelessWidget {
  const AddToCartWidget({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    // TODO(martynov): Read from data source
    const availableQuantity = 5;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Quantity:'.hardcoded),
            ItemQuantitySelector(
              // TODO(martynov): plug in state
              quantity: 1,
              // let the user choose up to the available quantity or
              // 10 items at most
              maxQuantity: min(availableQuantity, 10),
              // TODO(martynov): Implement onChanged
              onChanged: (value) {
                showNotImplementedAlertDialog(context: context);
              },
            ),
          ],
        ),
        gapH8,
        const Divider(),
        gapH8,
        PrimaryButton(
          // TODO(martynov): Loading state
          // ignore: avoid_redundant_argument_values
          isLoading: false,
          // TODO(martynov): Implement onPressed
          onPressed: () {
            showNotImplementedAlertDialog(context: context);
          },
          text: availableQuantity > 0
              ? 'Add to Cart'.hardcoded
              : 'Out of Stock'.hardcoded,
        ),
        if (product.availableQuantity > 0 && availableQuantity == 0) ...[
          gapH8,
          Text(
            'Already added to cart'.hardcoded,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ]
      ],
    );
  }
}

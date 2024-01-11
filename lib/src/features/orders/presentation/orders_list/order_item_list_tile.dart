import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nut_products_e_shop/src/common_widgets/async_value_widget.dart';
import 'package:nut_products_e_shop/src/common_widgets/custom_image.dart';
import 'package:nut_products_e_shop/src/common_widgets/empty_placeholder_widget.dart';
import 'package:nut_products_e_shop/src/constants/app_sizes.dart';
import 'package:nut_products_e_shop/src/features/cart/domain/item.dart';
import 'package:nut_products_e_shop/src/features/products/data/fake_products_repository.dart';
import 'package:nut_products_e_shop/src/features/products/domain/product.dart';
import 'package:nut_products_e_shop/src/localization/string_hardcoded.dart';

/// Shows an individual order item, including price and quantity.
class OrderItemListTile extends ConsumerWidget {
  final Item item;

  const OrderItemListTile({required this.item, super.key});

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
              child: Row(
                children: [
                  Flexible(child: CustomImage(imageUrl: product.imageUrl)),
                  gapW8,
                  Flexible(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.title),
                        gapH12,
                        Text(
                          'Quantity: ${item.quantity}'.hardcoded,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

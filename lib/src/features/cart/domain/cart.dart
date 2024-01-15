import 'package:flutter/foundation.dart';
import 'package:nut_products_e_shop/src/features/cart/domain/item.dart';
import 'package:nut_products_e_shop/src/features/products/domain/product.dart';

/// Model class representing the shopping cart contents.
@immutable
class Cart {
  const Cart([this.items = const {}]);

  /// All the items in the shopping cart, where:
  /// - key: product ID
  /// - value: quantity
  final Map<ProductID, int> items;
}

extension CartItems on Cart {
  List<Item> toItemsList() {
    return items.entries.map((entry) {
      return Item(
        productId: entry.key,
        quantity: entry.value,
      );
    }).toList();
  }
}

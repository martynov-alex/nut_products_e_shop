// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:nut_products_e_shop/src/features/products/domain/product.dart';

/// A product along with a quantity that can be added to an order/cart.
@immutable
class Item {
  const Item({
    required this.productId,
    required this.quantity,
  });

  final ProductID productId;
  final int quantity;

  @override
  String toString() => 'Item(productId: $productId, quantity: $quantity)';

  @override
  bool operator ==(covariant Item other) {
    if (identical(this, other)) return true;

    return other.productId == productId && other.quantity == quantity;
  }

  @override
  int get hashCode => productId.hashCode ^ quantity.hashCode;
}

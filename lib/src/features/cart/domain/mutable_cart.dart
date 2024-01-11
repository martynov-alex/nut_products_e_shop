import 'package:nut_products_e_shop/src/features/cart/domain/cart.dart';
import 'package:nut_products_e_shop/src/features/cart/domain/item.dart';
import 'package:nut_products_e_shop/src/features/products/domain/product.dart';

/// Helper extension used to mutate the items in the shopping cart.
extension MutableCart on Cart {
  Cart addItem(Item item) {
    final copy = Map<ProductID, int>.from(items);
    if (copy.containsKey(item.productId)) {
      copy[item.productId] = item.quantity + copy[item.productId]!;
    } else {
      copy[item.productId] = item.quantity;
    }
    return Cart(copy);
  }

  Cart addItems(List<Item> itemsToAdd) {
    final copy = Map<ProductID, int>.from(items);
    for (final item in itemsToAdd) {
      if (copy.containsKey(item.productId)) {
        copy[item.productId] = item.quantity + copy[item.productId]!;
      } else {
        copy[item.productId] = item.quantity;
      }
    }
    return Cart(copy);
  }

  Cart removeItemById(ProductID productId) {
    final copy = Map<ProductID, int>.from(items)..remove(productId);
    return Cart(copy);
  }

  Cart updateItemIfExists(Item item) {
    if (items.containsKey(item.productId)) {
      final copy = Map<ProductID, int>.from(items);
      copy[item.productId] = item.quantity;
      return Cart(copy);
    } else {
      return this;
    }
  }

  Cart clear() => const Cart();
}

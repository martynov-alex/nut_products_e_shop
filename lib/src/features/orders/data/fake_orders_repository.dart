import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nut_products_e_shop/src/features/orders/domain/order.dart';
import 'package:nut_products_e_shop/src/features/products/domain/product.dart';
import 'package:nut_products_e_shop/src/utils/delay.dart';
import 'package:nut_products_e_shop/src/utils/in_memory_state.dart';

class FakeOrdersRepository {
  FakeOrdersRepository({this.addDelay = true});
  final bool addDelay;

  /// A map of all the orders placed by each user, where:
  /// - key: user ID
  /// - value: list of orders for that user
  final _orders = InMemoryStore<Map<String, List<Order>>>({});

  /// A stream that returns all the orders for a given user, ordered by date.
  /// Only user orders that match the given productId will be returned.
  /// If a productId is not passed, all user orders will be returned.
  Stream<List<Order>> watchUserOrders(String uid, {ProductId? productId}) {
    return _orders.stream.map((ordersData) {
      final ordersList = (ordersData[uid] ?? [])
        ..sort((lhs, rhs) => rhs.orderDate.compareTo(lhs.orderDate));

      if (productId != null) {
        return ordersList
            .where((order) => order.items.keys.contains(productId))
            .toList();
      } else {
        return ordersList;
      }
    });
  }

  // A method to add a new order to the list for a given user
  Future<void> addOrder(String uid, Order order) async {
    await delay(addDelay: addDelay);
    final value = _orders.value;
    final userOrders = (value[uid] ?? [])..add(order);
    value[uid] = userOrders;
    _orders.value = value;
  }
}

final ordersRepositoryProvider = Provider<FakeOrdersRepository>((ref) {
  return FakeOrdersRepository();
});
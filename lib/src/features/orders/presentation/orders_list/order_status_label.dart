import 'package:flutter/material.dart';
import 'package:nut_products_e_shop/src/features/orders/domain/order.dart';
import 'package:nut_products_e_shop/src/localization/string_hardcoded.dart';

/// Shows the status of the order
class OrderStatusLabel extends StatelessWidget {
  final Order order;

  const OrderStatusLabel({required this.order, super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge!;
    switch (order.orderStatus) {
      case OrderStatus.confirmed:
        return Text(
          'Confirmed - preparing for delivery'.hardcoded,
          style: textStyle,
        );
      case OrderStatus.shipped:
        return Text(
          'Shipped'.hardcoded,
          style: textStyle,
        );
      case OrderStatus.delivered:
        return Text(
          'Delivered'.hardcoded,
          style: textStyle.copyWith(color: Colors.green),
        );
    }
  }
}

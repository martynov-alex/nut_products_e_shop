import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nut_products_e_shop/src/common_widgets/async_value_widget.dart';
import 'package:nut_products_e_shop/src/common_widgets/responsive_center.dart';
import 'package:nut_products_e_shop/src/constants/app_sizes.dart';
import 'package:nut_products_e_shop/src/features/orders/presentation/orders_list/order_card.dart';
import 'package:nut_products_e_shop/src/features/orders/service/user_orders_provider.dart';
import 'package:nut_products_e_shop/src/localization/string_hardcoded.dart';

/// Shows the list of orders placed by the signed-in user.
class OrdersListScreen extends StatelessWidget {
  const OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'.hardcoded),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final userOrdersValue = ref.watch(userOrdersProvider);
          return AsyncValueWidget(
            value: userOrdersValue,
            data: (orders) => orders.isEmpty
                ? Center(
                    child: Text(
                      'No previous orders'.hardcoded,
                      style: Theme.of(context).textTheme.displaySmall,
                      textAlign: TextAlign.center,
                    ),
                  )
                : CustomScrollView(
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => ResponsiveCenter(
                            padding: const EdgeInsets.all(Sizes.p8),
                            child: OrderCard(
                              order: orders[index],
                            ),
                          ),
                          childCount: orders.length,
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

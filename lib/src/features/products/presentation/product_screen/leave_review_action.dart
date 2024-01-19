import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nut_products_e_shop/src/common_widgets/custom_text_button.dart';
import 'package:nut_products_e_shop/src/common_widgets/responsive_two_column_layout.dart';
import 'package:nut_products_e_shop/src/constants/app_sizes.dart';
import 'package:nut_products_e_shop/src/features/orders/service/user_orders_provider.dart';
import 'package:nut_products_e_shop/src/features/products/domain/product.dart';
import 'package:nut_products_e_shop/src/features/reviews/service/reviews_service.dart';
import 'package:nut_products_e_shop/src/localization/string_hardcoded.dart';
import 'package:nut_products_e_shop/src/routing/app_router.dart';
import 'package:nut_products_e_shop/src/utils/date_formatter.dart';

/// Simple widget to show the product purchase date along with a button to
/// leave a review.
class LeaveReviewAction extends ConsumerWidget {
  const LeaveReviewAction({required this.productId, super.key});

  final ProductId productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(matchingUserOrdersProvider(productId)).value;

    if (orders != null && orders.isNotEmpty) {
      final dateFormatted =
          ref.watch(dateFormatterProvider).format(orders.first.orderDate);

      return Column(
        children: [
          const Divider(),
          gapH8,
          ResponsiveTwoColumnLayout(
            spacing: Sizes.p16,
            breakpoint: 300,
            startFlex: 3,
            endFlex: 2,
            rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
            rowCrossAxisAlignment: CrossAxisAlignment.center,
            columnCrossAxisAlignment: CrossAxisAlignment.center,
            startContent: Text('Purchased on $dateFormatted'.hardcoded),
            endContent: Consumer(
              builder: (context, ref, _) {
                final reviewValue =
                    ref.watch(userReviewStreamProvider(productId)).value;
                return CustomTextButton(
                  text: reviewValue == null
                      ? 'Leave a review'.hardcoded
                      : 'Update review'.hardcoded,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.green[700]),
                  onPressed: () => context.goNamed(
                    AppRoute.leaveReview.name,
                    pathParameters: {'id': productId},
                  ),
                );
              },
            ),
          ),
          gapH8,
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

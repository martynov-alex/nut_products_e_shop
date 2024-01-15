import 'package:flutter/material.dart';
import 'package:nut_products_e_shop/src/common_widgets/responsive_center.dart';
import 'package:nut_products_e_shop/src/constants/app_sizes.dart';
import 'package:nut_products_e_shop/src/constants/breakpoints.dart';
import 'package:nut_products_e_shop/src/features/reviews/domain/review.dart';
import 'package:nut_products_e_shop/src/features/reviews/presentation/product_reviews/product_review_card.dart';

/// Shows the list of reviews for a given product ID
class ProductReviewsList extends StatelessWidget {
  const ProductReviewsList({required this.productId, super.key});

  final String productId;

  @override
  Widget build(BuildContext context) {
    // TODO(martynov): Read from data source
    final reviews = <Review>[
      Review(
        date: DateTime(2022, 2, 12),
        score: 4.5,
        comment: 'Great product, would buy again!',
      ),
      Review(
        date: DateTime(2022, 2, 10),
        score: 4.0,
        comment: 'Looks great but the packaging was damaged.',
      ),
    ];
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => ResponsiveCenter(
          maxContentWidth: Breakpoint.tablet,
          padding: const EdgeInsets.symmetric(
              horizontal: Sizes.p16, vertical: Sizes.p8),
          child: ProductReviewCard(reviews[index]),
        ),
        childCount: reviews.length,
      ),
    );
  }
}

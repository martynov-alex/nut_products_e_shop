import 'package:flutter/material.dart';
import 'package:nut_products_e_shop/src/constants/app_sizes.dart';
import 'package:nut_products_e_shop/src/features/products/domain/product.dart';

/// Shows the product average rating score and the number of ratings
class ProductAverageRating extends StatelessWidget {
  const ProductAverageRating({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Flexible(
          child: Icon(
            Icons.star,
            color: Colors.amber,
          ),
        ),
        gapW8,
        Flexible(
          child: Text(
            product.avgRating.toStringAsFixed(1),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        gapW8,
        Expanded(
          child: Text(
            product.numRatings == 1
                ? '1 rating'
                : '${product.numRatings} ratings',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

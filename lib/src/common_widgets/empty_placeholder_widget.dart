import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nut_products_e_shop/src/common_widgets/primary_button.dart';
import 'package:nut_products_e_shop/src/constants/app_sizes.dart';
import 'package:nut_products_e_shop/src/localization/string_hardcoded.dart';
import 'package:nut_products_e_shop/src/routing/app_router.dart';

/// Placeholder widget showing a message and CTA to go back to the home screen.
class EmptyPlaceholderWidget extends StatelessWidget {
  final String message;

  const EmptyPlaceholderWidget({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.p16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            gapH32,
            PrimaryButton(
              onPressed: () => context.goNamed(AppRoutes.home.name),
              text: 'Go Home'.hardcoded,
            )
          ],
        ),
      ),
    );
  }
}

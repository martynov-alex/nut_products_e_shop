import 'package:flutter/material.dart';
import 'package:nut_products_e_shop/src/constants/app_sizes.dart';

/// Custom [DecoratedBox] widget with shadow to be used at the bottom of the
/// screen on mobile. Useful for pinning CTAs such as checkout buttons etc.
class DecoratedBoxWithShadow extends StatelessWidget {
  final Widget child;

  const DecoratedBoxWithShadow({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0),
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: child,
      ),
    );
  }
}

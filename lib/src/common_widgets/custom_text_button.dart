import 'package:flutter/material.dart';
import 'package:nut_products_e_shop/src/constants/app_sizes.dart';

/// Custom text button with a fixed height.
class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    required this.text,
    this.style,
    this.onPressed,
    super.key,
  });

  final String text;
  final TextStyle? style;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Sizes.p48,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: style,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

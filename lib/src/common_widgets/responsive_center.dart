import 'package:flutter/material.dart';
import 'package:nut_products_e_shop/src/constants/breakpoints.dart';

/// Reusable widget for showing a child with a maximum content width constraint.
/// If available width is larger than the maximum width, the child will be
/// centered.
/// If available width is smaller than the maximum width, the child use all the
/// available width.
class ResponsiveCenter extends StatelessWidget {
  final double maxContentWidth;
  final EdgeInsetsGeometry padding;
  final Widget child;

  const ResponsiveCenter({
    required this.child,
    this.maxContentWidth = Breakpoint.desktop,
    this.padding = EdgeInsets.zero,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Use Center as it has *unconstrained* width (loose constraints)
    return Center(
      // together with SizedBox to specify the max width (tight constraints)
      // See this thread for more info:
      // https://twitter.com/biz84/status/1445400059894542337
      child: SizedBox(
        width: maxContentWidth,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

/// Sliver-equivalent of [ResponsiveCenter].
class ResponsiveSliverCenter extends StatelessWidget {
  final double maxContentWidth;
  final EdgeInsetsGeometry padding;
  final Widget child;

  const ResponsiveSliverCenter({
    required this.child,
    this.maxContentWidth = Breakpoint.desktop,
    this.padding = EdgeInsets.zero,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ResponsiveCenter(
        maxContentWidth: maxContentWidth,
        padding: padding,
        child: child,
      ),
    );
  }
}

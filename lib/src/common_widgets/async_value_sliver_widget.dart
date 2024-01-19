import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nut_products_e_shop/src/common_widgets/async_value_widget.dart';
import 'package:nut_products_e_shop/src/common_widgets/error_message_widget.dart';

/// Sliver equivalent of [AsyncValueWidget].
class AsyncValueSliverWidget<T> extends StatelessWidget {
  const AsyncValueSliverWidget({
    required this.value,
    required this.data,
    this.error,
    this.loading,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T) data;
  final Widget Function(Object, StackTrace)? error;
  final Widget Function()? loading;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: loading ??
          () => const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              ),
      error: error ??
          (e, st) => SliverToBoxAdapter(
                child: Center(child: ErrorMessageWidget(e.toString())),
              ),
    );
  }
}

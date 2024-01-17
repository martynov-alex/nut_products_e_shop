import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nut_products_e_shop/src/common_widgets/primary_button.dart';
import 'package:nut_products_e_shop/src/features/checkout/presentation/payment/payment_button_controller.dart';
import 'package:nut_products_e_shop/src/localization/string_hardcoded.dart';
import 'package:nut_products_e_shop/src/utils/async_value_ui.dart';

/// Button used to initiate the payment flow.
class PaymentButton extends ConsumerWidget {
  const PaymentButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(
      paymentButtonControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final state = ref.watch(paymentButtonControllerProvider);

    return PrimaryButton(
      text: 'Pay'.hardcoded,
      // ignore: avoid_redundant_argument_values
      isLoading: state.isLoading,
      onPressed: state.isLoading
          ? null
          : () => ref.read(paymentButtonControllerProvider.notifier).pay(),
    );
  }
}

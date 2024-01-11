import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nut_products_e_shop/src/common_widgets/alert_dialogs.dart';
import 'package:nut_products_e_shop/src/common_widgets/primary_button.dart';
import 'package:nut_products_e_shop/src/localization/string_hardcoded.dart';

/// Button used to initiate the payment flow.
class PaymentButton extends StatelessWidget {
  const PaymentButton({super.key});

  Future<void> _pay(BuildContext context) async {
    // TODO(martynov): Implement
    unawaited(showNotImplementedAlertDialog(context: context));
  }

  @override
  Widget build(BuildContext context) {
    // TODO(martynov): error handling
    // TODO(martynov): loading state
    return PrimaryButton(
      text: 'Pay'.hardcoded,
      // ignore: avoid_redundant_argument_values
      isLoading: false,
      onPressed: () => _pay(context),
    );
  }
}

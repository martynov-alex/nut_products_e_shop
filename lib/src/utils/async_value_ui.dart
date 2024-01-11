import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nut_products_e_shop/src/common_widgets/alert_dialogs.dart';
import 'package:nut_products_e_shop/src/localization/string_hardcoded.dart';

extension AsyncValueUI on AsyncValue {
  void showAlertDialogOnError(
    BuildContext context, {
    String? title,
    String? message,
  }) {
    if (hasError && !isLoading) {
      showExceptionAlertDialog(
        context: context,
        title: title ?? 'Error'.hardcoded,
        message: message ?? error.toString(),
      );
    }
  }
}

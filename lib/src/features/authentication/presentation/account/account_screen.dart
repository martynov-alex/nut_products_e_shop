import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nut_products_e_shop/src/common_widgets/action_text_button.dart';
import 'package:nut_products_e_shop/src/common_widgets/alert_dialogs.dart';
import 'package:nut_products_e_shop/src/common_widgets/responsive_center.dart';
import 'package:nut_products_e_shop/src/constants/app_sizes.dart';
import 'package:nut_products_e_shop/src/features/authentication/data/fake_auth_repository.dart';
import 'package:nut_products_e_shop/src/features/authentication/presentation/account/account_screen_controller.dart';
import 'package:nut_products_e_shop/src/localization/string_hardcoded.dart';
import 'package:nut_products_e_shop/src/utils/async_value_ui.dart';

/// Simple account screen showing some user info and a logout button.
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // error listener
    ref.listen<AsyncValue<void>>(
      accountScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    Future<void> signOut() async {
      final logout = await showAlertDialog(
        context: context,
        title: 'Are you sure?'.hardcoded,
        cancelActionText: 'Cancel'.hardcoded,
        defaultActionText: 'Logout'.hardcoded,
      );
      if (logout ?? false) {
        unawaited(ref.read(accountScreenControllerProvider.notifier).signOut());
      }
    }

    final state = ref.watch(accountScreenControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Account'.hardcoded),
        actions: [
          SizedBox(
            width: 136,
            child: Center(
              child: state.isLoading
                  ? const SizedBox.square(
                      dimension: Sizes.p24,
                      child: CircularProgressIndicator(),
                    )
                  : ActionTextButton(
                      text: 'Logout'.hardcoded,
                      onPressed: state.isLoading ? null : signOut,
                    ),
            ),
          ),
        ],
      ),
      body: const ResponsiveCenter(
        padding: EdgeInsets.symmetric(horizontal: Sizes.p16),
        child: UserDataTable(),
      ),
    );
  }
}

/// Simple user data table showing the uid and email
class UserDataTable extends ConsumerWidget {
  const UserDataTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = Theme.of(context).textTheme.titleSmall!;
    final user = ref.watch(authStateChangesProvider).value;

    return DataTable(
      columns: [
        DataColumn(
          label: Text(
            'Field'.hardcoded,
            style: style,
          ),
        ),
        DataColumn(
          label: Text(
            'Value'.hardcoded,
            style: style,
          ),
        ),
      ],
      rows: [
        _makeDataRow(
          'uid'.hardcoded,
          user?.uid ?? '',
          style,
        ),
        _makeDataRow(
          'email'.hardcoded,
          user?.email ?? '',
          style,
        ),
      ],
    );
  }

  DataRow _makeDataRow(String name, String value, TextStyle style) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            name,
            style: style,
          ),
        ),
        DataCell(
          Text(
            value,
            style: style,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}

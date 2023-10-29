import 'package:nut_products_e_shop/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:nut_products_e_shop/src/features/authentication/domain/app_user.dart';
import 'package:go_router/go_router.dart';
import 'package:nut_products_e_shop/src/routing/app_router.dart';

enum PopupMenuOption {
  signIn,
  orders,
  account,
}

class MoreMenuButton extends StatelessWidget {
  const MoreMenuButton({super.key, this.user});
  final AppUser? user;

  // * Keys for testing using find.byKey()
  static const signInKey = Key('menuSignIn');
  static const ordersKey = Key('menuOrders');
  static const accountKey = Key('menuAccount');

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        // three vertical dots icon (to reveal menu options)
        icon: const Icon(Icons.more_vert),
        itemBuilder: (_) {
          // show all the options based on conditional logic
          return user != null
              ? <PopupMenuEntry<PopupMenuOption>>[
                  PopupMenuItem(
                    key: ordersKey,
                    value: PopupMenuOption.orders,
                    child: Text('Orders'.hardcoded),
                  ),
                  PopupMenuItem(
                    key: accountKey,
                    value: PopupMenuOption.account,
                    child: Text('Account'.hardcoded),
                  ),
                ]
              : <PopupMenuEntry<PopupMenuOption>>[
                  PopupMenuItem(
                    key: signInKey,
                    value: PopupMenuOption.signIn,
                    child: Text('Sign In'.hardcoded),
                  ),
                ];
        },
        onSelected: (option) => switch (option) {
              PopupMenuOption.signIn =>
                context.pushNamed(AppRoutes.signIn.name),
              PopupMenuOption.orders =>
                context.pushNamed(AppRoutes.orders.name),
              PopupMenuOption.account =>
                context.pushNamed(AppRoutes.account.name),
            });
  }
}

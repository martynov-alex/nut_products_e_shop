import 'package:nut_products_e_shop/src/constants/breakpoints.dart';
import 'package:nut_products_e_shop/src/localization/string_hardcoded.dart';
import 'package:nut_products_e_shop/src/features/authentication/domain/app_user.dart';
import 'package:flutter/material.dart';
import 'package:nut_products_e_shop/src/common_widgets/action_text_button.dart';
import 'package:nut_products_e_shop/src/features/products/presentation/home_app_bar/more_menu_button.dart';
import 'package:nut_products_e_shop/src/features/products/presentation/home_app_bar/shopping_cart_icon.dart';
import 'package:go_router/go_router.dart';
import 'package:nut_products_e_shop/src/routing/app_router.dart';

/// Custom [AppBar] widget that is reused by the [ProductsListScreen] and
/// [ProductScreen].
/// It shows the following actions, depending on the application state:
/// - [ShoppingCartIcon]
/// - Orders button
/// - Account or Sign-in button
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: get user from auth repository
    const user = AppUser(uid: '123', email: 'test@test.com');
    // * This widget is responsive.
    // * On large screen sizes, it shows all the actions in the app bar.
    // * On small screen sizes, it shows only the shopping cart icon and a
    // * [MoreMenuButton].
    // ! MediaQuery is used on the assumption that the widget takes up the full
    // ! width of the screen. If that's not the case, LayoutBuilder should be
    // ! used instead.
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < Breakpoint.tablet) {
      return AppBar(
        title: Text('My Shop'.hardcoded),
        actions: const [
          ShoppingCartIcon(),
          MoreMenuButton(user: user),
        ],
      );
    } else {
      return AppBar(
        title: Text('My Shop'.hardcoded),
        actions: [
          const ShoppingCartIcon(),
          if (user != null) ...[
            ActionTextButton(
              key: MoreMenuButton.ordersKey,
              text: 'Orders'.hardcoded,
              onPressed: () => context.pushNamed(AppRoutes.orders.name),
            ),
            ActionTextButton(
              key: MoreMenuButton.accountKey,
              text: 'Account'.hardcoded,
              onPressed: () => context.pushNamed(AppRoutes.account.name),
            ),
          ] else
            ActionTextButton(
              key: MoreMenuButton.signInKey,
              text: 'Sign In'.hardcoded,
              onPressed: () => context.pushNamed(AppRoutes.signIn.name),
            )
        ],
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}

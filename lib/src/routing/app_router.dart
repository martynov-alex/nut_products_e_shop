import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nut_products_e_shop/src/features/account/account_screen.dart';
import 'package:nut_products_e_shop/src/features/orders_list/orders_list_screen.dart';
import 'package:nut_products_e_shop/src/features/product_page/product_screen.dart';
import 'package:nut_products_e_shop/src/features/products_list/products_list_screen.dart';
import 'package:nut_products_e_shop/src/features/shopping_cart/shopping_cart_screen.dart';
import 'package:nut_products_e_shop/src/features/sign_in/email_password_sign_in_screen.dart';
import 'package:nut_products_e_shop/src/features/sign_in/email_password_sign_in_state.dart';

enum AppRoutes {
  home('/'),
  product('product/:id'),
  cart('cart'),
  orders('orders'),
  account('account'),
  signIn('signIn');

  const AppRoutes(this.path);

  final String path;
}

final goRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoutes.home.path,
      name: AppRoutes.home.name,
      builder: (context, state) => const ProductsListScreen(),
      routes: [
        GoRoute(
          path: AppRoutes.product.path,
          name: AppRoutes.product.name,
          builder: (context, state) {
            final productId = state.pathParameters['id']!;
            return ProductScreen(productId: productId);
          },
        ),
        GoRoute(
          path: AppRoutes.cart.path,
          name: AppRoutes.cart.name,
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            fullscreenDialog: true,
            child: const ShoppingCartScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.orders.path,
          name: AppRoutes.orders.name,
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            fullscreenDialog: true,
            child: const OrdersListScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.account.path,
          name: AppRoutes.account.name,
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            fullscreenDialog: true,
            child: const AccountScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.signIn.path,
          name: AppRoutes.signIn.name,
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            fullscreenDialog: true,
            child: const EmailPasswordSignInScreen(
              formType: EmailPasswordSignInFormType.signIn,
            ),
          ),
        ),
      ],
    ),
  ],
);

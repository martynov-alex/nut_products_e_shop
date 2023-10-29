import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nut_products_e_shop/src/features/authentication/presentation/account/account_screen.dart';
import 'package:nut_products_e_shop/src/features/checkout/presentation/checkout_screen/checkout_screen.dart';
import 'package:nut_products_e_shop/src/features/reviews/presentation/leave_review_page/leave_review_screen.dart';
import 'package:nut_products_e_shop/src/routing/not_found_screen.dart';
import 'package:nut_products_e_shop/src/features/orders/presentation/orders_list/orders_list_screen.dart';
import 'package:nut_products_e_shop/src/features/products/presentation/product_screen/product_screen.dart';
import 'package:nut_products_e_shop/src/features/products/presentation/products_list/products_list_screen.dart';
import 'package:nut_products_e_shop/src/features/cart/presentation/shopping_cart/shopping_cart_screen.dart';
import 'package:nut_products_e_shop/src/features/authentication/presentation/sign_in/email_password_sign_in_screen.dart';
import 'package:nut_products_e_shop/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';

enum AppRoutes {
  home('/'),
  product('product/:id'),
  leaveReview('review'),
  cart('cart'),
  checkout('checkout'),
  orders('orders'),
  account('account'),
  signIn('signIn');

  const AppRoutes(this.path);

  final String path;
}

final goRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: false,
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
          routes: [
            GoRoute(
              path: AppRoutes.leaveReview.path,
              name: AppRoutes.leaveReview.name,
              pageBuilder: (context, state) {
                final productId = state.pathParameters['id']!;

                return MaterialPage(
                  fullscreenDialog: true,
                  child: LeaveReviewScreen(productId: productId),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.cart.path,
          name: AppRoutes.cart.name,
          pageBuilder: (context, state) => const MaterialPage(
            fullscreenDialog: true,
            child: ShoppingCartScreen(),
          ),
          routes: [
            GoRoute(
              path: AppRoutes.checkout.path,
              name: AppRoutes.checkout.name,
              pageBuilder: (context, state) => const MaterialPage(
                fullscreenDialog: true,
                child: CheckoutScreen(),
              ),
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.orders.path,
          name: AppRoutes.orders.name,
          pageBuilder: (context, state) => const MaterialPage(
            fullscreenDialog: true,
            child: OrdersListScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.account.path,
          name: AppRoutes.account.name,
          pageBuilder: (context, state) => const MaterialPage(
            fullscreenDialog: true,
            child: AccountScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.signIn.path,
          name: AppRoutes.signIn.name,
          pageBuilder: (context, state) => const MaterialPage(
            fullscreenDialog: true,
            child: EmailPasswordSignInScreen(
              formType: EmailPasswordSignInFormType.signIn,
            ),
          ),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => const NotFoundScreen(),
);

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nut_products_e_shop/src/features/authentication/data/fake_auth_repository.dart';
import 'package:nut_products_e_shop/src/features/authentication/domain/app_user.dart';

class CartSyncService {
  CartSyncService(this.ref) {
    _init();
  }

  final Ref ref;

  void _init() {
    ref.listen<AsyncValue<AppUser?>>(
      authStateChangesProvider,
      (previousState, state) {
        final previousUser = previousState?.value;
        final user = state.value;
        if (previousUser == null && user != null) {
          debugPrint('User signed in: ${user.uid}');
        }
      },
    );
  }
}

final cartSyncServiceProvider = Provider<CartSyncService>((ref) {
  return CartSyncService(ref);
});

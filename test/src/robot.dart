import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nut_products_e_shop/src/app.dart';
import 'package:nut_products_e_shop/src/constants/test_products.dart';
import 'package:nut_products_e_shop/src/features/authentication/data/fake_auth_repository.dart';
import 'package:nut_products_e_shop/src/features/products/data/fake_products_repository.dart';
import 'package:nut_products_e_shop/src/features/products/presentation/products_list/product_card.dart';

class Robot {
  final WidgetTester tester;

  Robot(this.tester);

  Future<void> pumpMyApp() async {
    final productsRepository = FakeProductsRepository(addDelay: false);
    final authRepository = FakeAuthRepository(addDelay: false);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          productsRepositoryProvider.overrideWithValue(productsRepository),
          authRepositoryProvider.overrideWithValue(authRepository),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  void expectFindAllProductCards() {
    final finder = find.byType(ProductCard);
    expect(finder, findsNWidgets(kTestProducts.length));
  }
}

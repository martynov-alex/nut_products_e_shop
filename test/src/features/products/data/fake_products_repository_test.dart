import 'package:flutter_test/flutter_test.dart';
import 'package:nut_products_e_shop/src/constants/test_products.dart';
import 'package:nut_products_e_shop/src/features/products/data/fake_products_repository.dart';

void main() {
  FakeProductsRepository makeFakeProductsRepository() =>
      FakeProductsRepository(addDelay: false);

  group('FakeProductsRepository sync methods', () {
    test('getProductsList returns global list', () {
      final productsRepository = makeFakeProductsRepository();
      expect(
        productsRepository.getProductsList(),
        kTestProducts,
      );
    });

    test('getProduct(1) returns first product', () {
      final productsRepository = makeFakeProductsRepository();
      expect(
        productsRepository.getProduct('1'),
        kTestProducts[0],
      );
    });

    test('getProduct returns null for unexpected products id', () {
      final productsRepository = makeFakeProductsRepository();
      final unexpectedId = (kTestProducts.length + 1).toString();
      expect(
        productsRepository.getProduct(unexpectedId),
        null,
      );
    });
  });

  group('FakeProductsRepository async methods', () {
    test('fetchProductsList returns global list', () async {
      final productsRepository = makeFakeProductsRepository();
      expect(
        await productsRepository.fetchProductsList(),
        kTestProducts,
      );
    });

    test('watchProductsList emits global list', () {
      final productsRepository = makeFakeProductsRepository();
      expect(
        productsRepository.watchProductsList(),
        emits(kTestProducts),
      );
    });

    test('fetchProduct(1) returns first product', () async {
      final productsRepository = makeFakeProductsRepository();
      expect(
        await productsRepository.fetchProduct('1'),
        kTestProducts[0],
      );
    });

    test('fetchProduct returns null for unexpected products id', () async {
      final productsRepository = makeFakeProductsRepository();
      final unexpectedId = (kTestProducts.length + 1).toString();
      expect(
        await productsRepository.fetchProduct(unexpectedId),
        null,
      );
    });

    test('watchProduct(1) emits first product', () {
      final productsRepository = makeFakeProductsRepository();
      expect(
        productsRepository.watchProduct('1'),
        emits(kTestProducts[0]),
      );
    });

    test('watchProduct emits null for unexpected products id', () {
      final productsRepository = makeFakeProductsRepository();
      final unexpectedId = (kTestProducts.length + 1).toString();
      expect(
        productsRepository.watchProduct(unexpectedId),
        emits(null),
      );
    });
  });
}

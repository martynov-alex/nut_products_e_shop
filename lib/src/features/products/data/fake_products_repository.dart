import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nut_products_e_shop/src/constants/test_products.dart';
import 'package:nut_products_e_shop/src/features/products/domain/product.dart';

class FakeProductsRepository {
  final _products = kTestProducts;

  Future<List<Product>> fetchProductsList() async {
    await Future.delayed(const Duration(seconds: 2));
    return Future.value(_products);
  }

  Stream<List<Product>> watchProductsList() async* {
    await Future.delayed(const Duration(seconds: 2));
    yield _products;
  }

  Future<Product?> fetchProduct(String id) async => Future.value(
        _products.firstWhereOrNull((product) => product.id == id),
      );

  Stream<Product?> watchProduct(String id) => watchProductsList().map(
        (products) => products.firstWhereOrNull((product) => product.id == id),
      );
}

final productsRepositoryProvider = Provider<FakeProductsRepository>((ref) {
  return FakeProductsRepository();
});

final productsListStreamProvider =
    StreamProvider.autoDispose<List<Product>>((ref) {
  final repository = ref.watch(productsRepositoryProvider);
  return repository.watchProductsList();
});

final productsListFutureProvider =
    FutureProvider.autoDispose<List<Product>>((ref) {
  final repository = ref.watch(productsRepositoryProvider);
  return repository.fetchProductsList();
});

final productProvider = StreamProvider.autoDispose.family<Product?, String>(
  (ref, id) {
    final repository = ref.watch(productsRepositoryProvider);
    return repository.watchProduct(id);
  },
);

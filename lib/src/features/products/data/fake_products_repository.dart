// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nut_products_e_shop/src/constants/test_products.dart';
import 'package:nut_products_e_shop/src/features/products/domain/product.dart';
import 'package:nut_products_e_shop/src/utils/delay.dart';

class FakeProductsRepository {
  final bool addDelay;
  final _products = kTestProducts;

  FakeProductsRepository({this.addDelay = true});

  List<Product> getProductsList() => _products;

  Product? getProduct(String id) =>
      _products.firstWhereOrNull((product) => product.id == id);

  Future<List<Product>> fetchProductsList() async {
    await delay(addDelay: addDelay);
    return Future.value(_products);
  }

  Stream<List<Product>> watchProductsList() async* {
    await delay(addDelay: addDelay);
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
  // * Set addDelay to false for faster loading
  return FakeProductsRepository(addDelay: false);
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

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nut_products_e_shop/src/constants/test_products.dart';
import 'package:nut_products_e_shop/src/features/products/domain/product.dart';
import 'package:nut_products_e_shop/src/utils/delay.dart';
import 'package:nut_products_e_shop/src/utils/in_memory_state.dart';

class FakeProductsRepository {
  FakeProductsRepository({this.addDelay = true});

  final bool addDelay;

  /// Preload with the default list of products when the app starts
  final _products = InMemoryStore<List<Product>>(List.from(kTestProducts));

  List<Product> getProductsList() => _products.value;

  Product? getProduct(String id) =>
      _products.value.firstWhereOrNull((product) => product.id == id);

  Future<List<Product>> fetchProductsList() async {
    await delay(addDelay: addDelay);
    return Future.value(_products.value);
  }

  Stream<List<Product>> watchProductsList() async* {
    await delay(addDelay: addDelay);
    yield _products.value;
  }

  Future<Product?> fetchProduct(String id) async => Future.value(
        _products.value.firstWhereOrNull((product) => product.id == id),
      );

  Stream<Product?> watchProduct(String id) => watchProductsList().map(
        (products) => products.firstWhereOrNull((product) => product.id == id),
      );

  /// Update product or add a new one
  Future<void> setProduct(Product product) async {
    await delay(addDelay: addDelay);
    final products = _products.value;
    final index = products.indexWhere((p) => p.id == product.id);
    if (index == -1) {
      // if not found, add as a new product
      products.add(product);
    } else {
      // else, overwrite previous product
      products[index] = product;
    }
    _products.value = products;
  }
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

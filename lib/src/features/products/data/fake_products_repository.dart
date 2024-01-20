import 'dart:async';

import 'package:collection/collection.dart';
import 'package:nut_products_e_shop/src/constants/test_products.dart';
import 'package:nut_products_e_shop/src/features/products/domain/product.dart';
import 'package:nut_products_e_shop/src/utils/delay.dart';
import 'package:nut_products_e_shop/src/utils/in_memory_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fake_products_repository.g.dart';

class FakeProductsRepository {
  FakeProductsRepository({this.addDelay = true});

  final bool addDelay;

  /// Preload with the default list of products when the app starts.
  final _products = InMemoryStore<List<Product>>(List.from(kTestProducts));

  List<Product> getProductsList() => _products.value;

  Product? getProduct(String id) => _getProduct(_products.value, id);

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

  Stream<Product?> watchProduct(String id) =>
      watchProductsList().map((products) => _getProduct(products, id));

  /// Update product or add a new one.
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

  /// Search for products where the title contains the search query.
  Future<List<Product>> searchProducts(String query) async {
    assert(
      _products.value.length <= 100,
      'Client-side search should only be performed if the number of products is small. '
      'Consider doing server-side search for larger datasets.',
    );

    // get all products
    final productsList = await fetchProductsList();

    // match all products where the title contains the search query
    return productsList
        .where((product) =>
            product.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  final productsListSearchProvider = FutureProvider.autoDispose
      .family<List<Product>, String>((ref, query) async {
    final link = ref.keepAlive();
    final timer = Timer(const Duration(seconds: 5), link.close);
    ref.onDispose(timer.cancel);
    final productsRepository = ref.watch(productsRepositoryProvider);
    return productsRepository.searchProducts(query);
  });

  static Product? _getProduct(List<Product> products, String id) =>
      products.firstWhereOrNull((product) => product.id == id);
}

@riverpod
FakeProductsRepository productsRepository(ProductsRepositoryRef ref) {
  // * Set addDelay to false for faster loading
  return FakeProductsRepository(addDelay: false);
}

@riverpod
Stream<List<Product>> productsListStream(ProductsListStreamRef ref) {
  final repository = ref.watch(productsRepositoryProvider);
  return repository.watchProductsList();
}

@riverpod
Future<List<Product>> productsListFuture(ProductsListFutureRef ref) {
  final repository = ref.watch(productsRepositoryProvider);
  return repository.fetchProductsList();
}

@riverpod
Stream<Product?> product(ProductRef ref, ProductId id) {
  final repository = ref.watch(productsRepositoryProvider);
  return repository.watchProduct(id);
}

@riverpod
FutureOr<List<Product>> productsListSearch(
  ProductsListSearchRef ref,
  String query,
) async {
  final link = ref.keepAlive();
  // * keep previous search results in memory for 60 seconds
  final timer = Timer(const Duration(seconds: 60), link.close);
  ref.onDispose(timer.cancel);
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.searchProducts(query);
}

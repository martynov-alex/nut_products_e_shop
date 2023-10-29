import 'package:collection/collection.dart';
import 'package:nut_products_e_shop/src/constants/test_products.dart';
import 'package:nut_products_e_shop/src/features/products/domain/product.dart';

class FakeProductsRepository {
  FakeProductsRepository._();
  static FakeProductsRepository instance = FakeProductsRepository._();

  final _products = kTestProducts;

  List<Product> getProducts() => _products;

  Product? getProduct(String id) =>
      _products.firstWhereOrNull((product) => product.id == id);

  Future<List<Product>> fetchProducts() async => Future.value(_products);

  Stream<List<Product>> watchProducts() => Stream.value(_products);

  Future<Product?> fetchProduct(String id) async => Future.value(
        _products.firstWhereOrNull((product) => product.id == id),
      );

  Stream<Product?> watchProduct(String id) => watchProducts().map(
        (products) => products.firstWhereOrNull((product) => product.id == id),
      );
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nut_products_e_shop/src/features/products/data/fake_products_repository.dart';
import 'package:nut_products_e_shop/src/features/products/domain/product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'products_search_state_provider.g.dart';

final productsSearchQueryStateProvider =
    StateProvider.autoDispose<String>((ref) => '');

@riverpod
Future<List<Product>> productsSearchResults(ProductsSearchResultsRef ref) {
  final searchQuery = ref.watch(productsSearchQueryStateProvider);
  return ref.watch(productsListSearchProvider(searchQuery).future);
}

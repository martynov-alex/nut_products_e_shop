import 'package:flutter/foundation.dart';
import 'package:nut_products_e_shop/src/features/cart/data/local/local_cart_repository.dart';
import 'package:nut_products_e_shop/src/features/cart/domain/cart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

class SembastCartRepository implements LocalCartRepository {
  SembastCartRepository._(this._db);

  final Database _db;
  final _store = StoreRef.main();

  static Future<Database> _createDatabase(String filename) async {
    if (kIsWeb) return databaseFactoryWeb.openDatabase(filename);

    final appDocDir = await getApplicationDocumentsDirectory();
    return databaseFactoryIo.openDatabase('${appDocDir.path}/$filename');
  }

  static Future<SembastCartRepository> makeDefault() async {
    final db = await _createDatabase('cart.db');
    return SembastCartRepository._(db);
  }

  static const cartItemsKey = 'cartItems';

  @override
  Future<Cart> fetchCart() async {
    final cartJson = await _store.record(cartItemsKey).get(_db) as String?;
    if (cartJson == null) return const Cart();
    return Cart.fromJson(cartJson);
  }

  @override
  Stream<Cart> watchCart() {
    final record = _store.record(cartItemsKey);
    return record.onSnapshot(_db).map((snapshot) {
      if (snapshot == null) return const Cart();
      return Cart.fromJson(snapshot.value as String);
    });
  }

  @override
  Future<void> setCart(Cart cart) {
    return _store.record(cartItemsKey).put(_db, cart.toJson());
  }

  // call this when the DB is no longer needed
  void dispose() => _db.close();
}

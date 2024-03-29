import 'package:mocktail/mocktail.dart';
import 'package:nut_products_e_shop/src/features/authentication/data/fake_auth_repository.dart';
import 'package:nut_products_e_shop/src/features/authentication/domain/app_user.dart';
import 'package:nut_products_e_shop/src/features/cart/data/local/local_cart_repository.dart';
import 'package:nut_products_e_shop/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:nut_products_e_shop/src/features/cart/service/cart_service.dart';
import 'package:nut_products_e_shop/src/features/checkout/service/fake_checkout_service.dart';
import 'package:nut_products_e_shop/src/features/orders/data/fake_orders_repository.dart';
import 'package:nut_products_e_shop/src/features/products/data/fake_products_repository.dart';
import 'package:nut_products_e_shop/src/features/reviews/data/fake_reviews_repository.dart';
import 'package:nut_products_e_shop/src/features/reviews/service/reviews_service.dart';

const testEmail = 'test@test.ru';
const testPassword = 'test1234';
final testUser = AppUser(
  uid: testEmail.split('').reversed.join(),
  email: testEmail,
);

class Listener<T> extends Mock {
  void call(T? previous, T next);
}

class MockAuthRepository extends Mock implements FakeAuthRepository {}

class MockRemoteCartRepository extends Mock implements RemoteCartRepository {}

class MockLocalCartRepository extends Mock implements LocalCartRepository {}

class MockCartService extends Mock implements CartService {}

class MockProductsRepository extends Mock implements FakeProductsRepository {}

class MockOrdersRepository extends Mock implements FakeOrdersRepository {}

class MockCheckoutService extends Mock implements FakeCheckoutService {}

class MockReviewsRepository extends Mock implements FakeReviewsRepository {}

class MockReviewsService extends Mock implements ReviewsService {}

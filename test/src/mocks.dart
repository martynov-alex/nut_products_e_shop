import 'package:mocktail/mocktail.dart';
import 'package:nut_products_e_shop/src/features/authentication/data/fake_auth_repository.dart';
import 'package:nut_products_e_shop/src/features/authentication/domain/app_user.dart';

const testEmail = 'test@test.ru';
const testPassword = 'testPassword';
final testUser = AppUser(
  uid: testEmail.split('').reversed.join(),
  email: testEmail,
);

class MockAuthRepository extends Mock implements FakeAuthRepository {}

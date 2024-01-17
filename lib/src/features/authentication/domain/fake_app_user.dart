import 'package:nut_products_e_shop/src/features/authentication/domain/app_user.dart';

/// Fake user class used to simulate a user account on the backend
class FakeAppUser extends AppUser {
  const FakeAppUser({
    required super.uid,
    required super.email,
    required this.password,
  });

  final String password;
}

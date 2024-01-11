import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nut_products_e_shop/src/features/authentication/data/fake_auth_repository.dart';

class AccountScreenController extends StateNotifier<AsyncValue<void>> {
  AccountScreenController(this.authRepository)
      : super(const AsyncValue<void>.data(null));
  final FakeAuthRepository authRepository;

  Future<bool> signOut() async {
    // * this we can replace
    //   try {
    //     state = const AsyncValue<void>.loading();
    //     await fakeAuthRepository.signOut();
    //     state = const AsyncValue<void>.data(null);
    //     return true;
    //   } on Exception catch (e, st) {
    //     state = AsyncValue<void>.error(e, st);
    //     return false;
    //   }
    // }
    //
    // * with this
    state = const AsyncValue<void>.loading();
    state = await AsyncValue.guard<void>(authRepository.signOut);
    return state.hasError == false;
  }
}

final accountScreenControllerProvider = StateNotifierProvider.autoDispose<
    AccountScreenController, AsyncValue<void>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AccountScreenController(authRepository);
});

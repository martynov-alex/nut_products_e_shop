import 'package:nut_products_e_shop/src/features/checkout/service/fake_checkout_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'payment_button_controller.g.dart';

@riverpod
class PaymentButtonController extends _$PaymentButtonController {
  // Remi said that it's preferable to use an Object for the mounted flag,
  // since a bool doesn't represent rebuilds.
  final _initial = Object();
  late var _current = _initial;

  // An [Object] instance is equal to itself only.
  bool get _mounted => _current == _initial;

  @override
  FutureOr<void> build() {
    ref.onDispose(() => _current = Object());
    // nothing to do
  }

  Future<void> pay() async {
    state = const AsyncLoading();
    final checkoutService = ref.read(checkoutServiceProvider);
    final newState = await AsyncValue.guard(checkoutService.placeOrder);
    // * Check if the controller is mounted before setting the state to prevent:
    // * Bad state: Tried to use PaymentButtonController after dispose was called.
    if (_mounted) {
      state = newState;
    }
  }
}

// * StateNotifier version
// class PaymentButtonController extends StateNotifier<AsyncValue<void>> {
//   PaymentButtonController({required this.checkoutService})
//       : super(const AsyncData(null));

//   final FakeCheckoutService checkoutService;

//   Future<void> pay() async {
//     state = const AsyncLoading();
//     final newState = await AsyncValue.guard(checkoutService.placeOrder);
//     if (mounted) {
//       state = newState;
//     }
//   }
// }

// final paymentButtonControllerProvider = StateNotifierProvider.autoDispose<
//     PaymentButtonController, AsyncValue<void>>((ref) {
//   return PaymentButtonController(
//     checkoutService: ref.watch(checkoutServiceProvider),
//   );
// });

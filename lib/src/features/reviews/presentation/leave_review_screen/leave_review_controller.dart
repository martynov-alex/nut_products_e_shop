import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nut_products_e_shop/src/features/reviews/domain/review.dart';
import 'package:nut_products_e_shop/src/features/reviews/service/reviews_service.dart';
import 'package:nut_products_e_shop/src/utils/current_date_builder_provider.dart';

class LeaveReviewController extends StateNotifier<AsyncValue<void>> {
  LeaveReviewController({
    required this.reviewsService,
    required this.currentDateBuilder,
  }) : super(const AsyncData(null));

  final ReviewsService reviewsService;

  // this is injected so we can easily mock the date in tests
  final DateTime Function() currentDateBuilder;

  Future<void> submitReview({
    required String productId,
    required double rating,
    required String comment,
    required VoidCallback onSuccess,
    Review? previousReview,
  }) async {
    if (previousReview?.rating == rating &&
        previousReview?.comment == comment) {
      if (mounted) onSuccess.call();
      return;
    }

    final review = Review(
      rating: rating,
      comment: comment,
      date: currentDateBuilder(),
    );

    state = const AsyncLoading();
    final newState = await AsyncValue.guard(() =>
        reviewsService.submitReview(productId: productId, review: review));
    // only set the state if the controller hasn't been disposed
    if (mounted) {
      state = newState;
      if (!state.hasError) onSuccess.call();
    }
  }
}

final leaveReviewControllerProvider =
    StateNotifierProvider.autoDispose<LeaveReviewController, AsyncValue<void>>(
  (ref) {
    return LeaveReviewController(
      reviewsService: ref.watch(reviewsServiceProvider),
      currentDateBuilder: ref.watch(currentDateBuilderProvider),
    );
  },
);

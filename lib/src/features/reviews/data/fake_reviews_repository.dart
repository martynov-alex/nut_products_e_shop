import 'package:nut_products_e_shop/src/features/products/domain/product.dart';
import 'package:nut_products_e_shop/src/features/reviews/domain/review.dart';
import 'package:nut_products_e_shop/src/utils/delay.dart';
import 'package:nut_products_e_shop/src/utils/in_memory_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fake_reviews_repository.g.dart';

/// A repository used to store all user reviews for all products
class FakeReviewsRepository {
  FakeReviewsRepository({this.addDelay = true});
  final bool addDelay;

  /// Reviews Store
  /// key: [ProductId]
  /// value: map of [Review] values for each user ID
  final _reviews = InMemoryStore<Map<ProductId, Map<String, Review>>>({});

  /// Single review for a given product given by a specific user.
  /// Emits non-null values if the user has reviewed the product.
  Stream<Review?> watchUserReview(ProductId id, String uid) {
    return _reviews.stream.map((reviewsData) {
      // access nested maps by productId, then uid
      return reviewsData[id]?[uid];
    });
  }

  /// Single review for a given product given by a specific user.
  /// Returns a non-null value if the user has reviewed the product.
  Future<Review?> fetchUserReview(ProductId id, String uid) async {
    await delay(addDelay: addDelay);
    // access nested maps by productId, then uid
    return Future.value(_reviews.value[id]?[uid]);
  }

  /// All reviews for a given product from all users.
  Stream<List<Review>> watchReviews(ProductId id) {
    return _reviews.stream.map((reviewsData) {
      // access nested maps by productId, then uid
      final reviews = reviewsData[id] ?? {};
      return reviews.values.toList();
    });
  }

  /// All reviews for a given product from all users.
  Future<List<Review>> fetchReviews(ProductId id) {
    // access nested maps by productId, then uid
    final reviews = _reviews.value[id] ?? {};
    return Future.value(reviews.values.toList());
  }

  /// Submit a new review or update an existing review for a given product.
  /// [productId] — the product identifier
  /// [uid] — the identifier of the user who is leaving the review
  /// [review] — a [Review] object with the review information
  Future<void> setReview({
    required ProductId productId,
    required String uid,
    required Review review,
  }) async {
    await delay(addDelay: addDelay);
    final allReviews = _reviews.value;
    final reviews = allReviews[productId];
    if (reviews != null) {
      // reviews already exist: set the new review for the given uid
      reviews[uid] = review;
    } else {
      // reviews do not exist: create a new map with the new review
      allReviews[productId] = {uid: review};
    }
    _reviews.value = allReviews;
  }
}

@Riverpod(keepAlive: true)
FakeReviewsRepository reviewsRepository(ReviewsRepositoryRef ref) {
  return FakeReviewsRepository();
}

@riverpod
Stream<List<Review>> productReviews(ProductReviewsRef ref, ProductId id) {
  return ref.watch(reviewsRepositoryProvider).watchReviews(id);
}

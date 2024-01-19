import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nut_products_e_shop/src/common_widgets/async_value_widget.dart';
import 'package:nut_products_e_shop/src/common_widgets/primary_button.dart';
import 'package:nut_products_e_shop/src/common_widgets/responsive_center.dart';
import 'package:nut_products_e_shop/src/constants/app_sizes.dart';
import 'package:nut_products_e_shop/src/constants/breakpoints.dart';
import 'package:nut_products_e_shop/src/features/products/domain/product.dart';
import 'package:nut_products_e_shop/src/features/reviews/domain/review.dart';
import 'package:nut_products_e_shop/src/features/reviews/presentation/leave_review_screen/leave_review_controller.dart';
import 'package:nut_products_e_shop/src/features/reviews/presentation/product_reviews/product_rating_bar.dart';
import 'package:nut_products_e_shop/src/features/reviews/service/reviews_service.dart';
import 'package:nut_products_e_shop/src/localization/string_hardcoded.dart';
import 'package:nut_products_e_shop/src/utils/async_value_ui.dart';

class LeaveReviewScreen extends StatelessWidget {
  const LeaveReviewScreen({required this.productId, super.key});
  final ProductId productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave a review'.hardcoded),
      ),
      body: ResponsiveCenter(
        maxContentWidth: Breakpoint.tablet,
        padding: const EdgeInsets.all(Sizes.p16),
        child: Consumer(
          builder: (_, ref, __) {
            final reviewValue = ref.watch(userReviewFutureProvider(productId));
            return AsyncValueWidget(
              value: reviewValue,
              data: (review) =>
                  LeaveReviewForm(productId: productId, review: review),
            );
          },
        ),
      ),
    );
  }
}

class LeaveReviewForm extends ConsumerStatefulWidget {
  const LeaveReviewForm({
    required this.productId,
    this.review,
    super.key,
  });

  final ProductId productId;
  final Review? review;

  // * Keys for testing using find.byKey()
  static const reviewCommentKey = Key('reviewComment');

  @override
  ConsumerState<LeaveReviewForm> createState() => _LeaveReviewFormState();
}

class _LeaveReviewFormState extends ConsumerState<LeaveReviewForm> {
  final _controller = TextEditingController();

  double _rating = 0;

  @override
  void initState() {
    super.initState();
    final review = widget.review;
    if (review != null) {
      _rating = review.rating;
      _controller.text = review.comment;
    }
  }

  @override
  void dispose() {
    // * TextEditingControllers should be always disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(leaveReviewControllerProvider,
        (_, state) => state.showAlertDialogOnError(context));

    final state = ref.watch(leaveReviewControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.review != null) ...[
          Text(
            'You reviewed this product before. Submit again to edit.'.hardcoded,
            textAlign: TextAlign.center,
          ),
          gapH24,
        ],
        Center(
          child: ProductRatingBar(
            initialRating: _rating,
            onRatingUpdate: (rating) => setState(() => _rating = rating),
          ),
        ),
        gapH32,
        TextField(
          key: LeaveReviewForm.reviewCommentKey,
          controller: _controller,
          textCapitalization: TextCapitalization.sentences,
          maxLines: 5,
          decoration: InputDecoration(
            labelText: 'Your review (optional)'.hardcoded,
            border: const OutlineInputBorder(),
          ),
        ),
        gapH32,
        PrimaryButton(
          text: 'Submit'.hardcoded,
          isLoading: state.isLoading,
          onPressed: state.isLoading || _rating == 0
              ? null
              : () =>
                  ref.read(leaveReviewControllerProvider.notifier).submitReview(
                        productId: widget.productId,
                        rating: _rating,
                        comment: _controller.text,
                        onSuccess: Navigator.of(context).pop,
                        previousReview: widget.review,
                      ),
        )
      ],
    );
  }
}

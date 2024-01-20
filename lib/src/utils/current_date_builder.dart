import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_date_builder.g.dart';

/// A provider that returns a function that returns the current date.
/// This makes it easy to mock the current date in tests.
@riverpod
DateTime Function() currentDateBuilder(CurrentDateBuilderRef ref) {
  /// Current date to be used in the app.
  // ignore: unnecessary_lambdas
  return () => DateTime.now();
}

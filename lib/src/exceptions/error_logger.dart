import 'package:flutter/foundation.dart';
import 'package:nut_products_e_shop/src/exceptions/app_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'error_logger.g.dart';

class ErrorLogger {
  void logError(Object error, StackTrace? stackTrace) {
    // * This can be replaced with a call to a crash reporting tool of choice.
    debugPrint('$error, $stackTrace');
  }

  void logAppException(AppException exception) {
    // * This can be replaced with a call to a crash reporting tool of choice.
    debugPrint(exception.toString());
  }
}

@riverpod
ErrorLogger errorLogger(ErrorLoggerRef ref) {
  return ErrorLogger();
}

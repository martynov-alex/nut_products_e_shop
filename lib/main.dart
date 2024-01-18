import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore:depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:nut_products_e_shop/src/app.dart';
import 'package:nut_products_e_shop/src/exceptions/async_error_logger.dart';
import 'package:nut_products_e_shop/src/exceptions/error_logger.dart';
import 'package:nut_products_e_shop/src/features/cart/data/local/local_cart_repository.dart';
import 'package:nut_products_e_shop/src/features/cart/data/local/sembast_cart_repository.dart';
import 'package:nut_products_e_shop/src/features/cart/service/cart_sync_service.dart';
import 'package:nut_products_e_shop/src/localization/string_hardcoded.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Turn off the # in the URLs on the web
  usePathUrlStrategy();

  // Ensure URL changes in the address bar when using push / pushNamed
  // More info here: https://docs.google.com/document/d/1VCuB85D5kYxPR3qYOjVmw8boAGKb7k62heFyfFHTOvw/edit
  GoRouter.optionURLReflectsImperativeAPIs = true;

  // * Initialize the local cart repository
  final localCartRepository = await SembastCartRepository.makeDefault();

  // * Create ProviderContainer with any required overrides
  final container = ProviderContainer(
    overrides: [
      // after overrides we can get the repository synchronously
      localCartRepositoryProvider.overrideWith((ref) {
        // use ref to set a custom dispose behavior
        ref.onDispose(localCartRepository.dispose);
        // then, just return the repository as normal
        return localCartRepository;
      }),
    ],
    observers: [AsyncErrorLogger()],
  )
    // * Initialize CartSyncService to start the listener
    ..read(cartSyncServiceProvider);

  final errorLogger = container.read(errorLoggerProvider);

  // * Register error handlers. For more info, see:
  // * https://docs.flutter.dev/testing/errors
  registerErrorHandlers(errorLogger);

  // * Entry point of the app
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

void registerErrorHandlers(ErrorLogger errorLogger) {
  // * Show some error UI if any uncaught exception happens
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    errorLogger.logError(details.exception, details.stack);
  };

  // * Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (error, stack) {
    errorLogger.logError(error, stack);
    return true;
  };

  // * Show some error UI when any widget in the app fails to build
  ErrorWidget.builder = (details) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('An error occurred'.hardcoded),
      ),
      body: Center(child: Text(details.toString())),
    );
  };
}

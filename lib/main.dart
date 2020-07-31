import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodorderingadmin/providers/analytics.dart';
import 'package:foodorderingadmin/providers/restaurants.dart';
import 'package:foodorderingadmin/screens/splash_screen.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:sentry/sentry.dart';

import 'package:provider/provider.dart';

import './providers/orders.dart';
import './providers/menu.dart';
import './providers/auth.dart';

import './screens/screens.dart';
import 'helpers/constants.dart';

void main() async {
  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.
  Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  var sentry = SentryClient(
      dsn:
          "https://88ac15266a84451590f644e95ac7a754@o428042.ingest.sentry.io/5372992");

  FlutterError.onError = (details, {bool forceReport = false}) {
    try {
      sentry.captureException(
        exception: details.exception,
        stackTrace: details.stack,
      );
    } catch (e) {
      print('Sending report to sentry.io failed: $e');
    } finally {
      // Also use Flutter's pretty error logging to the device's console.
      FlutterError.dumpErrorToConsole(details, forceReport: forceReport);
    }
  };

  runZoned(() => runApp(MyApp()),
      onError: (Object error, StackTrace stackTrace) {
    try {
      sentry.captureException(
        exception: error,
        stackTrace: stackTrace,
      );
      print('Error sent to sentry.io: $error');
    } catch (e) {
      print('Sending report to sentry.io failed: $e');
      print('Original error: $error');
    }
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProvider(create: (context) => Menu()),
        ChangeNotifierProvider(create: (context) => Restaurants()),
        ChangeNotifierProvider(create: (context) => Orders()),
        ChangeNotifierProvider(create: (context) => Analytics()),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'GetTableService-Host',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: kGreenMaterial,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              fontFamily: 'MyriadPro',
              backgroundColor: Colors.white,
              scaffoldBackgroundColor: Colors.white),
          home: FutureBuilder(
              future: auth.fetchUserDetails(),
              builder: (ctx, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? SplashScreen()
                      : snapshot.hasData && snapshot.data?.restaurantId != null
                          ? LiveOrdersScreen()
                          : SigninScreen()),
          routes: {
            LiveMenuEditScreen.routeName: (context) => LiveMenuEditScreen(),
            ProductEditScreen.routeName: (context) => ProductEditScreen(),
            SigninScreen.routeName: (context) => SigninScreen(),
            LiveOrdersScreen.routeName: (context) => LiveOrdersScreen(),
            AcceptedOrdersScreen.routeName: (context) => AcceptedOrdersScreen(),
            ArchiveOrdersScreen.routeName: (context) => ArchiveOrdersScreen(),
          },
        ),
      ),
    );
  }
}

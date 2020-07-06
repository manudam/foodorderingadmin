import 'package:flutter/material.dart';
import 'package:foodorderingadmin/providers/analytics.dart';
import 'package:foodorderingadmin/providers/restaurants.dart';
import 'package:foodorderingadmin/providers/userpreferences.dart';
import 'package:foodorderingadmin/screens/splash_screen.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:provider/provider.dart';

import './providers/orders.dart';
import './providers/menu.dart';
import './providers/auth.dart';

import './screens/screens.dart';

void main() async {
  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.
  Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  runApp(MyApp());
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
        ChangeNotifierProvider(create: (context) => UserPreferences()),
        ChangeNotifierProvider(create: (context) => Analytics()),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Get Table Service Host',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.blue,
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

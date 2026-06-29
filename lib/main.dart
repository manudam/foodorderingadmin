import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodorderingadmin/providers/analytics.dart';
import 'package:foodorderingadmin/providers/restaurants.dart';
import 'package:foodorderingadmin/screens/splash_screen.dart';

import 'package:provider/provider.dart';

import './providers/orders.dart';
import './providers/menu.dart';
import './providers/auth.dart';

import './screens/screens.dart';
import 'helpers/constants.dart';

void main() async {
  runZonedGuarded(() => runApp(MyApp()), (Object error, StackTrace stackTrace) {
    FlutterError.reportError(FlutterErrorDetails(
      exception: error,
      stack: stackTrace,
    ));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
              visualDensity: VisualDensity.adaptivePlatformDensity,
              fontFamily: 'MyriadPro',
              scaffoldBackgroundColor: Colors.white,
              colorScheme: ColorScheme.fromSwatch(primarySwatch: kGreenMaterial)
                  .copyWith(surface: Colors.white)),
          home: FutureBuilder(
              future: auth.fetchUserDetails(),
              builder: (ctx, snapshot) {
                final user = snapshot.data;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SplashScreen();
                }

                return user != null && user.restaurantId.isNotEmpty
                    ? DashboardScreen()
                    : SigninScreen();
              }),
          routes: {
            DashboardScreen.routeName: (context) => DashboardScreen(),
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

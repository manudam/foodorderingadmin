import 'package:flutter/material.dart';
import 'package:foodorderingadmin/providers/restaurants.dart';

import 'package:provider/provider.dart';

import './providers/orders.dart';
import './providers/menu.dart';
import './providers/auth.dart';

import './screens/screens.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: Menu(),
        ),
        ChangeNotifierProvider.value(
          value: Restaurants(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Food ordering Admin',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          //home: RestaurantScreen(),
          home: FutureBuilder(
              future: auth.fetchUserDetails(),
              builder: (ctx, snapshot) =>
                  snapshot.hasData && snapshot.data?.restaurantId != null
                      ? LiveOrdersScreen()
                      : SigninScreen()),
          routes: {
            LiveMenuEditScreen.routeName: (context) => LiveMenuEditScreen(),
            ProductEditScreen.routeName: (context) => ProductEditScreen(),
            SigninScreen.routeName: (context) => SigninScreen(),
            SignupScreen.routeName: (context) => SignupScreen(),
            AccountScreen.routeName: (context) => AccountScreen(),
            LiveOrdersScreen.routeName: (context) => LiveOrdersScreen()
          },
        ),
      ),
    );
  }
}

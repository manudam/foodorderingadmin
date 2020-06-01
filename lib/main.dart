import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import './providers/orders.dart';
import './providers/products.dart';
import './providers/auth.dart';

import './screens/orders_screen.dart';
import './screens/product_edit_screen.dart';
import './screens/product_screen.dart';
import './screens/restaurant_screen.dart';
import './screens/account/account.dart';

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
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Food ordering Adming',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: FutureBuilder(
              future: auth.getUser,
              builder: (ctx, snapshot) =>
                  snapshot.hasData ? RestaurantScreen() : LoginScreen()),
          routes: {
            OrdersScreen.routeName: (context) => OrdersScreen(),
            ProductScreen.routeName: (context) => ProductScreen(),
            ProductEditScreen.routeName: (context) => ProductEditScreen(),
            RestaurantScreen.routeName: (context) => RestaurantScreen(),
            LoginScreen.routeName: (context) => LoginScreen(),
            SignupScreen.routeName: (context) => SignupScreen(),
            AccountScreen.routeName: (context) => AccountScreen()
          },
        ),
      ),
    );
  }
}

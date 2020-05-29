import 'package:flutter/material.dart';
import 'package:foodorderingadmin/providers/orders.dart';
import 'package:foodorderingadmin/providers/products.dart';
import 'package:foodorderingadmin/screens/product_edit_screen.dart';
import 'package:foodorderingadmin/screens/product_screen.dart';
import 'package:foodorderingadmin/screens/restaurant_screen.dart';
import 'package:provider/provider.dart';

import './screens/orders_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
        ChangeNotifierProvider.value(
          value: Products(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: RestaurantScreen.routeName,
        routes: {
          OrdersScreen.routeName: (context) => OrdersScreen(),
          ProductScreen.routeName: (context) => ProductScreen(),
          ProductEditScreen.routeName: (context) => ProductEditScreen(),
          RestaurantScreen.routeName: (context) => RestaurantScreen()
        },
      ),
    );
  }
}

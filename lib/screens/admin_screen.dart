import 'package:flutter/material.dart';
import 'package:foodorderingadmin/models/models.dart';
import 'package:foodorderingadmin/models/restaurant.dart';
import 'package:foodorderingadmin/providers/auth.dart';
import 'package:foodorderingadmin/providers/restaurants.dart';
import 'package:foodorderingadmin/screens/opening_times_screen.dart';
import 'package:foodorderingadmin/screens/screens.dart';
import 'package:foodorderingadmin/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatefulWidget {
  static const routeName = "admin";

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  bool _isInit = false;

  @override
  void didChangeDependencies() async {
    if (!_isInit) {
      Restaurants restaurants =
          Provider.of<Restaurants>(context, listen: false);
      User user = Provider.of<Auth>(context, listen: false).loggedInUser;
      await restaurants.fetchRestaurantDetails(user.restaurantId);
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Restaurants restaurants = Provider.of<Restaurants>(context);
    Restaurant restaurant = restaurants.restaurant;

    return Scaffold(
      appBar: AppBar(
        title: Text("Admin"),
      ),
      drawer: AppDrawer(),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.restaurant),
            title: Text("Restaurant online"),
            trailing: Switch(
              value: restaurant != null ? restaurant.online : false,
              onChanged: (value) {
                if (restaurant != null && value != restaurant.online) {
                  setState(() {
                    restaurant.online = value;
                    restaurants.saveRestaurant(restaurant);
                  });
                }
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_box),
            title: Text("Accounts"),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.of(context).pushNamed(AccountScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.access_time),
            title: Text("Opening hours"),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.of(context).pushNamed(OpeningTimesScreen.routeName);
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}

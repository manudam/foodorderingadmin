import 'package:flutter/material.dart';
import 'package:foodorderingadmin/screens/opening_times_edit_screen.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../providers/restaurants.dart';

class OpeningTimesScreen extends StatefulWidget {
  static const routeName = "openingtimes";

  @override
  _OpeningTimesScreenState createState() => _OpeningTimesScreenState();
}

class _OpeningTimesScreenState extends State<OpeningTimesScreen> {
  @override
  Widget build(BuildContext context) {
    Restaurants restaurants = Provider.of<Restaurants>(context);
    Restaurant restaurant = restaurants.restaurant;

    void _saveForm() async {
      restaurants.saveRestaurant(restaurant);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Opening Times"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _saveForm,
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: restaurant != null ? restaurant.openingHours.length : 0,
          itemBuilder: (ctx, i) {
            var openingHours = restaurant.openingHours[i];
            return ListTile(
                title: Text(openingHours.day),
                subtitle: openingHours.closed
                    ? Text("Closed")
                    : Text("${openingHours.start}-${openingHours.end}"),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                        OpeningTimesEditScreen.routeName,
                        arguments: openingHours);
                  },
                ));
          },
        ));
  }
}

//

import 'package:flutter/material.dart';
import 'package:foodorderingadmin/providers/restaurants.dart';
import 'package:provider/provider.dart';

import 'category_item.dart';

class CategoryPicker extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<CategoryPicker> {
  @override
  Widget build(BuildContext context) {
    var restaurant = Provider.of<Restaurants>(context).restaurant;
    final categories = restaurant != null ? restaurant.categories : [];

    return Container(
        padding: EdgeInsets.only(left: 30),
        height: 50,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (ctx, i) {
              var category = categories[i];
              return CategoryItem(category);
            }));
  }
}

import 'package:flutter/material.dart';
import 'package:foodorderingadmin/providers/menu.dart';
import 'package:provider/provider.dart';

import 'category_item.dart';

class CategoryPicker extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<CategoryPicker> {
  @override
  Widget build(BuildContext context) {
    final menuData = Provider.of<Menu>(context);

    return Container(
        padding: EdgeInsets.only(left: 10),
        height: 50,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: menuData.categories.length,
            itemBuilder: (ctx, i) {
              var category = menuData.categories[i];
              return CategoryItem(category);
            }));
  }
}

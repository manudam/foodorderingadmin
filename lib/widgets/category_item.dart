import 'package:flutter/material.dart';
import 'package:foodorderingadmin/providers/menu.dart';
import 'package:provider/provider.dart';

class CategoryItem extends StatelessWidget {
  final String category;

  CategoryItem(this.category);

  @override
  Widget build(BuildContext context) {
    var products = Provider.of<Menu>(context);

    return Row(
      children: [
        ChoiceChip(
          selected: products.selectedCategory == category,
          label: Text(
            category,
            style: TextStyle(color: Colors.white),
          ),
          selectedColor: Colors.green,
          onSelected: (bool selection) {
            products.selectCategory(category);
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6))),
        ),
        SizedBox(
          width: 5,
        ),
      ],
    );
  }
}

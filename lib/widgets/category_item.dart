import 'package:flutter/material.dart';
import 'package:foodorderingadmin/helpers/constants.dart';
import 'package:foodorderingadmin/providers/userpreferences.dart';
import 'package:provider/provider.dart';

class CategoryItem extends StatelessWidget {
  final String category;

  CategoryItem(this.category);

  @override
  Widget build(BuildContext context) {
    var userPreferences = Provider.of<UserPreferences>(context);

    return Row(
      children: [
        ChoiceChip(
          selected: userPreferences.selectedCategory == category,
          label: Text(
            category,
            style: TextStyle(color: Colors.white),
          ),
          selectedColor: kGreen,
          onSelected: (bool selection) {
            userPreferences.selectCategory(category);
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

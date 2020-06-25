import 'package:flutter/material.dart';
import 'package:foodorderingadmin/helpers/constants.dart';
import 'package:foodorderingadmin/providers/menu.dart';
import 'package:foodorderingadmin/screens/screens.dart';
import 'package:provider/provider.dart';

class ProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final menuData = Provider.of<Menu>(context);
    final selectedCategory = menuData.selectedCategory;
    final products = menuData.findByCategory(selectedCategory);

    List<Widget> cards = [];

    products.forEach((product) {
      cards.add(Container(
        width: 300,
        child: Card(
          margin: EdgeInsets.all(10),
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.only(left: 0, right: 0),
              child: Text(
                product.name,
                style: kMediumText,
              ),
            ),
            leading: Container(
              alignment: Alignment.centerLeft,
              width: 20,
              child: Checkbox(
                value: true,
                onChanged: (value) {},
              ),
            ),
            trailing: Text("£ ${product.price.toString()}", style: kMediumText),
            onTap: () {
              Navigator.of(context).pushNamed(ProductEditScreen.routeName,
                  arguments: product.id);
            },
          ),
        ),
      ));
    });

    return Wrap(
      children: cards,
      direction: Axis.vertical,
      runAlignment: WrapAlignment.start,
    );
  }
}

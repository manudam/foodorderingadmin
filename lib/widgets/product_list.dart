import 'package:flutter/material.dart';
import 'package:foodorderingadmin/helpers/constants.dart';
import 'package:foodorderingadmin/providers/auth.dart';
import 'package:foodorderingadmin/providers/menu.dart';
import 'package:foodorderingadmin/providers/userpreferences.dart';
import 'package:foodorderingadmin/screens/screens.dart';
import 'package:provider/provider.dart';

class ProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final menuData = Provider.of<Menu>(context);
    final selectedCategory =
        Provider.of<UserPreferences>(context).selectedCategory;
    final products = menuData.findByCategory(selectedCategory);
    var loggedInUser = Provider.of<Auth>(context).loggedInUser;

    List<Widget> cards = [];

    products.forEach((product) {
      cards.add(Container(
        width: 300,
        child: Container(
          margin: EdgeInsets.all(10),
          child: Material(
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 0, right: 20),
              title: Padding(
                padding: const EdgeInsets.only(left: 0, right: 0),
                child: Text(
                  product.name,
                  style: kMediumText,
                ),
              ),
              leading: Container(
                child: IconButton(
                  icon: product.disabled
                      ? Align(
                          alignment: Alignment.topLeft,
                          child: Icon(
                            Icons.close,
                            color: kGreyBackground,
                          ),
                        )
                      : Align(
                          alignment: Alignment.topLeft,
                          child: Icon(
                            Icons.check_box,
                            color: kGreen,
                          ),
                        ),
                  onPressed: () async {
                    product.disabled = !product.disabled;
                    await menuData.updateProduct(
                        product.id, product, loggedInUser);
                  },
                ),
              ),
              trailing: Text("£ ${product.price.toStringAsFixed(2)}",
                  style: kMediumText),
              onTap: () {
                Navigator.of(context).pushNamed(ProductEditScreen.routeName,
                    arguments: product.id);
              },
            ),
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

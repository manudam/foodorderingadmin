import 'package:flutter/material.dart';
import 'package:foodorderingadmin/helpers/constants.dart';
import 'package:foodorderingadmin/providers/restaurants.dart';
import 'package:foodorderingadmin/widgets/category_picker.dart';
import 'package:foodorderingadmin/widgets/custom_app_bar.dart';
import 'package:foodorderingadmin/widgets/product_list.dart';
import 'package:provider/provider.dart';

import 'product_edit_screen.dart';
import '../providers/auth.dart';
import '../widgets/app_drawer.dart';
import '../providers/menu.dart';

class LiveMenuEditScreen extends StatefulWidget {
  static String routeName = 'product';

  @override
  _LiveMenuEditScreenState createState() => _LiveMenuEditScreenState();
}

class _LiveMenuEditScreenState extends State<LiveMenuEditScreen> {
  bool _isInit = false;

  @override
  void initState() {
    print("init called");
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      var loggedInUser = Provider.of<Auth>(context, listen: false).loggedInUser;
      Provider.of<Restaurants>(context, listen: false)
          .fetchRestaurantDetails(loggedInUser.restaurantId);
      Provider.of<Menu>(context, listen: false)
          .fetchMenu(loggedInUser.restaurantId);
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: "Live Menu Edit",
        backgroundColor: kLightGreyBackground,
        textColor: Colors.black,
        actions: [
          Container(
            width: 100,
            child: IconButton(
              icon: Icon(
                Icons.add_circle,
                size: 50,
                color: kYellow,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(ProductEditScreen.routeName);
              },
            ),
          )
        ],
        appBar: AppBar(),
      ),
      drawer: AppDrawer(),
      body: Container(
        color: kLightGreyBackground,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CategoryPicker(),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal, child: ProductList()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

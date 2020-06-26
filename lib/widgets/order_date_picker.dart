// import 'package:flutter/material.dart';
// import 'package:foodorderingadmin/providers/menu.dart';
// import 'package:foodorderingadmin/providers/orders.dart';
// import 'package:provider/provider.dart';

// import 'category_item.dart';

// class OrderDatePicker extends StatefulWidget {
//   @override
//   _State createState() => _State();
// }

// class _State extends State<OrderDatePicker> {
//   @override
//   Widget build(BuildContext context) {
//     final orderData = Provider.of<Orders>(context);

//     return Container(
//         padding: EdgeInsets.only(left: 10),
//         height: 50,
//         child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: menuData.categories.length,
//             itemBuilder: (ctx, i) {
//               var category = menuData.categories[i];
//               return CategoryItem(category);
//             }));
//   }
// }

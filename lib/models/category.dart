// import 'package:flutter/material.dart';

// import 'product.dart';

// class Category {
//   int categoryId;
//   String name;
//   String description;
//   List<Product> products = [];
//   IconData icon;

//   Category({
//     @required this.categoryId,
//     @required this.name,
//     this.description,
//     this.icon,
//     this.products,
//   });

//   String get productSubList {
//     var subList = "";

//     for (int i = 0; i < products.length; i++) {
//       var product = products[i];
//       subList += product.title;
//       if (i != products.length - 1) subList += ",";
//     }

//     if (subList.length > 100) {
//       return subList.substring(1, 100);
//     } else {
//       return subList;
//     }
//   }
// }

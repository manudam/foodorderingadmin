import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final List<Widget>? actions;
  final AppBar? appBar;
  final List<Widget>? widgets;

  const BaseAppBar({
    super.key,
    this.appBar,
    this.widgets,
    this.title = '',
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      titleSpacing: 0.0,
      elevation: 0.0,
      backgroundColor: backgroundColor,
      title: Text(
        title,
        style: TextStyle(color: textColor, fontFamily: 'CenturyGothic'),
      ),
      iconTheme: IconThemeData(color: Colors.grey),
      actions: actions,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(appBar?.preferredSize.height ?? kToolbarHeight);
}

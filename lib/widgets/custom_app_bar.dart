import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final List<Widget> actions;
  final AppBar appBar;
  final List<Widget> widgets;

  const BaseAppBar({
    Key key,
    this.appBar,
    this.widgets,
    this.title,
    this.backgroundColor,
    this.textColor,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      titleSpacing: 0.0,
      elevation: 0.0,
      backgroundColor: this.backgroundColor,
      title: Text(
        title,
        style: TextStyle(color: textColor, fontFamily: 'CenturyGothic'),
      ),
      iconTheme: new IconThemeData(color: Colors.grey),
      actions: this.actions,
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}

import 'package:flutter/material.dart';
import 'package:foodorderingadmin/widgets/form_widgets.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool _loading = true;

    return LoadingScreen(
      inAsyncCall: _loading,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Container(),
    );
  }
}

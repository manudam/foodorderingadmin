import 'package:flutter/material.dart';
import 'package:foodorderingadmin/widgets/form_widgets.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool loading = true;

    return LoadingScreen(
      inAsyncCall: loading,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Container(),
    );
  }
}

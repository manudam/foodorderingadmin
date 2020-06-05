import 'package:flutter/material.dart';
import 'package:foodorderingadmin/providers/auth.dart';
import 'package:foodorderingadmin/widgets/app_drawer.dart';
import 'package:foodorderingadmin/widgets/form_vertical_space.dart';
import 'package:foodorderingadmin/widgets/loading_screen.dart';
import 'package:foodorderingadmin/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  static const routeName = "account";

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<Auth>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('My account'),
        ),
        drawer: AppDrawer(),
        body: LoadingScreen(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FutureBuilder(
                    future: _auth.getFirebaseUser(),
                    builder: (ctx, snapshot) => snapshot.hasData
                        ? Text("Logged in as ${snapshot.data.email}")
                        : Text("Not Logged in"),
                  ),
                  FormVerticalSpace(),
                  PrimaryButton(
                      labelText: "Sign-out",
                      onPressed: () async {
                        setState(() {
                          _loading = true;
                        });

                        bool status = await _auth.signOut().then((status) {
                          setState(() {
                            _loading = false;
                          });

                          return status;
                        });
                      }),
                ],
              )),
          inAsyncCall: _loading,
          color: Theme.of(context).scaffoldBackgroundColor,
        ));
  }
}

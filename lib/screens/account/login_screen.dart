import 'package:flutter/material.dart';
import 'package:foodorderingadmin/providers/auth.dart';
import 'package:foodorderingadmin/screens/account/account.dart';
import 'package:foodorderingadmin/screens/restaurant_screen.dart';
import 'package:foodorderingadmin/widgets/form_input_field_with_icon.dart';
import 'package:foodorderingadmin/widgets/form_vertical_space.dart';
import 'package:foodorderingadmin/widgets/label_button.dart';
import 'package:foodorderingadmin/widgets/loading_screen.dart';
import 'package:foodorderingadmin/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _auth = Provider.of<Auth>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('login'),
      ),
      body: LoadingScreen(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FormInputFieldWithIcon(
                      controller: _email,
                      iconPrefix: Icons.email,
                      labelText: "Email",
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) => null,
                      onSaved: (value) => _email.text = value,
                    ),
                    FormVerticalSpace(),
                    FormInputFieldWithIcon(
                      controller: _password,
                      iconPrefix: Icons.lock,
                      labelText: "Password",
                      obscureText: true,
                      onChanged: (value) => null,
                      onSaved: (value) => _password.text = value,
                      maxLines: 1,
                    ),
                    FormVerticalSpace(),
                    PrimaryButton(
                        labelText: "Sign-in",
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              _loading = true;
                            });

                            bool status = await _auth
                                .login(_email.text, _password.text)
                                .then((status) {
                              setState(() {
                                _loading = false;
                              });

                              return status;
                            });
                          }
                        }),
                    FormVerticalSpace(),
                    LabelButton(
                      labelText: 'Sign-up instead',
                      onPressed: () => Navigator.pushReplacementNamed(
                          context, SignupScreen.routeName),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        inAsyncCall: _loading,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}

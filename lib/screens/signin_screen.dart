import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:foodorderingadmin/helpers/constants.dart';
import 'package:foodorderingadmin/providers/auth.dart';
import 'package:foodorderingadmin/widgets/custom_app_bar.dart';
import 'package:foodorderingadmin/widgets/form_input_field_with_icon.dart';
import 'package:foodorderingadmin/widgets/form_vertical_space.dart';
import 'package:foodorderingadmin/widgets/loading_screen.dart';
import 'package:provider/provider.dart';

class SigninScreen extends StatefulWidget {
  static const routeName = "login";

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
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

    Future<void> _showMyDialog(String title, String message) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
          );
        },
      );
    }

    return Scaffold(
      appBar: BaseAppBar(
        title: "   Sign-in",
        backgroundColor: Colors.white,
        textColor: Colors.black,
        appBar: AppBar(),
      ),
      body: LoadingScreen(
        child: Form(
          key: _formKey,
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 3,
                      ),
                      Container(
                        width: 400,
                        child: FormInputFieldWithIcon(
                          controller: _email,
                          iconPrefix: Icons.email,
                          labelText: "Email",
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) => null,
                          onSaved: (value) => _email.text = value,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter an email';
                            }
                            if (EmailValidator.validate(value) == false) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                      ),
                      FormVerticalSpace(),
                      Container(
                        width: 400,
                        child: FormInputFieldWithIcon(
                          controller: _password,
                          iconPrefix: Icons.lock,
                          labelText: "Password",
                          obscureText: true,
                          onChanged: (value) => null,
                          onSaved: (value) => _password.text = value,
                          maxLines: 1,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                        ),
                      ),
                      FormVerticalSpace(),
                      MaterialButton(
                        child: Text('Sign-in',
                            style: TextStyle(color: Colors.white)),
                        color: kYellow,
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              _loading = true;
                            });

                            try {
                              await _auth.login(_email.text, _password.text);
                            } catch (exception) {
                              _showMyDialog("Error", exception.message);
                            } finally {
                              setState(() {
                                _loading = false;
                              });
                            }
                          }
                        },
                      ),
                    ],
                  ),
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

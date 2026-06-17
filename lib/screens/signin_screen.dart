import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:foodorderingadmin/helpers/constants.dart';
import 'package:foodorderingadmin/providers/auth.dart';
import 'package:foodorderingadmin/screens/screens.dart';
import 'package:foodorderingadmin/widgets/form_input_field_with_icon.dart';
import 'package:foodorderingadmin/widgets/form_vertical_space.dart';
import 'package:foodorderingadmin/widgets/loading_screen.dart';
import 'package:provider/provider.dart';

class SigninScreen extends StatefulWidget {
  static const routeName = "login";

  const SigninScreen({super.key});

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _passwordFocusNode = FocusNode();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context, listen: false);

    Future<void> showMyDialog(String title, String message) async {
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
      body: LoadingScreen(
        inAsyncCall: _loading,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Form(
          key: _formKey,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Image(
                            image: AssetImage("images/GTSLogo.png"),
                          ),
                          Text(
                            'Contact Free Order and Pay',
                            style: kGreyTitle,
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text("Sign-in",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: 400,
                            child: FormInputFieldWithIcon(
                              controller: _email,
                              iconPrefix: Icons.email,
                              labelText: "Email",
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {},
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_passwordFocusNode);
                              },
                              onSaved: (value) => _email.text = value ?? '',
                              validator: (value) {
                                final email = value ?? '';
                                if (email.isEmpty) {
                                  return 'Please enter an email';
                                }
                                if (EmailValidator.validate(email) == false) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),
                          ),
                          FormVerticalSpace(),
                          SizedBox(
                            width: 400,
                            child: FormInputFieldWithIcon(
                              controller: _password,
                              iconPrefix: Icons.lock,
                              labelText: "Password",
                              obscureText: true,
                              onChanged: (value) {},
                              onSaved: (value) => _password.text = value ?? '',
                              maxLines: 1,
                              focusNode: _passwordFocusNode,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if ((value ?? '').isEmpty) {
                                  return 'Please enter a password';
                                }
                                return null;
                              },
                            ),
                          ),
                          FormVerticalSpace(),
                          MaterialButton(
                            padding: EdgeInsets.all(10),
                            color: kYellow,
                            onPressed: () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                setState(() {
                                  _loading = true;
                                });

                                try {
                                  var result = await auth.login(
                                      _email.text, _password.text);

                                  if (result) {
                                    Navigator.of(context)
                                        .pushNamed(LiveOrdersScreen.routeName);
                                  }
                                } catch (exception) {
                                  showMyDialog("Error", exception.toString());
                                } finally {
                                  setState(() {
                                    _loading = false;
                                  });
                                }
                              }
                            },
                            child: Container(
                              width: 150,
                              alignment: Alignment.center,
                              child: Text('Sign-in',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)),
                            ),
                          ),
                        ],
                      ),
                      Container(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

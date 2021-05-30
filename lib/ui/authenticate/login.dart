import 'package:bluechat/view_models/login_view_model.dart';
import 'package:bluechat/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen();

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool obscureText = true;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: Container(
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(children: [
          (SvgPicture.asset('assets/bluechat_logo.svg',
              height: 150, width: 200)),
          const Text("WELCOME BACK",
              style: TextStyle(color: Colors.white, fontSize: 20)),
          Container(
            padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 50.0),
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomTextField(
                    prefixIcon: Icon(Icons.mail),
                    hintText: 'Email',
                    textCapitalization: TextCapitalization.none,
                    borderColor: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryColor,
                    validator: (val) =>
                        val.isEmpty ? 'Please enter an email' : null,
                    controller: emailController,
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    obscureText: obscureText,
                    textCapitalization: TextCapitalization.none,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.visibility_sharp),
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                    ),
                    borderColor: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryColor,
                    controller: passwordController,
                  ),
                  const SizedBox(height: 20),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    loginViewModel.isLoading
                        ? CircularProgressIndicator(
                            backgroundColor: Theme.of(context).primaryColor)
                        : Expanded(
                            child: ElevatedButton(
                              child: Text('Sign in'),
                              style: ElevatedButton.styleFrom(
                                  primary: Theme.of(context).primaryColor,
                                  minimumSize: Size(size.width * 0.8, 50),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  FocusScope.of(context).unfocus();
                                  loginViewModel.login(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim());
                                }
                              },
                            ),
                          ),
                  ]),
                ],
              ),
            ),
          ),
        ]),
      ),
    ));
  }
}

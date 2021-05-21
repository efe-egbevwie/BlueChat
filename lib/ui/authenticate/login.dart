import 'package:bluechat/service_locator.dart';
import 'package:bluechat/services/auth.dart';
import 'package:bluechat/view_models/login_view_model.dart';
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
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              )),
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
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.mail),
                      hintText: 'Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(29)),
                    ),
                    validator: (val) =>
                        val.isEmpty ? 'Please enter an email' : null,
                    controller: emailController,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.visibility_sharp),
                          onPressed: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                        ),
                        hintText: 'Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(29))),
                    obscureText: obscureText,
                    validator: (val) => val.length < 6
                        ? 'Please input a password with 6 or more characters'
                        : null,
                    controller: passwordController,
                  ),
                  const SizedBox(height: 20),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    loginViewModel.isLoading
                        ? CircularProgressIndicator()
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

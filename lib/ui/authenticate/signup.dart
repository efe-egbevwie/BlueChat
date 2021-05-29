import 'package:bluechat/view_models/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen();

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
    final signUpViewModel = Provider.of<SignUpViewModel>(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
          color: Theme.of(context).primaryColor,
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                (SvgPicture.asset('assets/bluechat_logo.svg',
                    height: 150.0, width: 200.0)),
                const Text("SIGN UP TO BLUECHAT",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    )),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 50.0, horizontal: 50.0),
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
                            enabled: true,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor),
                                borderRadius: BorderRadius.circular(29)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(29)),
                          ),
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
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
                              enabled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(29)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(29))),
                          obscureText: obscureText,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                          validator: (val) => val.length < 6
                              ? 'Please input a password with 6 or more characters'
                              : null,
                          controller: passwordController,
                        ),
                        const SizedBox(height: 20),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              signUpViewModel.isLoading
                                  ? CircularProgressIndicator(
                                      backgroundColor:
                                          Theme.of(context).primaryColor)
                                  : Expanded(
                                      child: ElevatedButton(
                                        child: Text('Sign Up'),
                                        style: ElevatedButton.styleFrom(
                                            primary:
                                                Theme.of(context).primaryColor,
                                            minimumSize:
                                                Size(size.width * 0.8, 50),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30))),
                                        onPressed: () {
                                          if (_formKey.currentState
                                              .validate()) {
                                            FocusScope.of(context).unfocus();
                                            signUpViewModel.signUp(
                                                email:
                                                    emailController.text.trim(),
                                                password: passwordController
                                                    .text
                                                    .trim());
                                          }
                                        },
                                      ),
                                    ),
                            ]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ivrapp/constants.dart';
import 'package:ivrapp/screens/auth/services/auth_services.dart';
import 'package:ivrapp/screens/home/home_screen.dart';
import 'package:ivrapp/widgets/custom_button.dart';
import 'package:ivrapp/widgets/custom_textfield.dart';
import 'package:ivrapp/widgets/showSnackBar.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth-screen';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  int index = 0;
  String res = 'not good';
  final _signupkey = GlobalKey<FormState>();
  final _signinkey = GlobalKey<FormState>();
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  bool isLoading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailcontroller.dispose();
    _namecontroller.dispose();
    _passwordcontroller.dispose();
  }

  void createUser() async {
    setState(() {
      isLoading = true;
    });
    res = await AuthServices().signUpUser(
        username: _namecontroller.text.trim(),
        email: _emailcontroller.text.trim(),
        password: _passwordcontroller.text.trim());
    setState(() {
      isLoading = false;
    });
    showSnackBar(context, res);
  }

  void loginUser() async {
    setState(() {
      isLoading=true;
    });
    res = await AuthServices().loginUser(
        email: _emailcontroller.text.trim(),
        password: _passwordcontroller.text.trim());
    setState(() {
      isLoading=false;
    });
    if (res == 'Login Successful') {
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } else {
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 60),
          child: Column(
            children: [
              Row(
                children: [
                  Radio(
                    activeColor: greenColor,
                    value: 0,
                    groupValue: index,
                    onChanged: (int? value) {
                      setState(() {
                        index = value!;
                      });
                    },
                  ),
                  Text(
                    'Create Account',
                    style: TextStyle(
                        fontWeight: index == 0 ? FontWeight.bold : null,
                        fontSize: 20),
                  )
                ],
              ),
              if (index == 0)
                Column(
                  children: [
                    Form(
                        key: _signupkey,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              CustomTextFormField(
                                keyboardType: TextInputType.name,
                                hintText: 'Enter your name',
                                controller: _namecontroller,
                              ),
                              CustomTextFormField(
                                keyboardType: TextInputType.emailAddress,
                                hintText: 'Enter your email',
                                controller: _emailcontroller,
                              ),
                              CustomTextFormField(
                                keyboardType: TextInputType.visiblePassword,
                                hintText: 'Enter your password',
                                controller: _passwordcontroller,
                              ),
                              (isLoading)
                                  ? Container(
                                      height: 48,
                                      margin: EdgeInsets.all(8),
                                      color: greenColor,
                                      width: double.infinity,
                                      child: Center(
                                        child: const CircularProgressIndicator(
                                          color: whiteColor,
                                        ),
                                      ),
                                    )
                                  : CustomButton(
                                      buttontitle: 'Sign Up',
                                      callback: () {
                                        if (_signupkey.currentState!
                                            .validate()) {
                                          if (_passwordcontroller.text
                                                  .trim()
                                                  .length >=
                                              6) {
                                            createUser();
                                          } else {
                                            showSnackBar(context,
                                                'Password must be of more than 6 characters');
                                          }
                                        }
                                      },
                                    )
                            ],
                          ),
                        )),
                  ],
                ),
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Radio(
                      activeColor: greenColor,
                      value: 1,
                      groupValue: index,
                      onChanged: (int? value) {
                        setState(() {
                          index = value!;
                        });
                      },
                    ),
                    Text(
                      'Sign in',
                      style: TextStyle(
                          fontWeight: index == 1 ? FontWeight.bold : null,
                          fontSize: 20),
                    )
                  ],
                ),
              ),
              if (index == 1)
                Column(
                  children: [
                    Form(
                        key: _signinkey,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              CustomTextFormField(
                                keyboardType: TextInputType.emailAddress,
                                hintText: 'Enter your email',
                                controller: _emailcontroller,
                              ),
                              CustomTextFormField(
                                keyboardType: TextInputType.visiblePassword,
                                hintText: 'Enter your password',
                                controller: _passwordcontroller,
                              ),
                              (isLoading)?Container(
                                height: 48,
                                margin: EdgeInsets.all(8),
                                color: greenColor,
                                width: double.infinity,
                                child: Center(
                                  child: const CircularProgressIndicator(
                                    color: whiteColor,
                                  ),
                                ),
                              ):CustomButton(
                                buttontitle: 'Log in',
                                callback: () {
                                  if (_signinkey.currentState!.validate()) {
                                    loginUser();
                                    print('Login success!');
                                  }
                                },
                              )
                            ],
                          ),
                        )),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

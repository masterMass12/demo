import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:majorproject/models/UserModel.dart';

import '../providers/UserProvider.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();
final TextEditingController _nameController=TextEditingController();
final TextEditingController _emailController=TextEditingController();
final TextEditingController _passwordController=TextEditingController();
  final UserProvider _userProvider = UserProvider();

  void signUp()async{
    UserModel user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    await _userProvider.signup(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Signup"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Iconsax.user),
                ),

              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Iconsax.sms),
                ),

              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Iconsax.lock),
                ),
                obscureText: true,

              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text("Sign Up"),
                onPressed: () {
                  _formKey.currentState?.save();
                  signUp();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

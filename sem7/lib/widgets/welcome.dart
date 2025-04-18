import 'package:flutter/material.dart';
import 'package:ivrapp/constants.dart';
import 'package:ivrapp/screens/auth/auth_screen.dart';
import 'package:ivrapp/widgets/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: FutureBuilder(
        future: precacheImage(AssetImage('assets/Welcome to.png'), context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: greenColor,));
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.error == null) {
            return Column(
                  children: [
                    Expanded(
                      child: Container(
                        child: Image.asset(
                          'assets/Welcome to.png',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    CustomButton(
                        callback: () {
                          Navigator.pushNamed(context, AuthScreen.routeName);
                        },
                        buttontitle: 'Get Started')
                  ],
                );
          } else {
            return Text('Error loading image');
          }
        },
      ),
    );
  }
}

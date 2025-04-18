import 'package:flutter/material.dart';

import '../constants.dart';
class CustomButton extends StatelessWidget {
  CustomButton(
      {required this.callback,
        required this.buttontitle,
        this.width = double.infinity});

  final VoidCallback callback;
  final String buttontitle;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: EdgeInsets.all(8),
      color: greenColor,
      child: TextButton(
          onPressed: callback,
          child: Text(
            buttontitle,
            style: TextStyle(color: whiteColor),
          )),
    );
  }
}
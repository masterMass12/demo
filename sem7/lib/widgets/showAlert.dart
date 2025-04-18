import 'package:ivrapp/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/material.dart';

showAlert(
    {required BuildContext context,
    required String title,
    required VoidCallback callback}) {
  return Alert(
    closeIcon: Icon(
      Icons.close,
      color: greenColor,
      size: 40,
    ),
    context: context,
    image: Image.asset(
      'assets/bulb.png',
      height: 150,
      width: 150,
      fit: BoxFit.fitHeight,
    ),
    title: "Tip",
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("• "),
              Expanded(
                child: Text(
                  'Capture only the medicine name in your image.',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("• "),
              Expanded(
                child: Text(
                    'Ensure precise cropping for optimal results as our  app keeps evolving.',
                    style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        )
      ],
    ),
    buttons: [
      DialogButton(
        color: greenColor,
        child: Text(
          "Got it",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          callback();
          Navigator.pop(context);
        },
        width: 120,
      )
    ],
  ).show();
}

import 'package:flutter/material.dart';
import 'package:ivrapp/constants.dart';
class CustomChatTextField extends StatelessWidget {
  final hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;

  CustomChatTextField(
      {required this.hintText,
        required this.controller,
        required this.keyboardType,required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: TextField(
        maxLines: null,
        keyboardType: keyboardType,
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(width: 1, color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(width: 1, color: greenColor),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String content) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
    content,
    textAlign: TextAlign.start,
    style: TextStyle(fontSize: 14),
  )));
}

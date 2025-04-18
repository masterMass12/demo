import 'package:flutter/material.dart';
import 'package:majorproject/models/UserModel.dart';

class UserProvider with ChangeNotifier {
  Future<void> signup(UserModel user) async {
    // Simulate a network call for user signup
    await Future.delayed(Duration(seconds: 1));
    print("User signed up: ${user.toJson()}");
    notifyListeners();
  }
}

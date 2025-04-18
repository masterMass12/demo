import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:ivrapp/constants.dart';
import 'package:ivrapp/widgets/http_error_handling.dart';
import 'package:ivrapp/widgets/showSnackBar.dart';

class ChatbotResult {
  Future<String> getchatbotreult(
      {required BuildContext context, required String userinput}) async {
    String reply = 'Success';
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/chatbot'),
        body: jsonEncode({
          'userinput': userinput,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorhandle(
          context: context,
          res: res,
          onSuccess: () {
            reply = jsonDecode(res.body)['result'];
          });
    } catch (err) {
      showSnackBar(context, err.toString());
    }
    return reply;
  }
}

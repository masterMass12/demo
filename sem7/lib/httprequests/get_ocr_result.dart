import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:ivrapp/constants.dart';
import 'package:ivrapp/widgets/http_error_handling.dart';
import 'package:ivrapp/widgets/showSnackBar.dart';

Future<List<String>> getOcrResult(
    {required String prescriptionUrl, required BuildContext context}) async {
  String res = 'Success';
  List<String> medicines=[];
  try {
    http.Response res = await http.post(
      Uri.parse('$uri/get-ocr'),
      body: jsonEncode({
        "url": prescriptionUrl,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    httpErrorhandle(
        context: context,
        res: res,
        onSuccess: () async {
          for (int i=0;i<jsonDecode(res.body)['message'].length;i++)
          {
            medicines.add(jsonDecode(res.body)['message'][i]);

          }

        });
  } catch (err) {
    res = err.toString();
    showSnackBar(context, err.toString());
  }
  return medicines;
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ivrapp/widgets/showSnackBar.dart';
  Future<void> httpErrorhandle({required BuildContext context,required http.Response res,required VoidCallback onSuccess})async
  {
    switch(res.statusCode)
    {
      case 200:
        onSuccess();
        break;
      case 500:
        showSnackBar(context, jsonDecode(res.body)['message']);
        break;
      default:
        showSnackBar(context, jsonDecode(res.body)['message']);
        break;


    }


  }


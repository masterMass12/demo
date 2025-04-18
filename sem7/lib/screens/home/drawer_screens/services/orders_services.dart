import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:ivrapp/model/order.dart';
import 'package:ivrapp/widgets/http_error_handling.dart';
import 'package:ivrapp/widgets/showSnackBar.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import '../../../../constants.dart';

class OrderServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> uploadOrder({required BuildContext context}) async {
    String jsonResponse = '''
{
  
    "medicines": [
      {"medicineName": "Cetcip Tablet", "quantity": 1},
      {"medicineName": "Anacin Tablet", "quantity": 10}
    ],
   
  "totalCost": 85,
  "userid":"abc",
  "orderTitle":"Cough Medicines"
  
  
}
''';

    String res = 'Order updated succesfully';

    try {
      http.Response res = await http.get(
        Uri.parse('$uri/make-phone-call'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      UserOrder order = UserOrder.fromMap(jsonDecode(res.body));
      String id = Uuid().v4();
      order = UserOrder(
          orderTitle: order.orderTitle,
          id: id,
          userid: _auth.currentUser!.uid,
          quantity: order.quantity,
          medicineName: order.medicineName,
          totalCost: order.totalCost,
          orderDate: DateTime.now().toString());
      httpErrorhandle(
          context: context,
          res: res,
          onSuccess: () async {
            await _firestore.collection('orders').doc(id).set(order.toJson());
          });
    } catch (err) {
      showSnackBar(context, err.toString());
    }
  }

  Future<List<UserOrder>> getMyOrders({required BuildContext context}) async {
    List<UserOrder> orders = [];
    try {
      QuerySnapshot snap = await _firestore
          .collection('orders')
          .where('userid', isEqualTo: _auth.currentUser!.uid)
          .get();
      for (int i = 0; i < snap.docs.length; i++) {
        orders.add(UserOrder.fromSnap(snap.docs[i]));
      }
    } catch (err) {
      showSnackBar(context, err.toString());
    }

    return orders;
  }
}

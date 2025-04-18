import 'package:cloud_firestore/cloud_firestore.dart';



class UserOrder {
  final String orderTitle;
  final String userid;
  final List<String> medicineName;
  final num totalCost;
  final List<int> quantity;
  final String id;
  final String orderDate;

  UserOrder({
     this.userid='',
    required this.orderTitle,
    required this.quantity,
    required this.medicineName,
    required this.totalCost,
    this.id='',
     this.orderDate='',
  });

  static UserOrder fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserOrder(
      userid: snapshot["userid"]??'',
      orderTitle: snapshot["orderTitle"],
      quantity: List<int>.from(snapshot["quantity"]),
      medicineName: List<String>.from(snapshot["medicineName"]),
      totalCost: snapshot["totalCost"],
      id: snapshot["id"]??'',
      orderDate: snapshot["orderDate"]??DateTime.now().toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "userid": userid,
        "medicineName": medicineName,
        "orderDate": orderDate,
        "totalCost": totalCost,
        "id": id,
    "quantity":quantity,
    "orderTitle":orderTitle
      };
  static UserOrder fromMap(Map<String,dynamic> snapshot) {
    return UserOrder(
      userid: snapshot["userid"]??'',
      orderTitle:snapshot["orderTitle"] ,
      quantity: List<int>.from(snapshot['medicines']?.map((x)=>x['quantity'])),
      medicineName: List<String>.from(
        snapshot['medicines']?.map(
              (x) => (x['medicineName']),
        ),),
      totalCost: snapshot["totalCost"],
      id: snapshot["id"]??'',
      orderDate: snapshot["orderDate"]??DateTime.now().toString(),
    );
  }

}

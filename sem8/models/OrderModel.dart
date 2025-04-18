import 'MedicineModel.dart';

class OrderModel {
  final String orderID;
  final String userID;
  final String location;
  final List<MedicineModel> medicineList;
  final String prescriptionCode;
  final bool isPrescription;
  final String status;
  final DateTime dateOfOrder;

  OrderModel({
    required this.orderID,
    required this.userID,
    required this.location,
    required this.medicineList,
    required this.prescriptionCode,
    required this.isPrescription,
    required this.status,
    required this.dateOfOrder,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    var medicines = json['medicineList'] as Map<String, dynamic>;
    List<MedicineModel> medicineList = medicines.entries.map((entry) {
      return MedicineModel(name: entry.key, quantity: entry.value);
    }).toList();

    return OrderModel(
      orderID: json['orderID'],
      userID: json['userID'],
      location: json['location'],
      medicineList: medicineList,
      prescriptionCode: json['prescriptionCode'],
      isPrescription: json['isPrescription'],
      status: json['status'],
      dateOfOrder: DateTime.parse(json['dateOfOrder']),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, int> medicines = {};
    for (var medicine in medicineList) {
      medicines[medicine.name] = medicine.quantity;
    }

    return {
      'orderID': orderID,
      'userID': userID,
      'location': location,
      'medicineList': medicines,
      'prescriptionCode': prescriptionCode,
      'isPrescription': isPrescription,
      'status': status,
      'dateOfOrder': dateOfOrder.toIso8601String(),
    };
  }
}

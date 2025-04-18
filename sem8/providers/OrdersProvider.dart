import 'package:flutter/material.dart';
import 'package:majorproject/models/MedicineModel.dart';
import 'package:majorproject/models/OrderModel.dart';
import 'package:majorproject/services/BlockChainService.dart';
import 'package:uuid/uuid.dart';

class OrderProvider with ChangeNotifier {
  String _message="";
  String   get message=> _message;
BlockChainService service=  BlockChainService();


  Future<void> createOrder(OrderModel order) async {
    _message=await service.createOrder(order);
    notifyListeners();
  }

  Future<List<OrderModel>> getOrdersByUser(String userId) async {
return await service.getOrdersByUser(userId);
  }

  Future<OrderModel> getOrderById(String orderId)async{
    return await service.queryOrder(orderId);
  }
}

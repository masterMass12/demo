import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:majorproject/models/OrderModel.dart';

class BlockChainService {
  final String baseUrl = "https://chhlxv-ip-45-117-3-152.tunnelmole.net";

  Future<String> createOrder(OrderModel order) async {

    final response = await http.post(
      Uri.parse("$baseUrl/order/create"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(order.toJson()),
    );

    if(response.statusCode==200){
      print(jsonDecode(response.body));
      return _handleResponse(response)['message'];
    }
    else{
      print(jsonDecode(response.body  ));
      return jsonDecode(response.body)['error'];
    }
  }

  Future<Map<String, dynamic>> updateOrder(String orderID, String status) async {
    final response = await http.post(
      Uri.parse("$baseUrl/updateOrder"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"orderID": orderID, "status": status}),
    );
    return _handleResponse(response);
  }

  Future<OrderModel> queryOrder(String orderID) async {
    final response = await http.get(Uri.parse("$baseUrl/queryOrder/$orderID"));
    if(response.statusCode==200){
      return OrderModel.fromJson(_handleResponse(response));
    }
    else{
      return jsonDecode(response.body)['error'];
    }
  }

  Future<List<OrderModel>> getOrdersByUser(String userID) async {
    final url = Uri.parse('$baseUrl/order/display/${userID}');
    final response = await http.get(url);
print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      List<dynamic> ordersJson = jsonDecode(response.body)['orders'];
      return ordersJson.map((json) => OrderModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<Map<String, dynamic>> verifyPrescription(String orderID, String prescriptionCode) async {
    final response = await http.post(
      Uri.parse("$baseUrl/verify"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"orderID": orderID, "prescriptionCode": prescriptionCode}),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> deliverOrder(String orderID) async {
    final response = await http.post(
      Uri.parse("$baseUrl/deliverOrder"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"orderID": orderID}),
    );
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
      return jsonDecode(response.body);

  }

  List<dynamic> _handleListResponse(http.Response response) {

      return jsonDecode(response.body)['orders'];

  }
}

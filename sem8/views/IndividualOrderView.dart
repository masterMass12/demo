import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:majorproject/models/OrderModel.dart';

import '../providers/OrdersProvider.dart';

class OrderDetailView extends StatefulWidget {
  final OrderModel orderModel;
  OrderDetailView({required this.orderModel});

  @override
  _OrderDetailViewState createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<OrderDetailView> {
  bool _isLoading = false;
  final OrderProvider _orderProvider = OrderProvider();

  @override
  void initState() {
    super.initState();
    _fetchOrder();
  }

  void _fetchOrder() async {
    setState(() {
      _isLoading = true;
    });
    // Simulate data fetching delay if needed.
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _isLoading = false;
    });
  }

  // A helper widget to create a ListTile for each order detail with an icon.
  Widget buildInfoTile(IconData icon, String title, String data) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.green,
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(data),
      contentPadding: EdgeInsets.symmetric(horizontal: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.orderModel;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Order Detail"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Order Details",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Divider(thickness: 2),
                  buildInfoTile(Iconsax.card, "Order ID", order.orderID),
                  buildInfoTile(Iconsax.user, "User ID", order.userID),
                  buildInfoTile(
                    Iconsax.location,
                    "Location",
                    order.location,
                  ),
                  buildInfoTile(
                    Iconsax.clock,
                    "Order Date",
                    "${order.dateOfOrder.toLocal().toString().split(' ')[0]}",
                  ),
                  buildInfoTile(
                    Iconsax.clipboard_text,
                    "Status",
                    order.status,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Medicines:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 8),
                  // Using ListView.separated with shrinkWrap to display medicine list.
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: order.medicineList.length,
                    separatorBuilder: (context, index) =>
                        Divider(color: Colors.grey[300]),
                    itemBuilder: (context, index) {
                      final medicine = order.medicineList[index];
                      return ListTile(
                        leading: Icon(
                          Icons.medical_services,
                          color: Colors.green,
                        ),
                        title: Text(medicine.name),
                        trailing: Text(
                          "Qty: ${medicine.quantity}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

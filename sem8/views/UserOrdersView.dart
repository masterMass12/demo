import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:majorproject/models/OrderModel.dart';
import 'package:majorproject/views/IndividualOrderView.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import '../providers/OrdersProvider.dart';

class UserOrdersView extends StatefulWidget {
  final String userId;
  UserOrdersView({this.userId = "9324309587"});

  @override
  _UserOrdersViewState createState() => _UserOrdersViewState();
}

class _UserOrdersViewState extends State<UserOrdersView> {
  List<OrderModel> _orders = [];
  bool _isLoading = false;
  final OrderProvider _orderProvider = OrderProvider();

  // Selected status filter, "All" displays every order.
  String _selectedStatus = "All";

  // Define status options. You can adjust these as needed.
  final List<String> _statusOptions = ["All", "Pending", "Completed", "Cancelled"];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() {
      _isLoading = true;
    });
    List<OrderModel> fetchedOrders = await _orderProvider.getOrdersByUser(widget.userId);
    // Sort orders by date (most recent first)
    fetchedOrders.sort((a, b) => b.dateOfOrder.compareTo(a.dateOfOrder));
    setState(() {
      _orders = fetchedOrders;
      _isLoading = false;
    });
  }

  // Build a custom card that displays order details.
  Widget buildOrderCard(OrderModel order) {
    // Format date using intl.
    String formattedDate = DateFormat('yyyy-MM-dd').format(order.dateOfOrder);

    // Create a list of Chips for each medicine.
    List<Widget> medicineChips = order.medicineList.map((medicine) {
      return Chip(
        label: Text("${medicine.name} (Qty: ${medicine.quantity})"),
        backgroundColor: Colors.green.withOpacity(0.1),
      );
    }).toList();

    return GestureDetector(

      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (context) => OrderDetailView(orderModel: order),
          ),
        );


      },

      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Order ID and status.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Order ID: ${order.orderID}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      order.status,
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              // Order Location.
              Row(
                children: [
                  Icon(Iconsax.location, color: Colors.green),
                  SizedBox(width: 6),
                  Expanded(child: Text(order.location)),
                ],
              ),
              SizedBox(height: 8),
              // Medicine Details using Wrap and Chips.
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Iconsax.box, color: Colors.green),
                  SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Medicines:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        SizedBox(height: 4),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: medicineChips,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              // Prescription Code, if available.
              if (order.isPrescription)
                Row(
                  children: [
                    Icon(Iconsax.clipboard_text, color: Colors.green),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text("Prescription Code: ${order.prescriptionCode}"),
                    ),
                  ],
                ),
              SizedBox(height: 8),
              // Order Date.
              Row(
                children: [
                  Icon(Iconsax.clock, color: Colors.green),
                  SizedBox(width: 6),
                  Expanded(child: Text("Date: $formattedDate")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter orders based on selected status.
    List<OrderModel> filteredOrders = _selectedStatus == "All"
        ? _orders
        : _orders.where((order) => order.status == _selectedStatus).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("User Orders"),
        backgroundColor: Colors.green,
        actions: [
          // Dropdown filter for status
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.green, // Dropdown background
                border: Border.all(color: Colors.white, width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedStatus,
                  icon: Icon(Iconsax.filter, color: Colors.white),
                  dropdownColor: Colors.green[700],
                  style: TextStyle(color: Colors.white),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedStatus = value;
                      });
                    }
                  },
                  items: _statusOptions.map((status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

        ],
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: Colors.green,
        ),
      )
          : RefreshIndicator(
        onRefresh: _fetchOrders,
        child: ListView.builder(
          padding: EdgeInsets.only(top: 16, bottom: 16),
          itemCount: filteredOrders.length,
          itemBuilder: (context, index) {
            OrderModel order = filteredOrders[index];
            return buildOrderCard(order);
          },
        ),
      ),
    );
  }
}

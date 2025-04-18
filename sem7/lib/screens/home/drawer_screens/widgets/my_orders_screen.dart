import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ivrapp/constants.dart';
import 'package:ivrapp/screens/home/drawer_screens/services/orders_services.dart';
import '../../../../model/order.dart';

class MyOrdersScreen extends StatefulWidget {
  static const routeName = '/my-orders';
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  List<UserOrder> orders = [];
  Future<void> getOrders() async {
    orders = await OrderServices().getMyOrders(context: context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: whiteColor,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Your Orders',
          style: TextStyle(color: whiteColor),
        ),
      ),
      body: FutureBuilder(
        future: getOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.hasError) {
            return Center(
              child: const CircularProgressIndicator(
                color: greenColor,
              ),
            );
          }
          return (orders.isEmpty)
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'You have no orders yet.',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'You can place orders via our app or via call.',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: ListView.builder(
                      shrinkWrap: false,
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        var order = orders[index];

                        return BuildOrdersList(order: order);
                      }),
                );
        },
      ),
    );
  }
}

class BuildOrdersList extends StatelessWidget {
  const BuildOrdersList({
    super.key,
    required this.order,
  });

  final UserOrder order;
  String convertDateToString(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    DateTime scheduleDate = dateTime.add(Duration(days: 2));
    // Format the date, month, and year using the intl package
    String formattedDate = DateFormat('dd').format(dateTime) + ' ';
    String formattedMonth = DateFormat('MMMM').format(dateTime) + ' ';
    String formattedYear = DateFormat('yyyy').format(dateTime);
    String date = formattedDate + formattedMonth + formattedYear;
    return date;
  }

  @override
  Widget build(BuildContext context) {
    String date = convertDateToString(order.orderDate);
    String text =
        (order.id.length > 3) ? '${order.id.substring(0, 6)}...' : order.id;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(8),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(width: 1, color: Colors.grey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                order.orderTitle,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Expanded(child: SizedBox()),
              Text(' id: ' + text),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Date',
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                      Text(date)
                    ],
                  ),
                  Expanded(
                    child: VerticalDivider(
                      indent: 10,
                      color: Colors.grey,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Schedule',
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                      Expanded(child: SizedBox()),
                      Text(date)
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Text('Order id:         ' + text),
          // Text('Ordered at:    ' +
          //     date.toString()),
          // Text('Order total:    ₹' +
          //     order.totalCost.toString()),
        ],
      ),
    );
  }
}

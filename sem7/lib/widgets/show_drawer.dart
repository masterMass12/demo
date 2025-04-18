import 'package:flutter/material.dart';
import 'package:ivrapp/screens/home/drawer_screens/account_screen.dart';
import 'package:ivrapp/screens/home/drawer_screens/prescriptions_screen.dart';
import 'package:ivrapp/screens/home/drawer_screens/widgets/my_orders_screen.dart';

import '../constants.dart';

showDrawer({required BuildContext context}) {
  void goToaccount() {
    Navigator.of(context).pop();
    Navigator.pushNamed(context, MyAccount.routeName);
  }

  void goToPrescriptions()
  {
    Navigator.of(context).pop();
    Navigator.pushNamed(context, PrescriptionScreen.routeName);


  }

  void goToMyOrders() {
    Navigator.of(context).pop();
    Navigator.pushNamed(context, MyOrdersScreen.routeName);
  }


  return SafeArea(
    child: ScaffoldMessenger(
        child: Drawer(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            CircleAvatar(
              child: Icon(
                Icons.person_outline_outlined,
                size: 60,
              ),
              radius: 60,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Column(
                  children: [
                    DrawerChild(
                      title: 'My Account',
                      callback: () => goToaccount(),
                      iconimage: 'assets/user.png',
                    ),
                    DrawerChild(
                      title: 'Your orders',
                      callback: () => goToMyOrders(),
                      iconimage: '',
                    ),
                    DrawerChild(
                      title: 'Your Prescriptions',
                      callback: () => goToPrescriptions(),
                      iconimage: 'assets/medical-prescription.png',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: whiteColor,
    )),
  );
}

class DrawerChild extends StatelessWidget {
  const DrawerChild(
      {super.key,
      required this.title,
      required this.callback,
      required this.iconimage});
  final String title;
  final String iconimage;
  final VoidCallback callback;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: GestureDetector(
        onTap: callback,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (iconimage.isEmpty)
                ? Icon(Icons.shopping_bag,size: 30,color: Colors.black,)
                : Container(
                    width: 30,
                    height: 30,
                    child: Image.asset(
                      iconimage,
                      width: 512,
                      height: 512,
                      fit: BoxFit.contain,
                    ),
                  ),
            const SizedBox(
              width: 10,
            ),
            Text(
              title,
            )
          ],
        ),
      ),
    );
  }
}

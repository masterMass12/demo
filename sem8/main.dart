import 'package:flutter/material.dart';
import 'package:majorproject/providers/OrdersProvider.dart';
import 'package:majorproject/views/CreateOrderView.dart';
import 'package:majorproject/views/IndividualOrderView.dart';
import 'package:majorproject/views/SignUpView.dart';
import 'package:majorproject/views/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>OrderProvider())
      ],
      child: MaterialApp(
        title: 'Medicine App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide(color: Colors.green)
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide(color: Colors.green)
        )
          ),
          primaryColor: Colors.green,
          elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,

          )),
          hintColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Poppins',
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
        home: HomeScreen(),
      ),
    );
  }
}

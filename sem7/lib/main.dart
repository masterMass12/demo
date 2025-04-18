
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ivrapp/constants.dart';
import 'package:ivrapp/providers/prescription_provider.dart';
import 'package:ivrapp/providers/user_provider.dart';
import 'package:ivrapp/routes.dart';
import 'package:ivrapp/screens/home/drawer_screens/account_screen.dart';
import 'package:ivrapp/widgets/welcome.dart';
import 'package:provider/provider.dart';
import 'screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyClXFIDLgvrsqETUmYP3WiuQS-V5YEi4ig",
            authDomain: "ivrapp-a8748.firebaseapp.com",
            projectId: "ivrapp-a8748",
            storageBucket: "ivrapp-a8748.appspot.com",
            messagingSenderId: "237705871082",
            appId: "1:237705871082:web:a3144e707c4b3b3e5f2193",
            measurementId: "G-Q9L4PWVWMY"));
  }
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PrescriptionProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(foregroundColor: Colors.black),
          // iconButtonTheme: IconButtonThemeData(
          //     style: ButtonStyle(
          //         iconColor: MaterialStateProperty.all<Color>(whiteColor))),
          //iconTheme: IconThemeData().copyWith(color: whiteColor),
          appBarTheme: AppBarTheme().copyWith(color: greenColor),
          colorScheme: ColorScheme.fromSeed(seedColor: greenColor),
          useMaterial3: true,
        ),
        onGenerateRoute: (settings) => getRoutes(settings),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return HomeScreen();
              } else if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text('${snapshot.error}'),
                  ),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: greenColor,
                ),
              );
            }
            return WelcomeScreen();
          },
        ),
      ),
    );
  }
}

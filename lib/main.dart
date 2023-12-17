import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ninja_money/authentication/auth.dart';
import 'package:ninja_money/authentication/login_register.dart';
import 'package:ninja_money/firebase_options.dart';
import 'package:ninja_money/pages/expense_page.dart';
import 'package:ninja_money/pages/home_page.dart';
import 'package:ninja_money/pages/income_page.dart';
//import 'package:ninja_money/pages/income_page.dart';
import 'package:ninja_money/pages/profile_page.dart';
import 'package:ninja_money/pages/transaction_page.dart';
import 'package:ninja_money/theme/light_mode.dart';
import 'package:ninja_money/theme/dark_mode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthenticationPage(),
      theme: lightMode,
      darkTheme: darkMode,
      routes: {
        '/login_register_page': (context) => const LoginOrRegisterPage(),
        '/home_page': (context) => HomePage(),
        '/profile_page': (context) => ProfilePage(),
        '/expense_page': (context) => ExpensePage(),
        '/income_page': (context) => IncomePage(),
        '/transaction_page': (context) => const TransactionPage(),
      },
    );
  }
}

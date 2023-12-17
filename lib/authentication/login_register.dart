import 'package:flutter/material.dart';
import 'package:ninja_money/pages/login_page.dart';
import 'package:ninja_money/pages/register_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  //show login page first
  bool showLogin = true;
  //toggle between login and register
  void togglePage() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogin) {
      return LoginPage(onTap: togglePage);
    } else {
      return RegisterPage(onTap: togglePage);
    }
  }
}

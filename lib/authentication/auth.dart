import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ninja_money/authentication/login_register.dart';
import 'package:ninja_money/pages/home_page.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //if logged in
          if (snapshot.hasData) {
            return const HomePage();
          }
          //if logged out
          else {
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ninja_money/components/helper_functions.dart';
import 'package:ninja_money/components/my_textfield.dart';
import 'package:ninja_money/components/my_button.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({
    super.key,
    required this.onTap,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text controllers
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  void login() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayMessage(e.code, context);
    }
    emailController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Logo
                Icon(
                  Icons.attach_money_rounded,
                  size: 80,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                const SizedBox(height: 25),
                //App Name
                const Text("N I N J A", style: TextStyle(fontSize: 20)),
                const SizedBox(height: 5),
                const Text("M O N E Y", style: TextStyle(fontSize: 20)),
                const SizedBox(height: 50),
                //Email TextField
                MyTextField(
                  hintText: "Email Address",
                  obscureText: false,
                  controller: emailController,
                ),
                const SizedBox(height: 10),
                //Password TextField
                MyTextField(
                  hintText: "Password",
                  obscureText: true,
                  controller: passwordController,
                ),
                const SizedBox(height: 10),
                //Forgot Password
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Forgot Password?",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary)),
                  ],
                ),
                const SizedBox(height: 25),
                //Sign in Button
                MyButton(
                  text: "Login",
                  onTap: login,
                ),
                const SizedBox(height: 25),
                //Register Here
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

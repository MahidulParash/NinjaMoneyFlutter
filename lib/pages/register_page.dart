import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ninja_money/components/helper_functions.dart';
import 'package:ninja_money/components/my_textfield.dart';
import 'package:ninja_money/components/my_button.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text controllers
  final TextEditingController userController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();
  void register() async {
    //loading circle
    showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    //match pass
    if (passwordController.text != confirmPasswordController.text) {
      Navigator.pop(context);
      displayMessage("Passwords don't match", context);
    }
    //create user
    else {
      try {
        // ignore: unused_local_variable
        UserCredential? userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        createUserDoc(userCredential);

        if (context.mounted) Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        displayMessage(e.code, context);
      }
      userController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
    }
  }

  Future<void> createUserDoc(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'email': userCredential.user!.email,
        'username': userController.text,
      });
    }
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
                  hintText: "Username",
                  obscureText: false,
                  controller: userController,
                ),
                const SizedBox(height: 10),
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
                //Password TextField
                MyTextField(
                  hintText: "Confirm Password",
                  obscureText: true,
                  controller: confirmPasswordController,
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
                  text: "Register",
                  onTap: register,
                ),
                const SizedBox(height: 25),
                //Register Here
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Login",
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});
  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: SingleChildScrollView(
        child: Column(
          children: [
            DrawerHeader(
              child: Row(
                children: [
                  Icon(
                    Icons.attach_money_rounded,
                    size: 80,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  const Column(
                    children: [
                      SizedBox(
                        height: 45,
                      ),
                      Text(
                        "N I N J A",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        "M O N E Y",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: ListTile(
                leading: const Icon(Icons.home),
                title: const Text(
                  "H O M E",
                  style: TextStyle(fontSize: 12),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/home_page');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: ListTile(
                leading: const Icon(Icons.person),
                title: const Text(
                  "P R O F I L E",
                  style: TextStyle(fontSize: 12),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/profile_page');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: ListTile(
                leading: const Icon(Icons.arrow_upward),
                title: const Text(
                  "I N C O M E",
                  style: TextStyle(fontSize: 12),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/income_page');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: ListTile(
                leading: const Icon(Icons.arrow_downward),
                title: const Text(
                  "E X P E N S E",
                  style: TextStyle(fontSize: 12),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/expense_page');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 25.0,
                bottom: 25.0,
              ),
              child: ListTile(
                leading: const Icon(Icons.logout),
                title: const Text(
                  "L O G O U T",
                  style: TextStyle(fontSize: 12),
                ),
                onTap: () {
                  Navigator.pop(context);
                  logout();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

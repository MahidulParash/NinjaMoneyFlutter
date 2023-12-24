// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:ninja_money/components/my_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(user!.email)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text("H O M E"),
        elevation: 0,
      ),
      drawer: const MyDrawer(),

      //BODY
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome!",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 12,
            ),
            TransactionTotal(),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class Transaction {
  String type;
  double amount;
  String category;
  String description;
  Timestamp timestamp;

  Transaction({
    required this.type,
    required this.amount,
    required this.category,
    required this.description,
    required this.timestamp,
  });
}

class TransactionTotalValues {
  final double income;
  final double expense;
  final double balance;

  TransactionTotalValues({
    required this.income,
    required this.expense,
    required this.balance,
  });
}

class TransactionTotal extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.email)
          .collection('transactions')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        List<Transaction> transactions = snapshot.data!.docs.map((doc) {
          return Transaction(
              type: doc['type'],
              amount: doc['amount'],
              category: doc['category'],
              description: doc['description'],
              timestamp: doc['timestamp']);
        }).toList();

        double income = transactions
            .where((transaction) => transaction.type == 'Income')
            .fold(0, (sum, transaction) => sum + transaction.amount);

        double expense = transactions
            .where((transaction) => transaction.type == 'Expense')
            .fold(0, (sum, transaction) => sum + transaction.amount);

        double balance = income - expense;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        child: Text(
                          '৳ ${balance.toString()}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Balace',
                        ),
                        Icon(Icons.balance),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        child: Text(
                          '৳ ${income.toString()}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Income',
                        ),
                        Icon(Icons.arrow_upward),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        child: Text(
                          '৳ ${expense.toString()}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Expense',
                        ),
                        Icon(Icons.arrow_downward),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/*
// CONTAINER WIDGET
class HomeContainer extends StatelessWidget {
  final Color bgColor;
  final Icon typeIcon;
  final String type;
  const HomeContainer({
    super.key,
    required this.bgColor,
    required this.typeIcon,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              child: TransactionTotal(),
              
            ),
          ),
          Row(
            children: [
              Text(
                type,
              ),
              typeIcon,
            ],
          ),
        ],
      ),
    );
  }
}

 */
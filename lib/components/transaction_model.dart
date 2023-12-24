import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

class TransactionList extends StatelessWidget {
  final String typeName;
  User? user = FirebaseAuth.instance.currentUser;

  TransactionList({
    super.key,
    required this.typeName,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.email)
          .collection('transactions')
          .where('type', isEqualTo: typeName)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('Add $typeName (s)');
        } else {
          List<Transaction> transactions = snapshot.data!.docs.map((doc) {
            return Transaction(
                type: doc['type'],
                amount: doc['amount'],
                category: doc['category'],
                description: doc['description'],
                timestamp: doc['timestamp']);
          }).toList();

          double totalAmount = transactions.fold(
            0,
            (previousValue, element) => previousValue + element.amount,
          );

          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '৳ ${totalAmount.toString()}',
                        style: TextStyle(fontSize: 32),
                      ),
                      Text("Total"),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(transactions[index].category),
                                      Text(
                                        '৳ ${transactions[index].amount.toString()}',
                                        style: TextStyle(fontSize: 24),
                                      ),
                                      Text(
                                        transactions[index].description,
                                        style: TextStyle(fontSize: 8),
                                      ),
                                      Text(
                                        DateFormat('dd-MM-yy HH:mm a')
                                            .format(transactions[index]
                                                .timestamp
                                                .toDate())
                                            .toString(),
                                        style: TextStyle(fontSize: 8),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

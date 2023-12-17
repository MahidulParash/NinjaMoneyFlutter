import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

/*
Each transaction will have
-type : Income or Expense
-amount: BDT
-category: 
-description:
-timestamp 

*/

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;

  List<String> type = [
    'Expense',
    'Income',
  ];

  List<String> categories = [
    'Food',
    'Transport',
    'Clothes',
    'Necessities',
    'Others'
  ];

  String selectedType = 'Expense';
  String selectedCategory = 'Food';

  Map<String, dynamic> createTransactionData({
    required String type,
    required double? amount,
    required String category,
    required String description,
  }) {
    Timestamp timestamp = Timestamp.now();

    return {
      'type': type,
      'amount': amount,
      'category': category,
      'description': description,
      'timestamp': timestamp,
    };
  }

  Future<void> addTransaction(Map<String, dynamic> transactionData) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user?.email)
        .collection('transactions')
        .add(transactionData);
  }

  Future<void> deleteTransaction(String transactionId) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user?.email)
        .collection('transactions')
        .doc(transactionId)
        .delete();
  }

  Future<void> showTransactionDialog(BuildContext context) async {
    double? amount;
    String description = '';

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add a New Transaction'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: selectedType,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedType = newValue!;
                    });
                  },
                  items: type.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  decoration: const InputDecoration(labelText: 'Type'),
                ),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Amount'),
                  onChanged: (value) => amount = double.tryParse(value),
                ),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                  items: categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(hintText: 'Description'),
                  onChanged: (value) => description = value,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (type.isNotEmpty && amount != null) {
                  addTransaction(createTransactionData(
                      type: selectedType,
                      amount: amount,
                      category: selectedCategory,
                      description: description));
                  _amountController.clear();
                  _descriptionController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Page'),
      ),
      body: Center(
        child: FloatingActionButton(
          onPressed: () {
            showTransactionDialog(context);
          },
          tooltip: 'Add Transaction',
          elevation: 3.0,
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}

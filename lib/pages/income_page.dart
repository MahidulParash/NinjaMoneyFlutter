import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ninja_money/components/transaction_model.dart';

class IncomePage extends StatefulWidget {
  IncomePage({super.key});

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  final TextEditingController _amountController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;

  List<String> categories = [
    'Food',
    'Transport',
    'Clothes',
    'Necessities',
    'Others'
  ];

  String selectedType = 'Income';

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
          title: const Text('Add Income'),
          content: SingleChildScrollView(
            child: Column(
              children: [
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
                if (amount != null) {
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
        title: const Text('I N C O M E'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Column(
        children: [
          Container(),
          Expanded(child: TransactionList(typeName: 'Income')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showTransactionDialog(context);
        },
        tooltip: 'Add Transaction',
        elevation: 3.0,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

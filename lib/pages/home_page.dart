import 'package:flutter/material.dart';
import 'package:ninja_money/components/my_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(user!.email)
        .get();
  }

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
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text("H O M E"),
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showTransactionDialog(context);
        },
        shape: const CircleBorder(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

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
            HomeContainer(
              bgColor: Colors.green.shade300,
              typeIcon: Icon(Icons.arrow_upward),
              type: 'Income',
            ),
            SizedBox(
              height: 10,
            ),
            HomeContainer(
              bgColor: Colors.red.shade300,
              typeIcon: Icon(Icons.arrow_downward),
              type: 'Expense',
            ),
          ],
        ),
      ),
    );
  }
}

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
              child: TransactionTotal(
                typeName: type,
              ),
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

class TransactionTotal extends StatelessWidget {
  final String typeName;
  User? user = FirebaseAuth.instance.currentUser;

  TransactionTotal({
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

          return Text(
            '৳ ${totalAmount.toString()}',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 32,
            ),
          );
        }
      },
    );
  }
}

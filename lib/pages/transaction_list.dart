import 'package:flutter/material.dart';
import 'package:jokiapp/components/transaction_row.dart';
import 'package:jokiapp/models/transaction_model.dart';
import 'package:jokiapp/services/transaction_services.dart';
import 'package:jokiapp/models/user_provider.dart'; 
import 'package:provider/provider.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class TransactionList extends StatefulWidget {
  const TransactionList({super.key});

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  late Future<List<TransactionData>> _futureTransactions;
  final TransactionService _transactionService = TransactionService();

  @override
  void initState() {
    super.initState();
    _futureTransactions = _transactionService.getTransactions();
  }

  void _refreshTransactions() {
    setState(() {
      _futureTransactions = _transactionService.getTransactions();
    });
  }

  Future<void> _takeJob(String token, String transactionId, String jokiStatus) async {
    try {
      await _transactionService.takeJob(token, transactionId, jokiStatus);
      scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(content: Text('Job taken successfully')),
      );
      _refreshTransactions();
    } catch (e) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
Widget build(BuildContext context) {
  final userProvider = Provider.of<UserProvider>(context);

  return ScaffoldMessenger(
    key: scaffoldMessengerKey,
    child: Scaffold(
      backgroundColor: const Color.fromRGBO(244, 244, 244, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Text(
              'Joki By Dante',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'josefinSans',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Transaction List',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      _refreshTransactions();
                    },
                  ),
                ],
              ),
            ),
            // Expanded widget is added here to allow the ListView to take available space
            Expanded(
              child: FutureBuilder<List<TransactionData>>(
                future: _futureTransactions,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No transactions found.'));
                  } else {
                    List<TransactionData> transactions = snapshot.data!;

                    if (userProvider.role != 'admin') {
                      transactions = transactions
                          .where((transaction) =>
                              transaction.jokiStatus == 'actionNeeded' &&
                              transaction.paymentStatus == true)
                          .toList();
                    }

                    if (transactions.isEmpty) {
                      return const Center(
                          child: Text('No action needed transactions found.'));
                    }

                    return ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                          child: TransactionRow(
                            transaction: transaction,
                            onCheck: () {
                              final token = Provider.of<UserProvider>(
                                context,
                                listen: false,
                              ).token ?? '';
                              if (userProvider.role == 'worker') {
                                _showConfirmationDialog(context, token, transaction.transactionId, 'onProgress');
                              } else {
                                print('EDIT TRANSACTION');
                              }
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  void _showConfirmationDialog(BuildContext context, String token,
      String transactionId, String jokiStatus) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to take this job?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor:
                    const Color.fromRGBO(43, 52, 153, 1), // Button color
              ),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                try {
                  await _transactionService.takeJob(
                      token, transactionId, jokiStatus);
                  scaffoldMessengerKey.currentState?.showSnackBar(
                    const SnackBar(content: Text('Job taken')),
                  );
                } catch (e) {
                  scaffoldMessengerKey.currentState?.showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
                _refreshTransactions();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}


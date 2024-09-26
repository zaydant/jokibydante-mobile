import 'package:flutter/material.dart';
import 'package:jokiapp/components/details_dialog.dart';
import 'package:jokiapp/components/transaction_row.dart';
import 'package:jokiapp/models/transaction_model.dart';
import 'package:jokiapp/models/user_provider.dart';
import 'package:jokiapp/services/transaction_services.dart';
import 'package:provider/provider.dart';

class JobList extends StatefulWidget {
  const JobList({super.key});

  @override
  _JobListState createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  late Future<List<TransactionData>> _futureTransactions;
  final TransactionService _transactionService = TransactionService();

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _futureTransactions = _transactionService.getOwnedJobs(userProvider.token ?? '');
  }

  // Function to refresh the transaction list
  void _refreshTransactions() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      _futureTransactions = _transactionService.getOwnedJobs(userProvider.token ?? '');
    });
  }

  // Function to show the dialog using the separate component
  void _showTransactionDetailsDialog(TransactionData transaction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TransactionDetailsDialog(transaction: transaction);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Job List',
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
              const SizedBox(height: 20),
              FutureBuilder<List<TransactionData>>(
                future: _futureTransactions,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No transactions found.'));
                  } else {
                    final filteredTransactions = snapshot.data!;

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = filteredTransactions[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                          child: TransactionRow(
                            transaction: transaction,
                            onCheck: () => _showTransactionDetailsDialog(transaction),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

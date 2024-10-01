import 'package:flutter/material.dart';
import 'package:jokiapp/components/details_dialog.dart';
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

  // Search Controller
  final TextEditingController _searchController = TextEditingController();
  List<TransactionData> _filteredTransactions = [];
  List<TransactionData> _allTransactions = []; // Store all transactions here
  String _searchQuery = '';

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

  // Function to filter transactions based on the search query
  void _filterTransactions() {
    setState(() {
      _filteredTransactions = _allTransactions
          .where((transaction) =>
              transaction.transactionId
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              transaction.rank.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              transaction.reqHero.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    });
  }

  // Function to show the dialog using the separate component
  void _showTransactionDetailsDialog(TransactionData transaction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TransactionDetailsDialog(
          transaction: transaction,
          onFinishTransaction: _refreshTransactions,
        );
      },
    );
  }

  Future<void> _updateTransaction(
      String token, String transactionId, String jokiStatus) async {
    try {
      await _transactionService.updateTransaction(
          token, transactionId, jokiStatus);
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color.fromRGBO(131, 162, 255, 0.3)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Search',
                    prefixIcon: const Icon(Icons.search, color: Color.fromRGBO(43, 52, 153, 1),),
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                      _filterTransactions(); // Filter as the user types
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: FutureBuilder<List<TransactionData>>(
                  future: _futureTransactions,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('No transactions found.'));
                    } else {
                      _allTransactions = snapshot.data!;

                      List<TransactionData> transactions = _filteredTransactions.isEmpty
                          ? _allTransactions
                          : _filteredTransactions;

                      transactions.sort((a, b) {
                        if (a.paymentStatus == false &&
                            b.paymentStatus == true) return -1;
                        if (a.paymentStatus == true &&
                            b.paymentStatus == false) return 1;

                        if (a.jokiStatus == 'actionNeeded' &&
                            b.jokiStatus != 'actionNeeded') return -1;
                        if (a.jokiStatus != 'actionNeeded' &&
                            b.jokiStatus == 'actionNeeded') return 1;

                        if (a.jokiStatus == 'onProgress' &&
                            b.jokiStatus != 'onProgress') return -1;
                        if (a.jokiStatus != 'onProgress' &&
                            b.jokiStatus == 'onProgress') return 1;

                        return b.createdAt.compareTo(a.createdAt);
                      });

                      if (userProvider.role != 'admin') {
                        transactions = transactions
                            .where((transaction) =>
                                transaction.jokiStatus == 'actionNeeded' &&
                                transaction.paymentStatus == true)
                            .toList();
                      }

                      if (transactions.isEmpty) {
                        return const Center(
                            child:
                                Text('No action needed transactions found.'));
                      }

                      return ListView.builder(
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = transactions[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
                            child: TransactionRow(
                              transaction: transaction,
                              onCheck: () {
                                final token = Provider.of<UserProvider>(
                                          context,
                                          listen: false,
                                        ).token ??
                                    '';
                                if (userProvider.role == 'worker') {
                                  const jokiStatus = 'onProgress';
                                  const action = "update";
                                  _showConfirmationDialog(
                                      context,
                                      token,
                                      transaction.transactionId,
                                      jokiStatus,
                                      action);
                                } else {
                                  _showTransactionDetailsDialog(transaction);
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
      String transactionId, String jokiStatus, String action) {
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
                  await _transactionService.updateTransaction(
                      token, transactionId, jokiStatus);
                } catch (e) {
                  scaffoldMessengerKey.currentState?.showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
                scaffoldMessengerKey.currentState?.showSnackBar(
                  const SnackBar(content: Text('Job taken')),
                );
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

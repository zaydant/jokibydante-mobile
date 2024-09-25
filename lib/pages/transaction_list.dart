import 'package:flutter/material.dart';
import 'package:jokiapp/models/transaction_model.dart';
import 'package:jokiapp/services/transaction_services.dart';
import 'package:jokiapp/models/user_provider.dart'; // Assuming this is where your UserProvider is located
import 'package:provider/provider.dart';

// GlobalKey for ScaffoldMessenger
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

  // Function to refresh the transaction list
  void _refreshTransactions() {
    setState(() {
      _futureTransactions = _transactionService.getTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return ScaffoldMessenger(
      key: scaffoldMessengerKey, // Assign the key here
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
                FutureBuilder<List<TransactionData>>(
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
                      List<TransactionData> transactions = snapshot.data!;

                      // Apply filters if user is not an admin
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

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: _buildColumns(userProvider.role),
                          rows: _buildRows(userProvider.role, transactions),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns(String? role) {
    // Use a new list that combines the base columns and admin columns conditionally
    List<DataColumn> columns = [
      const DataColumn(label: Text('Rank')),
      const DataColumn(label: Text('Pay')),
      const DataColumn(label: Text('Req Hero')),
      const DataColumn(label: Text('Action')),
    ];

    // If the user is an admin, add extra columns
    if (role == 'admin') {
      columns.clear();
      columns.addAll([
        DataColumn(label: Text('Transaction ID')),
        DataColumn(label: Text('Owner')),
        DataColumn(label: Text('Rank')),
        DataColumn(label: Text('Pay')),
        DataColumn(label: Text('Req Hero')),
        DataColumn(label: Text('Email')),
        DataColumn(label: Text('Notes')),
        DataColumn(label: Text('Contact Number')),
        DataColumn(label: Text('Payment Method')),
        DataColumn(label: Text('Payment Status')),
        DataColumn(label: Text('Joki Status')),
        DataColumn(label: Text('Actions')),
      ]);
    }

    return columns;
  }

  List<DataRow> _buildRows(String? role, List<TransactionData> transactions) {
    return transactions.map((transaction) {
      // Create a mutable list of DataCells
      List<DataCell> cells = [
        DataCell(
            Text(transaction.rank + ' x' + transaction.quantity.toString())),
        DataCell(Text(transaction.price)),
        DataCell(Text(transaction.reqHero)),
        DataCell(
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor:
                  const Color.fromRGBO(43, 52, 153, 1), // Button color
            ),
            onPressed: () {
              _showConfirmationDialog(
                  context,
                  Provider.of<UserProvider>(context, listen: false).token ?? '',
                  transaction.transactionId,
                  'onProgress');
            },
            child: const Text('TAKE'),
          ),
        ),
      ];

      // Add extra cells for admin
      if (role == 'admin') {
        cells.clear();
        cells.addAll([
          DataCell(Text(transaction.transactionId)),
          DataCell(Text(transaction.owner ?? 'N/A')),
          DataCell(
              Text(transaction.rank + ' x' + transaction.quantity.toString())),
          DataCell(Text(transaction.price)),
          DataCell(Text(transaction.reqHero)),
          DataCell(Text(transaction.email)),
          DataCell(Text(transaction.notes)),
          DataCell(Text(transaction.contactNumber)),
          DataCell(Text(transaction.paymentMethod)),
          DataCell(Text(transaction.paymentStatus.toString())),
          DataCell(Text(transaction.jokiStatus)),
          DataCell(
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        const Color.fromRGBO(43, 52, 153, 1), // Button color
                  ),
                  onPressed: () {},
                  child: const Text('EDIT'),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        const Color.fromRGBO(43, 52, 153, 1), // Button color
                  ),
                  onPressed: () {},
                  child: const Text('DELETE'),
                ),
              ],
            ),
          ),
        ]);
      }

      return DataRow(cells: cells);
    }).toList();
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

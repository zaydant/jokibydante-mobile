import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jokiapp/models/transaction_model.dart';
import 'package:jokiapp/services/transaction_services.dart';

class PaymentPage extends StatefulWidget {
  final String transactionId;
  String? email;
  String? password;
  String? loginMethod;
  String? hero;
  String? notes;
  String? contact;
  String? serviceTitle;
  int? quantity;
  double? totalPrice;
  String? paymentMethod;
  bool? paymentStatus;
  String? jokiStatus;

  PaymentPage({
    super.key,
    required this.transactionId,
    this.email,
    this.password,
    this.loginMethod,
    this.hero,
    this.notes,
    this.contact,
    this.serviceTitle,
    this.quantity,
    this.totalPrice,
    this.paymentMethod,
    this.jokiStatus,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TransactionService _transactionService = TransactionService();
  Timer? _timer;

  void _getTransactionById() async {
    // Fetch the transaction by its ID
    TransactionModel? fetchedTransaction =
        await _transactionService.getTransactionById(widget.transactionId);

    if (fetchedTransaction != null) {
      setState(() {
        // Update the state with the fetched data
        widget.email = fetchedTransaction.email;
        widget.password = fetchedTransaction.password;
        widget.loginMethod = fetchedTransaction.loginMethod;
        widget.hero = fetchedTransaction.reqHero;
        widget.notes = fetchedTransaction.notes;
        widget.contact = fetchedTransaction.contactNumber;
        widget.serviceTitle = fetchedTransaction.rank;
        widget.quantity = fetchedTransaction.quantity;
        widget.totalPrice = fetchedTransaction.price;
        widget.paymentMethod = fetchedTransaction.paymentMethod;
        widget.paymentStatus = fetchedTransaction.paymentStatus;
        widget.jokiStatus = fetchedTransaction.jokiStatus;
      });
    } else {
      print('Transaction not found');
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch the transaction when the page loads
    _getTransactionById();
    // Set a timer to refresh the data every 30 seconds
    _timer = Timer.periodic(const Duration(seconds: 30), (Timer timer) {
      _getTransactionById();
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 244, 244, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Payment Confirmation'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _getTransactionById();
            },)
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thank you for ordering!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Make sure your account details are correct before paying!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailsCard(),
                  const SizedBox(height: 20),
                  _buildPaymentInstructions(),
                  const SizedBox(height: 20),
                  _buildTransactionInfo(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            color: Color(0x33000000),
            offset: Offset(0, 0),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            _buildRow('Email', widget.email),
            const SizedBox(height: 20),
            _buildRow('Password', widget.password),
            const SizedBox(height: 20),
            _buildRow('Login Method', widget.loginMethod),
            const SizedBox(height: 20),
            _buildRow('Req Hero', widget.hero),
            const SizedBox(height: 20),
            _buildRow('Notes', widget.notes),
            const SizedBox(height: 20),
            _buildRow('Contact Person', widget.contact),
            const SizedBox(height: 20),
            _buildRow('Service', '${widget.serviceTitle} x${widget.quantity}'),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 15)),
        Text(value ?? '', style: const TextStyle(fontSize: 15)),
      ],
    );
  }

  Widget _buildPaymentInstructions() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              color: Color(0x33000000),
              offset: Offset(0, 0),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(20), // Rounded corners
        ),
        child: widget.paymentMethod == 'Bank Transfer'
            ? Column(children: [
                Image.asset(
                  'assets/images/bca.png',
                  width: 100,
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text('6663338172',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 15,
                ),
                const Text('ACCOUNT HOLDER NAME',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ])
            : Column(children: [
                Image.asset(
                  'assets/images/gopay.png',
                  width: 100,
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text('081234567890',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 15,
                ),
                const Text('ACCOUNT HOLDER NAME',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ]),
      ),
    );
  }

  Widget _buildTransactionInfo() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            color: Color(0x33000000),
            offset: Offset(0, 0),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            _buildRow('Transaction ID', widget.transactionId),
            const SizedBox(height: 20),
            _buildRow('Payment Method', widget.paymentMethod),
            const SizedBox(height: 20),
            _buildPaymentStatus(),
            const SizedBox(height: 20),
            _buildJokiStatus(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentStatus() {
    bool isPaid = widget.paymentStatus ?? false;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Payment Status', style: TextStyle(fontSize: 15)),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isPaid
                ? Colors.green
                : const Color.fromARGB(255, 255, 0, 0), // Red if not paid
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(isPaid ? 'Paid' : 'Not Paid'),
        ),
      ],
    );
  }

  Widget _buildJokiStatus() {
    String jokiStatus = widget.jokiStatus ?? 'actionNeeded';
    Color containerColor;
    String statusText;

    switch (jokiStatus) {
      case 'onProgress':
        containerColor = Colors.orange;
        statusText = 'On Progress';
        break;
      case 'finished':
        containerColor = Colors.green;
        statusText = 'Finished';
        break;
      default:
        containerColor = const Color.fromARGB(255, 255, 0, 0); // Red for not started
        statusText = 'Not Started';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Joki Status', style: TextStyle(fontSize: 15)),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(statusText),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:jokiapp/models/transaction_model.dart';

class TransactionDetailsDialog extends StatelessWidget {
  final TransactionData transaction;

  const TransactionDetailsDialog({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Job Details'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              'Transaction ID: ${transaction.transactionId}',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            SizedBox(height: 10),
            Text('Email: ${transaction.email}', style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold
              ),),
            SizedBox(height: 10),
            Text('Password: ${transaction.password}', style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold
              ),),
            SizedBox(height: 10),
            Text('Login Method: ${transaction.loginMethod}', style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold
              ),),
            SizedBox(height: 10),
            Text('Req Hero: ${transaction.reqHero}', style: TextStyle(
                fontSize: 15,
              ),),
            SizedBox(height: 10),
            Text('Notes: ${transaction.notes}', style: TextStyle(
                fontSize: 15,
              ),),
            SizedBox(height: 10),
            Text('Contact Number: ${transaction.contactNumber}', style: TextStyle(
                fontSize: 15,
              ),),
            SizedBox(height: 10),
            Text('Service: ${transaction.rank} x${transaction.quantity}', style: TextStyle(
                fontSize: 15,
              ),),
            SizedBox(height: 10),
            Text('Price: ${transaction.price}', style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold
              ),),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromRGBO(43, 52, 153, 1),
            ),
            onPressed: () {},
            child: Text('FINISH'))
      ],
    );
  }
}

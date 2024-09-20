import 'package:flutter/material.dart';

class RequestWithdraw extends StatefulWidget {
  const RequestWithdraw({super.key});

  @override
  State<RequestWithdraw> createState() => _RequestWithdrawState();
}

class _RequestWithdrawState extends State<RequestWithdraw> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Requesst Withdraw for Workers'),
      ),
    );
  }
}
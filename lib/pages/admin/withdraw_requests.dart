import 'package:flutter/material.dart';

class WithdrawRequests extends StatefulWidget {
  const WithdrawRequests({super.key});

  @override
  State<WithdrawRequests> createState() => _WithdrawRequestsState();
}

class _WithdrawRequestsState extends State<WithdrawRequests> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text('Withdraw Requests Page'),),
    );
  }
}
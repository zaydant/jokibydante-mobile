import 'package:flutter/material.dart';
import 'package:jokiapp/models/withdraw_model.dart';
import 'package:jokiapp/services/withdraw_services.dart';
import 'package:provider/provider.dart';
import 'package:jokiapp/models/user_provider.dart';
import 'package:intl/intl.dart';

class ReqDetailsDialog extends StatefulWidget {
  final WithdrawModel withdraws;
  final VoidCallback onFinishTransaction;

  const ReqDetailsDialog({
    Key? key,
    required this.withdraws,
    required this.onFinishTransaction,
  }) : super(key: key);

  @override
  _ReqDetailsDialogState createState() =>
      _ReqDetailsDialogState();
}

class _ReqDetailsDialogState extends State<ReqDetailsDialog> {
  bool _isLoading = false;

  Future<void> updatePayment() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token =
          Provider.of<UserProvider>(context, listen: false).token ?? '';
      final withdrawService = WithdrawService();

      await withdrawService.updateWithdrawStatus(
        token,
        widget.withdraws.withdrawId,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Withdraw Status updated successfully')),
      );

      // Call the callback function to refresh the job list
      widget.onFinishTransaction();
    } catch (e) {
      print('Error updating withdraw status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating withdraw status: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop(true); // Return true to indicate success
    }
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context, listen: false);

    return AlertDialog(
      title: const Text(
        'Withdraw Details',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(43, 52, 153, 1),
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildDetailRow(
                  'Withdraw ID:', widget.withdraws.withdrawId),
              _buildDetailRow('User ID:', widget.withdraws.uid, isBold: true),
              _buildDetailRow('Amount:', widget.withdraws.withdrawAmount,
                  isBold: true),
              _buildDetailRow('Method:', widget.withdraws.withdrawMethod,
                  isBold: true),
              _buildDetailRow('Acc Number:', widget.withdraws.accountNumber),
              _buildDetailRow('Acc Name:', widget.withdraws.accountName),
              _buildDetailRow('Notes:', widget.withdraws.notes),
              _buildDetailRow('Status :', widget.withdraws.status),
              _buildDetailRow('Date Created:',
                  DateFormat('yyyy-MM-dd').format(widget.withdraws.createdAt)),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color.fromRGBO(43, 52, 153, 1),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: _isLoading ? null : updatePayment,
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'Update Payment Status',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
        ),
      ],
    );
  }
}

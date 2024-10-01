import 'package:flutter/material.dart';
import 'package:jokiapp/models/support_model.dart';
import 'package:jokiapp/services/support_services.dart';
import 'package:provider/provider.dart';
import 'package:jokiapp/models/user_provider.dart';
import 'package:intl/intl.dart';

class SupportDetailsDialog extends StatefulWidget {
  final SupportData supports;
  final VoidCallback onFinishDelete;

  const SupportDetailsDialog({
    Key? key,
    required this.supports,
    required this.onFinishDelete,
  }) : super(key: key);

  @override
  _SupportDetailsDialogState createState() =>
      _SupportDetailsDialogState();
}

class _SupportDetailsDialogState extends State<SupportDetailsDialog> {
  bool _isLoading = false;

  Future<void> deleteSupport() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token =
          Provider.of<UserProvider>(context, listen: false).token ?? '';
      final supportService = SupportService();

      await supportService.deleteUser(
        token,
        widget.supports.supportId,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request deleted successfully')),
      );

      widget.onFinishDelete();
    } catch (e) {
      print('Error deleting request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting request: $e')),
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
      title: Text(
        'Support Details',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: const Color.fromRGBO(43, 52, 153, 1),
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
                  'Support ID:', widget.supports.supportId),
              _buildDetailRow('Name:', widget.supports.name, isBold: true),
              _buildDetailRow('Email:', widget.supports.email,
                  isBold: true),
              _buildDetailRow('Phone Num:', widget.supports.phoneNumber,
                  isBold: true),
              _buildDetailRow('Transaction ID:', widget.supports.transactionId),
              _buildDetailRow('Issue:', widget.supports.issue),
              _buildDetailRow('Description:', widget.supports.description),
              _buildDetailRow('Date Created:',
                  DateFormat('yyyy-MM-dd').format(widget.supports.createdAt)),
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
          onPressed: _isLoading ? null : deleteSupport,
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'Delete',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
        ),
      ],
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:jokiapp/models/transaction_model.dart';
import 'package:jokiapp/models/user_provider.dart';
import 'package:jokiapp/services/transaction_services.dart';

class TransactionDetailsDialog extends StatefulWidget {
  final TransactionData transaction;
  final VoidCallback onFinishTransaction;

  const TransactionDetailsDialog({
    Key? key,
    required this.transaction,
    required this.onFinishTransaction,
  }) : super(key: key);

  @override
  _TransactionDetailsDialogState createState() =>
      _TransactionDetailsDialogState();
}

class _TransactionDetailsDialogState extends State<TransactionDetailsDialog> {
  File? _image;
  final picker = ImagePicker();
  bool _isLoading = false;

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> finishTransaction() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Please select an image before finishing the transaction.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final token =
          Provider.of<UserProvider>(context, listen: false).token ?? '';
      final transactionService = TransactionService();

      await transactionService.finishTransaction(
        token,
        widget.transaction.transactionId,
        _image!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction finished successfully')),
      );

      // Call the callback function to refresh the job list
      widget.onFinishTransaction();

    } catch (e) {
      print('Error finishing transaction: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error finishing transaction: $e')),
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
    return AlertDialog(
      title: Text(
        'Job Details',
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
                  'Transaction ID:', widget.transaction.transactionId),
              _buildDetailRow('Email:', widget.transaction.email, isBold: true),
              _buildDetailRow('Password:', widget.transaction.password,
                  isBold: true),
              _buildDetailRow('Login Method:', widget.transaction.loginMethod,
                  isBold: true),
              _buildDetailRow('Req Hero:', widget.transaction.reqHero),
              _buildDetailRow('Notes:', widget.transaction.notes),
              _buildDetailRow(
                  'Contact Number:', widget.transaction.contactNumber),
              _buildDetailRow('Service:',
                  '${widget.transaction.rank} x${widget.transaction.quantity}'),
              _buildDetailRow('Price:', widget.transaction.price, isBold: true),
              const SizedBox(height: 20),
              const Text(
                'Image Preview',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(43, 52, 153, 1),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _image == null
                    ? const Center(child: Text('No image selected'))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _image!,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromRGBO(43, 52, 153, 1),
                ),
                onPressed: getImage,
                child: const Text('Select Image'),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color.fromRGBO(43, 52, 153, 1),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: _isLoading || _image == null ? null : finishTransaction,
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'FINISH',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
        ),
      ],
    );
  }
}

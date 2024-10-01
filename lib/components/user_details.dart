import 'package:flutter/material.dart';
import 'package:jokiapp/models/user_model.dart';
import 'package:jokiapp/models/withdraw_model.dart';
import 'package:jokiapp/services/user_services.dart';
import 'package:jokiapp/services/withdraw_services.dart';
import 'package:provider/provider.dart';
import 'package:jokiapp/models/user_provider.dart';
import 'package:intl/intl.dart';

class UserDetailsDialog extends StatefulWidget {
  final UserData users;
  final VoidCallback onFinishDelete;

  const UserDetailsDialog({
    Key? key,
    required this.users,
    required this.onFinishDelete,
  }) : super(key: key);

  @override
  _UserDetailsDialogState createState() =>
      _UserDetailsDialogState();
}

class _UserDetailsDialogState extends State<UserDetailsDialog> {
  bool _isLoading = false;

  Future<void> deleteUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token =
          Provider.of<UserProvider>(context, listen: false).token ?? '';
      final userService = UserService();

      await userService.deleteUser(
        token,
        widget.users.uid,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted successfully')),
      );

      // Call the callback function to refresh the job list
      widget.onFinishDelete();
    } catch (e) {
      print('Error deleting user: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting user: $e')),
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
        'User Details',
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
                  'User ID:', widget.users.uid),
              _buildDetailRow('Full Name:', widget.users.fullName, isBold: true),
              _buildDetailRow('Username:', widget.users.username,
                  isBold: true),
              _buildDetailRow('Email:', widget.users.email,
                  isBold: true),
              _buildDetailRow('Phone Num:', widget.users.phoneNumber),
              _buildDetailRow('Balance:', widget.users.balance),
              _buildDetailRow('Role:', widget.users.role),
              _buildDetailRow('Date Created:',
                  DateFormat('yyyy-MM-dd').format(widget.users.createdAt)),
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
          onPressed: _isLoading ? null : deleteUser,
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'Delete User',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
        ),
      ],
    );
  }
}

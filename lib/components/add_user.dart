import 'package:flutter/material.dart';
import 'package:jokiapp/components/my_textfield.dart';
import 'package:jokiapp/models/user_model.dart';
import 'package:jokiapp/services/user_services.dart';

class AddUserDialog extends StatefulWidget {
  final VoidCallback onFinish;

  const AddUserDialog({
    Key? key,
    required this.onFinish,
  }) : super(key: key);

  @override
  _AddUserDialogState createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  Future<void> createUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      UserModel user = UserModel(
        fullName: _fullNameController.text,
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        confirmPassword: _cPasswordController.text,
        phoneNumber: _phoneController.text
      );

      try {
        Map<String, dynamic> result = await UserService().createUser(user);

        if (result['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User created successfully')),
          );
          _formKey.currentState!.reset();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${result['body'] ?? ''}')),
          );
        }
        widget.onFinish();
      } catch (e) {
        print('Error creating user: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating user: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop(true); // Return true to indicate success
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Add New User',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(43, 52, 153, 1),
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                MyTextField(
                  controller: _fullNameController,
                  hintText: 'Full Name',
                  obscureText: false,
                  prefixIcon: Icons.person,
                  readOnly: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: _usernameController,
                  hintText: 'Username',
                  obscureText: false,
                  prefixIcon: Icons.supervised_user_circle,
                  readOnly: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  obscureText: false,
                  prefixIcon: Icons.email,
                  readOnly: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  prefixIcon: Icons.lock,
                  readOnly: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: _cPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                  prefixIcon: Icons.lock,
                  readOnly: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: _phoneController,
                  hintText: 'Phone Number',
                  obscureText: false,
                  prefixIcon: Icons.phone,
                  readOnly: false,
                ),
              ],
            ),
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
          onPressed: _isLoading ? null : createUser,
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'Create User',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
        ),
      ],
    );
  }
}


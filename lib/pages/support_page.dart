import 'package:flutter/material.dart';
import 'package:jokiapp/components/my_button.dart';
import 'package:jokiapp/models/support_model.dart';
import 'package:jokiapp/models/user_provider.dart';
import 'package:jokiapp/services/support_services.dart';
import 'package:provider/provider.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedProblem;
  final List<String> _problemOptions = ['Wrong Transfer', 'Bad Service', 'Wrong Account Details', 'Other'];

  // Form field controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _transactionIdController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Circular border style for form fields
  OutlineInputBorder _buildCircularBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: const BorderSide(
        color: Colors.grey,
        width: 2.0,
      ),
    );
  }

  void _saveSupport() async {
    if (_formKey.currentState!.validate()) {
      SupportModel supportItem = SupportModel(
        name: _nameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        transactionId: _transactionIdController.text,
        issue: _selectedProblem ?? '',
        description: _descriptionController.text,
      );
      
      try {
        Map<String, dynamic> result = await SupportService().saveSupportRequest(supportItem);
        
        if (result['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Support request submitted successfully')),
          );
          _formKey.currentState!.reset();
          _nameController.clear();
          _emailController.clear();
          _phoneController.clear();
          _transactionIdController.clear();
          _descriptionController.clear();
        } else {
          if (result['statusCode'] == 404) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error: Transaction Not Found')),
            );
            _transactionIdController.clear();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to submit support request. ${result['body'] ?? ''}')),
            );
          }
        }
      } catch (e) {
        print('Error in _saveSupport: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How can we help?'),
        automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: _buildCircularBorder(),
                  enabledBorder: _buildCircularBorder(),
                  focusedBorder: _buildCircularBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: _buildCircularBorder(),
                  enabledBorder: _buildCircularBorder(),
                  focusedBorder: _buildCircularBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: _buildCircularBorder(),
                  enabledBorder: _buildCircularBorder(),
                  focusedBorder: _buildCircularBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _transactionIdController,
                decoration: InputDecoration(
                  labelText: 'Transaction ID',
                  border: _buildCircularBorder(),
                  enabledBorder: _buildCircularBorder(),
                  focusedBorder: _buildCircularBorder(),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Transaction ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Issue',
                  border: _buildCircularBorder(),
                  enabledBorder: _buildCircularBorder(),
                  focusedBorder: _buildCircularBorder(),
                ),
                value: _selectedProblem,
                items: _problemOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedProblem = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a problem';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Describe Your Issue',
                  border: _buildCircularBorder(),
                  enabledBorder: _buildCircularBorder(),
                  focusedBorder: _buildCircularBorder(),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please describe your issue';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              Center(
                child: MyButton(
                  buttonText: 'Submit',
                  onTap: _saveSupport,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _transactionIdController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
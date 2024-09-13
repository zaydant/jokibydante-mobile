import 'package:flutter/material.dart';
import 'package:jokiapp/components/my_button.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedProblem;
  final List<String> _problemOptions = ['Wrong Transfer', 'Late Delivery', 'Other Issues'];

  // Circular border style for form fields
  OutlineInputBorder _buildCircularBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: const BorderSide(
        color: Colors.grey, // Customize border color
        width: 2.0,
      ),
    );
  }

  // sign user in method
  void signUserIn(BuildContext context) {
    // Navigate to the HomePage
    Navigator.pushNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How can we help?'),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Name input
              TextFormField(
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

              // Email input
              TextFormField(
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

              // Phone number input
              TextFormField(
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
              // Transaction ID input
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Transaction ID',
                  border: _buildCircularBorder(),
                  enabledBorder: _buildCircularBorder(),
                  focusedBorder: _buildCircularBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Transaction ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Problem dropdown
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

              // Issue description input
              TextFormField(
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

              // Submit button
              Center(
                child: MyButton(
                  buttonText: 'Submit',
                  onTap: () {
                    signUserIn(context);
                  }
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

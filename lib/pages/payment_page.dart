import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  final String email;
  final String password;
  final String? loginMethod;
  final String hero;
  final String notes;
  final String contact;
  final String serviceTitle;
  final int quantity;
  final double totalPrice;
  final String paymentMethod;

  const PaymentPage({
    Key? key,
    required this.email,
    required this.password,
    required this.loginMethod,
    required this.hero,
    required this.notes,
    required this.contact,
    required this.serviceTitle,
    required this.quantity,
    required this.totalPrice,
    required this.paymentMethod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Confirmation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text('Email: $email'),
            const SizedBox(height: 10),
            Text('Password: $password'),
            const SizedBox(height: 10),
            Text('Login Method: $loginMethod'),
            const SizedBox(height: 10),
            Text('Requested Hero: $hero'),
            const SizedBox(height: 10),
            Text('Notes: $notes'),
            const SizedBox(height: 10),
            Text('Contact: $contact'),
            const SizedBox(height: 10),
            Text('Service: $serviceTitle'),
            const SizedBox(height: 10),
            Text('Quantity: $quantity'),
            const SizedBox(height: 10),
            Text('Total Price: Rp ${totalPrice.toStringAsFixed(0)}'),
            const SizedBox(height: 10),
            Text('Payment Method: $paymentMethod'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Confirm and proceed with the payment process here
                // You could call an API, navigate to a success screen, etc.
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Order Confirmed'),
                      content: const Text('Your order has been placed successfully.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Confirm Payment'),
            ),
          ],
        ),
      ),
    );
  }
}

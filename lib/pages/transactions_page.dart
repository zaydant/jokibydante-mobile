import 'package:flutter/material.dart';
import 'package:jokiapp/components/my_textfield.dart';
import 'package:jokiapp/models/transaction_model.dart';
import 'package:jokiapp/pages/payment_page.dart';
import 'package:jokiapp/services/transaction_services.dart';

class TransactionPage extends StatefulWidget {
  TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  Widget build(BuildContext context) {
    final invoiceController = TextEditingController();
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 244, 244, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Text(
              'Joki By Dante',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'josefinSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                const SizedBox(height: 5),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Find your order here!',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Track your order by inputting your invoice number!',
                      style: TextStyle(
                        fontSize: 12,
                        // fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 35),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Your Transaction ID',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                MyTextField(
                  controller: invoiceController,
                  hintText: 'JDXXXXXXXXXX',
                  obscureText: false,
                  prefixIcon: Icons.search,
                  readOnly: false,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                      backgroundColor: const Color.fromRGBO(43, 52, 153, 1),
                      // backgroundColor: const Color.fromRGBO(43, 52, 153, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                    ),
                    onPressed: () async {
                      if (invoiceController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Please enter your Transaction ID'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      } else {
                        String transactionId = invoiceController.text;

                        // Show a loading indicator while fetching data
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        );

                        // Call the TransactionService to get the transaction by ID
                        TransactionModel? transaction =
                            await TransactionService()
                                .getTransactionById(transactionId);

                        // Remove the loading indicator
                        Navigator.of(context).pop();

                        if (transaction != null) {
                          // If transaction is found, navigate to PaymentPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PaymentPage(transactionId: transactionId),
                            ),
                          );
                        } else {
                          // If transaction is not found, show a SnackBar
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Transaction not found!'),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text(
                      'Find Your Order!',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:jokiapp/components/my_textfield.dart';

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Find your order here!',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Track your order by inputting your invoice number!',
                      style: TextStyle(
                        fontSize: 12,
                        // fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Your Invoice Number',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500
                      ),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

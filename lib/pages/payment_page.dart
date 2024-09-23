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
      backgroundColor: const Color.fromRGBO(244, 244, 244, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Payment Confirmation'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Thank you for ordering!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Make sure your account details are correct before paying!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 10,
                          color: Color(0x33000000),
                          offset: Offset(0, 0),
                        ),
                      ],
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(20), // Rounded corners
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Email',
                                  style: TextStyle(fontSize: 15)),
                              Text('$email',
                                  style: TextStyle(fontSize: 15)),
                            ],
                          ),
                          const SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Password',
                                  style: TextStyle(fontSize: 15)),
                              Text('$password',
                                  style: TextStyle(fontSize: 15)),
                            ],
                          ),
                          const SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Login Method',
                                  style: TextStyle(fontSize: 15)),
                              Text('$loginMethod',
                                  style: TextStyle(fontSize: 15)),
                            ],
                          ),
                          const SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Req Hero',
                                  style: TextStyle(fontSize: 15)),
                              Text('$hero',
                                  style: TextStyle(fontSize: 15)),
                            ],
                          ),
                          const SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Notes',
                                  style: TextStyle(fontSize: 15)),
                              Text('$notes',
                                  style: TextStyle(fontSize: 15)),
                            ],
                          ),
                          const SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Contact Person',
                                  style: TextStyle(fontSize: 15)),
                              Text('$contact',
                                  style: TextStyle(fontSize: 15)),
                            ],
                          ),
                          const SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Service',
                                  style: TextStyle(fontSize: 15)),
                              Text('$serviceTitle x$quantity',
                                  style: TextStyle(fontSize: 15)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Please pay through the account number below.',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 10,
                            color: Color(0x33000000),
                            offset: Offset(0, 0),
                          ),
                        ],
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(20), // Rounded corners
                      ),
                      child: Column(children: [
                        Text('Total Payment',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                        const SizedBox(
                          height: 15,
                        ),
                        Text('Rp. $totalPrice',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold))
                      ]),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 10,
                            color: Color(0x33000000),
                            offset: Offset(0, 0),
                          ),
                        ],
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(20), // Rounded corners
                      ),
                      child: Column(children: [
                        Image.asset(
                          'assets/images/bca.png',
                          width: 100,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text('6663338172',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 15,
                        ),
                        Text('ACCOUNT HOLDER NAME',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold))
                      ]),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 10,
                          color: Color(0x33000000),
                          offset: Offset(0, 0),
                        ),
                      ],
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(20), // Rounded corners
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Invoice Number',
                                  style: TextStyle(fontSize: 15)),
                              Text('JDXXXXXXXXXXXXX',
                                  style: TextStyle(fontSize: 15)),
                            ],
                          ),
                          const SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Payment Method',
                                  style: TextStyle(fontSize: 15)),
                              Text('$paymentMethod',
                                  style: TextStyle(fontSize: 15)),
                            ],
                          ),
                          const SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Payment Status',
                                  style: TextStyle(fontSize: 15)),
                              Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 255, 0, 0),
                                    borderRadius: BorderRadius.circular(
                                        10), // Rounded corners
                                  ),
                                  child: Text('Not Paid')),
                            ],
                          ),
                          const SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Joki Status',
                                  style: TextStyle(fontSize: 15)),
                              Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 255, 0, 0),
                                    borderRadius: BorderRadius.circular(
                                        10), // Rounded corners
                                  ),
                                  child: Text('Not Started')),
                            ],
                          ),
                          const SizedBox(height: 20,),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:jokiapp/components/login_categories.dart';
import 'package:jokiapp/components/my_button.dart';
import 'package:jokiapp/components/my_textfield.dart';
import 'package:jokiapp/components/payment_box.dart';
import 'package:jokiapp/components/quantity_box.dart';
import 'package:jokiapp/components/service_box.dart';
import 'package:jokiapp/models/transaction_model.dart';
import 'package:jokiapp/pages/payment_page.dart';
import 'package:jokiapp/services/transaction_services.dart';
// Assuming this is your theme file

class RankPage extends StatefulWidget {
  const RankPage({super.key});

  @override
  State<RankPage> createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> {
  bool _dialogShown = false; // Boolean flag to track if dialog is shown
  String? selectedLogin;
  final TransactionService _transactionService = TransactionService();

  //text editing controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final heroController = TextEditingController();
  final notesController = TextEditingController();
  final contactController = TextEditingController();

  // Method to show the bottom sheet with QuantityBox
  void _showBottomSheet(
      BuildContext context, String title, double currentPrice) {
    int _quantity = 3; // Move the quantity state inside the bottom sheet
    String _selectedMethod = 'Bank Transfer';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setBottomSheetState) {
            return DraggableScrollableSheet(
              expand: false,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Quantity (min 3)',
                                style: TextStyle(fontSize: 16)),
                            QuantityBox(
                              minValue: 3,
                              initialValue: _quantity,
                              onQuantityChanged: (newQuantity) {
                                setBottomSheetState(() {
                                  _quantity = newQuantity;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text(
                              'Payment Methods',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // PaymentBox for Bank Transfer
                        PaymentBox(
                          method: 'Bank Transfer',
                          price:
                              'Rp ${(currentPrice * _quantity).toStringAsFixed(0)}',
                          assetImagePath: 'assets/images/bca.png',
                          isSelected: _selectedMethod == 'Bank Transfer',
                          onTap: () {
                            setBottomSheetState(() {
                              _selectedMethod = 'Bank Transfer';
                            });
                          },
                        ),
                        const SizedBox(height: 20),

                        // PaymentBox for E-Wallet
                        PaymentBox(
                          method: 'E Wallet',
                          price:
                              'Rp ${(currentPrice * _quantity).toStringAsFixed(0)}',
                          assetImagePath: 'assets/images/gopay.png',
                          isSelected: _selectedMethod == 'E-Wallet',
                          onTap: () {
                            setBottomSheetState(() {
                              _selectedMethod = 'E-Wallet';
                            });
                          },
                        ),
                        const SizedBox(height: 20),

                        MyButton(
                          onTap: () async {
                            if (emailController.text.isEmpty ||
                                passwordController.text.isEmpty ||
                                heroController.text.isEmpty ||
                                notesController.text.isEmpty ||
                                contactController.text.isEmpty ||
                                selectedLogin == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Please fill your account details first'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              Navigator.of(context).pop();
                            } else {
                              // Create a new transaction model
                              TransactionModel newTransaction =
                                  TransactionModel(
                                email: emailController.text,
                                password: passwordController.text,
                                loginMethod: selectedLogin!,
                                reqHero: heroController.text,
                                notes: notesController.text,
                                contactNumber: contactController.text,
                                rank: title, // From the selected rank
                                price: currentPrice * _quantity,
                                quantity: _quantity,
                                paymentMethod: _selectedMethod,
                                paymentStatus: false,
                                jokiStatus: 'actionNeeded',
                              );

                              // Call the service
                              TransactionService transactionService =
                                  TransactionService();
                              TransactionModel? createdTransaction =
                                  await transactionService
                                      .createTransaction(newTransaction);

                              if (createdTransaction != null) {
                                // Navigate to PaymentPage or show confirmation with the response data
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaymentPage(
                                      email: createdTransaction.email,
                                      password: createdTransaction.password,
                                      loginMethod:
                                          createdTransaction.loginMethod,
                                      hero: createdTransaction.reqHero,
                                      notes: createdTransaction.notes,
                                      contact: createdTransaction.contactNumber,
                                      serviceTitle: createdTransaction.rank,
                                      quantity: createdTransaction.quantity,
                                      totalPrice: createdTransaction.price,
                                      paymentMethod:
                                          createdTransaction.paymentMethod,
                                      transactionId:
                                          createdTransaction.transactionId ?? '',
                                    ),
                                  ),
                                );
                              } else {
                                // Show an error message if transaction creation fails
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Failed to create transaction'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            }
                          },
                          buttonText: 'Order Now',
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void handleLoginChanged(String? loginMethod) {
    setState(() {
      selectedLogin = loginMethod;
      print(loginMethod);
    });
  }

  @override
  void initState() {
    super.initState();
    // Use post-frame callback to show the dialog once when the page is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_dialogShown) {
        _showImportantNoticeDialog(context);
        _dialogShown = true; // Set the flag to true after showing the dialog
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Container with a colored border
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
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Left Column: Image with rounded corners
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                10), // Rounded corners for the image
                            child: Image.asset(
                              'assets/images/rank.png',
                              width: 100, // Adjust width
                              height: 100, // Adjust height
                              fit: BoxFit.cover, // Ensures the image fits well
                            ),
                          ),
                        ],
                      ),

                      // Right Column: Text
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Joki Rank',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8), // Add spacing between the texts
                          Text(
                            'Fast and Secure',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Enter your Account Details',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),

                Column(
                  children: [
                    MyTextField(
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false,
                      prefixIcon: Icons.email,
                    ),
                    const SizedBox(height: 20),
                    MyTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: false, // Password field should be obscure
                      prefixIcon: Icons.lock,
                    ),
                    const SizedBox(height: 20),
                    LoginCategories(onCategoryChanged: handleLoginChanged),
                    const SizedBox(height: 20),
                    MyTextField(
                      controller: heroController,
                      hintText: 'Request Hero (Max 3)',
                      obscureText: false,
                      prefixIcon: Icons.person,
                    ),
                    const SizedBox(height: 20),
                    MyTextField(
                      controller: notesController,
                      hintText: 'Notes',
                      obscureText: false,
                      prefixIcon: Icons.note,
                    ),
                    const SizedBox(height: 20),
                    MyTextField(
                      controller: contactController,
                      hintText: 'WhatsApp Number',
                      obscureText: false,
                      prefixIcon: Icons.call,
                    ),
                  ],
                ),

                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Select your Rank',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                // Rows with ServiceBox widgets
                Row(
                  children: [
                    Expanded(
                      child: ServiceBox(
                        title: 'Master',
                        originalPrice: 5500,
                        discount: 20,
                        assetImagePath:
                            'assets/images/master.png', // Change with your image path
                        onTap: (currentPrice) {
                          _showBottomSheet(context, 'Master', currentPrice);
                        },
                      ),
                    ),
                    const SizedBox(width: 10), // Spacing between the two boxes
                    Expanded(
                      child: ServiceBox(
                        title: 'Grandmaster',
                        originalPrice: 5500,
                        discount: 20,
                        assetImagePath:
                            'assets/images/gm.png', // Change with your image path
                        onTap: (currentPrice) {
                          _showBottomSheet(
                              context, 'Grandmaster', currentPrice);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15), // Space between the rows
                Row(
                  children: [
                    Expanded(
                      child: ServiceBox(
                        title: 'Epic',
                        originalPrice: 6000,
                        discount: 20,
                        assetImagePath:
                            'assets/images/epic.png', // Change with your image path
                        onTap: (currentPrice) {
                          _showBottomSheet(context, 'Epic', currentPrice);
                        },
                      ),
                    ),
                    const SizedBox(width: 10), // Spacing between the two boxes
                    Expanded(
                      child: ServiceBox(
                        title: 'Legend',
                        originalPrice: 7000,
                        discount: 20,
                        assetImagePath:
                            'assets/images/legend.png', // Change with your image path
                        onTap: (currentPrice) {
                          _showBottomSheet(context, 'Legend', currentPrice);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15), // Space between the rows
                Row(
                  children: [
                    Expanded(
                      child: ServiceBox(
                        title: 'Mythic',
                        originalPrice: 16000,
                        discount: 20,
                        assetImagePath:
                            'assets/images/mythic.png', // Change with your image path
                        onTap: (currentPrice) {
                          _showBottomSheet(context, 'Mythic', currentPrice);
                        },
                      ),
                    ),
                    const SizedBox(width: 10), // Spacing between the two boxes
                    Expanded(
                      child: ServiceBox(
                        title: 'Grading',
                        originalPrice: 18000,
                        discount: 20,
                        assetImagePath:
                            'assets/images/mythic.png', // Change with your image path
                        onTap: (currentPrice) {
                          _showBottomSheet(context, 'Grading', currentPrice);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15), // Space between the rows
                Row(
                  children: [
                    Expanded(
                      child: ServiceBox(
                        title: 'Honor',
                        originalPrice: 18000,
                        discount: 20,
                        assetImagePath:
                            'assets/images/honor.png', // Change with your image path
                        onTap: (currentPrice) {
                          _showBottomSheet(context, 'Honor', currentPrice);
                        },
                      ),
                    ),
                    const SizedBox(width: 10), // Spacing between the two boxes
                    Expanded(
                      child: ServiceBox(
                        title: 'Glory',
                        originalPrice: 24000,
                        discount: 20,
                        assetImagePath:
                            'assets/images/glory.png', // Change with your image path
                        onTap: (currentPrice) {
                          _showBottomSheet(context, 'Glory', currentPrice);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15), // Space between the rows
                ServiceBox(
                  title: 'Immortal',
                  originalPrice: 28000,
                  discount: 20,
                  assetImagePath:
                      'assets/images/immo.png', // Change with your image path
                  onTap: (currentPrice) {
                    _showBottomSheet(context, 'Immortal', currentPrice);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showImportantNoticeDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20), // Rounded corners for dialog
          ),
          title: const Center(
            child: Text(
              'IMPORTANT NOTICE!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Orders are checked everyday from 08.00 - 21.00.'),
              Text(
                  'Orders made after the above time will be processed the next day.'),
              SizedBox(height: 10),
              Center(
                child: Text(
                  'TERMS & CONDITIONS',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                  '1. Make sure your data is correct, including capitalization of letters.'),
              Text('2. Orders are processed according to the queue.'),
              Text(
                  '3. Make sure the verify option is turned off in the account settings.'),
              Text(
                  '4. If the account is logged in 3x while the boosting process is ongoing, then it will be considered done without refunds.'),
              SizedBox(height: 10),
              Text(
                  'If you have any trouble and/or questions, please contact admin through the support page.'),
              Text('Thank you!'),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

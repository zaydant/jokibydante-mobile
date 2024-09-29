import 'package:flutter/material.dart';
import 'package:jokiapp/components/my_button.dart';
import 'package:jokiapp/components/my_textfield.dart';
import 'package:jokiapp/components/request_row.dart';
import 'package:jokiapp/components/withdraw_categories.dart';
import 'package:jokiapp/models/user_provider.dart';
import 'package:jokiapp/models/withdraw_model.dart';
import 'package:jokiapp/services/withdraw_services.dart'; // Import the WithdrawService
import 'package:jokiapp/services/user_services.dart';
import 'package:provider/provider.dart';

class RequestWithdraw extends StatefulWidget {
  RequestWithdraw({super.key});

  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  @override
  State<RequestWithdraw> createState() => _RequestWithdrawState();
}

class _RequestWithdrawState extends State<RequestWithdraw> {
  String? selectedMethod;
  String balance = 'Loading...'; // Add a state variable for the balance
  bool isLoading = false; // Add a loading state
  late Future<List<WithdrawModel>> _futureWithdraws;
  final WithdrawService _withdrawService = WithdrawService();

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    // Fetch user details and display balance
    getUserBalance();
    _futureWithdraws = _withdrawService.getRequestByOwner(userProvider.token!, userProvider.uid!);
  }

  Future<void> getUserBalance() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final uid = userProvider.uid; // Access the user's uid from the provider
    final token = userProvider.token;

    try {
      UserService userService = UserService();
      final user = await userService.getUserById(uid!, token!);
      print(user);
      if (user != null) {
        setState(() {
          balance = user.balance; // Assuming 'balance' is a property in UserData
        });
      } else {
        setState(() {
          balance = 'No balance';
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        balance = 'Error fetching balance';
      });
    }
  }

  void handleMethodChanged(String? withdrawMethod) {
    setState(() {
      selectedMethod = withdrawMethod;
    });
  }

  Future<void> submitRequest() async {
    // Check if all required fields are filled
    if (widget.nameController.text.isEmpty ||
        widget.numberController.text.isEmpty ||
        widget.amountController.text.isEmpty ||
        selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill the form')),
      );
      return;
    }

    // Show loading indicator
    setState(() {
      isLoading = true;
    });

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.token;

    // Prepare data for submission
    double amount = double.parse(widget.amountController.text);
    String method = selectedMethod!;
    String number = widget.numberController.text;
    String name = widget.nameController.text;
    String? note = widget.noteController.text.isNotEmpty ? widget.noteController.text : null;

    WithdrawService withdrawService = WithdrawService();

    try {
      // Make the withdraw request
      final response = await withdrawService.submitRequest(token!, amount, method, number, name, note);

      if (response['success']) {
        // Success, show snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Withdraw request made')),
        );
      } else {
        // Failure, show snackbar with error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response['statusCode']}')),
        );
      }
    } catch (e) {
      // Show an error snackbar if something went wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      // Hide loading indicator
      setState(() {
        isLoading = false;
      });
      widget.nameController.clear();
        widget.numberController.clear();
        widget.amountController.clear();
        widget.noteController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Withdraw Menu',
                style: TextStyle(
                  fontFamily: 'JosefinSans',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Please enter the amount and account details.',
                style: TextStyle(
                  fontFamily: 'JosefinSans',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available Balance:',
                    style: TextStyle(
                      fontFamily: 'JosefinSans',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    balance, // Display the balance here
                    style: const TextStyle(
                      fontFamily: 'JosefinSans',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              WithdrawCategories(onCategoryChanged: handleMethodChanged),
              const SizedBox(
                height: 20,
              ),
              MyTextField(
                controller: widget.numberController,
                hintText: 'Account Number',
                obscureText: false,
                prefixIcon: Icons.account_balance,
                readOnly: false,
              ),
              const SizedBox(
                height: 20,
              ),
              MyTextField(
                controller: widget.nameController,
                hintText: 'Account Holder Name',
                obscureText: false,
                prefixIcon: Icons.person,
                readOnly: false,
              ),
              const SizedBox(
                height: 20,
              ),
              MyTextField(
                controller: widget.amountController,
                hintText: 'Amount',
                obscureText: false,
                prefixIcon: Icons.money,
                readOnly: false,
              ),
              const SizedBox(
                height: 20,
              ),
              MyTextField(
                controller: widget.noteController,
                hintText: 'Notes',
                obscureText: false,
                prefixIcon: Icons.note,
                readOnly: false,
              ),
              const SizedBox(
                height: 20,
              ),
              // If loading, show CircularProgressIndicator
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : MyButton(onTap: submitRequest, buttonText: 'Submit Request'),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<WithdrawModel>>(
                  future: _futureWithdraws,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No requests found.'));
                    } else {
                      final filteredWithdraws = snapshot.data!;
                
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredWithdraws.length,
                        itemBuilder: (context, index) {
                          final withdraws = filteredWithdraws[index];
                
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                            child: ReqRow(
                              withdrawData: withdraws,
                              onCheck: () => {
                                print(withdraws.withdrawId)
                              },
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

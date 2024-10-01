import 'package:flutter/material.dart';
import 'package:jokiapp/components/my_button.dart';
import 'package:jokiapp/components/my_textfield.dart';
import 'package:jokiapp/models/user_model.dart';
import 'package:jokiapp/models/user_provider.dart';
import 'package:jokiapp/pages/home_screen.dart';
import 'package:jokiapp/services/user_services.dart';
import 'package:provider/provider.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  UserService _userService = UserService();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  Future<void> getUserDetails() async {
    final uid = Provider.of<UserProvider>(context, listen: false).uid ?? '';
    final token = Provider.of<UserProvider>(context, listen: false).token ?? '';
    UserData? user = await _userService.getUserById(uid, token);
    setState(() {
      _phoneController.text = user?.phoneNumber ?? '';
    });
  }

  Future<void> updateUser() async {
    final token = Provider.of<UserProvider>(context, listen: false).token ?? '';

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _userService.updateUser(
          token,
          _passwordController.text,
          _newPasswordController.text,
          _phoneController.text,
        );

        scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(content: Text('User updated successfully')),
        );

        await getUserDetails();
      } catch (e) {
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(content: Text('Error updating user: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 244, 244, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: const Padding(
          padding: EdgeInsets.only(left: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () async {
              if (Provider.of<UserProvider>(context, listen: false).token !=
                      null &&
                  Provider.of<UserProvider>(context, listen: false)
                      .token!
                      .isNotEmpty) {
                const snackBar = SnackBar(content: Text("Logout Successful"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                final userProvider =
                    Provider.of<UserProvider>(context, listen: false);
                userProvider.logout();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              } else {
                const snackBar =
                    SnackBar(content: Text("No active session found."));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Welcome, ',
                      style: TextStyle(
                        fontFamily: 'josefinSans',
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      userProvider.username ?? '',
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(43, 52, 153, 1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/images/profile.png'),
                  backgroundColor: Colors.transparent,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  userProvider.role != null && userProvider.role!.isNotEmpty
                      ? '${userProvider.role![0].toUpperCase()}${userProvider.role!.substring(1)}'
                      : '',
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'ID: ${userProvider.uid ?? ''}',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text('Phone Number'),
                  ],
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: _phoneController,
                  hintText: 'Phone Number',
                  obscureText: false,
                  prefixIcon: Icons.phone,
                  readOnly: false,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text('Old Password'),
                  ],
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: _passwordController,
                  hintText: 'Old Password',
                  obscureText: true,
                  prefixIcon: Icons.lock_outline,
                  readOnly: false,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text('New Password'),
                  ],
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: _newPasswordController,
                  hintText: 'New Password',
                  obscureText: true,
                  prefixIcon: Icons.lock,
                  readOnly: false,
                ),
                const SizedBox(height: 10),
                MyButton(
                  onTap: updateUser,
                  buttonText: 'Save',
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

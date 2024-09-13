import 'package:jokiapp/components/my_button.dart';
import 'package:jokiapp/components/my_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  //text editing controller
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final vpasswordController = TextEditingController();

  // sign user in method
  void signUserIn(BuildContext context) {
    // Navigate to the HomePage
    Navigator.pushNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 244, 244, 1),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            controller: ScrollController(),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset(
                'assets/images/logo_circle.png',
                width: 180,
              ),
              const SizedBox(height: 25),
              // new here?
              const Text(
                'Welcome!',
                style: TextStyle(
                  fontFamily: 'josefinSans',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),

              //let's get you set up
              const Text(
                'Please login with your account',
                style: TextStyle(
                  fontFamily: 'JosefinSans',
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(61, 61, 61, 1),
                ),
              ),
              const SizedBox(height: 25),

              //email text field
              MyTextField(
                controller: emailController,
                hintText: 'email',
                obscureText: false,
                prefixIcon: Icons.alternate_email,
              ),
              const SizedBox(height: 25),
              MyTextField(
                controller: passwordController,
                hintText: 'password',
                obscureText: true,
                prefixIcon: Icons.lock,
              ),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.only(
                  right: 29.0,
                ),
                // child: Align(
                //   alignment: Alignment.centerRight,
                //   child: Text(
                //     'Forgot Password?',
                //     style: TextStyle(
                //       fontFamily: 'JosefinSans',
                //       fontSize: 16,
                //       color: Colors.black,
                //     ),
                //   ),
                // ),
              ),
              const SizedBox(height: 30),

              // sign up button
              MyButton(
                buttonText: 'Login',
                onTap: () {
                  // Call the signUserIn method and pass the context
                  signUserIn(context);
                },
              ),
              const SizedBox(height: 15),
            ]),
          ),
        ),
      ),
    );
  }
}
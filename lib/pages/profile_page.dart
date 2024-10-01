import 'package:flutter/material.dart';
import 'package:jokiapp/models/user_provider.dart';
import 'package:jokiapp/pages/home_screen.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
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
                  radius: 60, // Adjust the size of the circle
                  backgroundImage: AssetImage('assets/images/profile.png'),
                  backgroundColor: Colors
                      .transparent, // Make it transparent if no image is available
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromRGBO(43, 52, 153, 1),
                  ),
                  onPressed: () async {
                    // Check if the token is available
                    if (Provider.of<UserProvider>(context, listen: false)
                                .token !=
                            null &&
                        Provider.of<UserProvider>(context, listen: false)
                            .token!
                            .isNotEmpty) {
                      // Show a snackbar message
                      const snackBar =
                          SnackBar(content: Text("Logout Successful"));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);

                      // Get the UserProvider instance
                      final userProvider =
                          Provider.of<UserProvider>(context, listen: false);

                      // Clear the user's data in the provider
                      userProvider.logout();

                      // navigate to the login screen or show a message
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    } else {
                      // show a message if the token is not available
                      const snackBar =
                          SnackBar(content: Text("No active session found."));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: const Text('LOG OUT'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:jokiapp/models/user_provider.dart';  // Import your UserProvider class
import 'package:jokiapp/pages/admin/admin_screen.dart';
import 'package:jokiapp/pages/home_screen.dart';
import 'package:jokiapp/pages/worker/worker_screen.dart';
import 'package:provider/provider.dart';  // Import Provider package

Future<void> main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Create UserProvider instance and load user data
  final userProvider = UserProvider();
  await userProvider.loadUserData();

  // Run the app
  runApp(
    ChangeNotifierProvider(
      create: (_) => userProvider,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return MaterialApp(
      title: 'Joki By Dante',
      theme: ThemeData(
        fontFamily: 'josefinSans',
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: userProvider.loadUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Check if the user is logged in
            if (userProvider.role! == 'worker') {
              return const WorkerScreen();
            } else if (userProvider.role! == 'admin') {
              return const AdminScreen();
            } else {
              return const HomeScreen();
            }
          } else {
            // Show a loading screen while waiting for the future to complete
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}

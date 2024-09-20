import 'package:flutter/material.dart';
import 'package:jokiapp/models/user_provider.dart';  // Import your UserProvider class
import 'package:jokiapp/pages/home_screen.dart';
import 'package:provider/provider.dart';  // Import Provider package

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),  // Add UserProvider here
      ],
      child: MaterialApp(
        title: 'Joki By Dante',
        theme: ThemeData(
          fontFamily: 'josefinSans',
        ),
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}

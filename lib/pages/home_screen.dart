import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:jokiapp/pages/home_page.dart';
import 'package:jokiapp/pages/login_page.dart';
import 'package:jokiapp/pages/support_page.dart';
import 'package:jokiapp/pages/transactions_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int index = 1;

  @override
  Widget build(BuildContext context) {
    final screens = [
      TransactionPage(),
      const HomePage(),
      const SupportPage(),
      LoginPage(),
    ];

    final items = <Widget>[
      const Icon(
        Icons.article,
        color: Colors.white,
      ),
      const Icon(
        Icons.home,
        color: Colors.white,
      ),
      const Icon(
        Icons.support_agent,
        color: Colors.white,
      ),
      const Icon(
        Icons.account_circle,
        color: Colors.white,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 244, 244, 1),
      body: screens[index],
      bottomNavigationBar: CurvedNavigationBar(
        key: navigationKey,
        backgroundColor: const Color.fromRGBO(244, 244, 244, 1),
        color: const Color.fromRGBO(43, 52, 153, 1),
        animationDuration: const Duration(milliseconds: 300),
        index: index,
        items: items,
        onTap: (index) {
          setState(() {
            this.index = index;
          });
        },
      ),
    );
  }
}
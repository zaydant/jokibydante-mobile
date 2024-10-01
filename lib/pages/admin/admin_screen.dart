import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:jokiapp/models/user_provider.dart';
import 'package:jokiapp/pages/admin/support_list.dart';
import 'package:jokiapp/pages/admin/user_list.dart';
import 'package:jokiapp/pages/admin/withdraw_requests.dart';
import 'package:jokiapp/pages/profile_page.dart';
import 'package:jokiapp/pages/transaction_list.dart';
class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {

  // void fetchUserName() {
    
  // }

  @override
  void initState() {
    super.initState();
    print(UserProvider().role);
  }

  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int index = 2;

  @override
  Widget build(BuildContext context) {
    final screens = [
      TransactionList(),
      WithdrawRequestList(),
      UserList(),
      SupportList(),
      ProfilePage(),
    ];

    final items = <Widget>[
      const Icon(
        Icons.article,
        color: Colors.white,
      ),
      const Icon(
        Icons.monetization_on,
        color: Colors.white,
      ),
      const Icon(
        Icons.person,
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
        backgroundColor: Color.fromRGBO(244, 244, 244, 1),
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
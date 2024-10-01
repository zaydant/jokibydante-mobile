import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:jokiapp/pages/profile_page.dart';
import 'package:jokiapp/pages/transaction_list.dart';
import 'package:jokiapp/pages/worker/job_list.dart';
import 'package:jokiapp/pages/worker/withdraw_request.dart';

class WorkerScreen extends StatefulWidget {
  const WorkerScreen({super.key});

  @override
  State<WorkerScreen> createState() => _WorkerScreenState();
}

class _WorkerScreenState extends State<WorkerScreen> {

  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int index = 1;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const JobList(),
      const TransactionList(),
      RequestWithdraw(),
      const ProfilePage(),
    ];

    final items = <Widget>[
      const Icon(
        Icons.cases_rounded,
        color: Colors.white,
      ),
      const Icon(
        Icons.article,
        color: Colors.white,
      ),
      const Icon(
        Icons.monetization_on,
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
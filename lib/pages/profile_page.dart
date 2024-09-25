import 'package:flutter/material.dart';
import 'package:jokiapp/models/user_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('User ID: ${userProvider.uid ?? "No user ID"}'),
            Text('Username: ${userProvider.username ?? "No username"}'),
            Text('Token: ${userProvider.token ?? "No token"}'),
            Text('Role: ${userProvider.role ?? "No role"}'),
          ],
        ),
      ),
    );
  }
}
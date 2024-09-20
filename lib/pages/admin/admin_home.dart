import 'package:flutter/material.dart';

class AdminHome extends StatefulWidget {
  final String name;
  final String uid;
  final String token;

  const AdminHome({
    super.key,
    required this.name,
    required this.uid,
    required this.token,
  });

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${widget.name}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('UID: ${widget.uid}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Token: ${widget.token}', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

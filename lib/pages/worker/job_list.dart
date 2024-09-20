import 'package:flutter/material.dart';

class JobList extends StatefulWidget {

  const JobList({
    super.key,
  });

  @override
  _JobListState createState() => _JobListState();
}

class _JobListState extends State<JobList> {
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
          children: [Text('Job List Page')
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../model/job.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late List<Job> _jobs;

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    final String data = await rootBundle.loadString('assets/jobs.json');
    final List<dynamic> jsonList = jsonDecode(data);
    setState(() {
      _jobs = jsonList.map((e) => Job.fromJson(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_jobs.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
        itemCount: _jobs.length,
        itemBuilder: (context, index) {
          final job = _jobs[index];
          return ListTile(
            title: Text(job.title),
            subtitle: Text(job.description),
            onTap: () {
              // Handle item tap
              // Navigate to JobDetailScreen when ListTile is tapped
              /*Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => JobDetailScreen(
                  title: job.title,
                  description: job.description),
              ),
              );*/
            },
          );
        },
      );
    }
  }
}
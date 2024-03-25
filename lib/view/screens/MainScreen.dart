import 'package:flutter/material.dart';
import 'package:acting_in_the_uae/view/screens/HomeTab.dart';
import 'package:acting_in_the_uae/view/screens/JobOptionscreen.dart';
import 'package:acting_in_the_uae/view/screens/profilescreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tab Navigation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Acting in the UAE'),
        ),
        body: const TabBarView(
          children: [
            HomeTab(),
            JobOptionsScreen(),
            ProfileScreen(),
          ],
        ),
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(icon: Icon(Icons.home), text: 'Home'),
            Tab(icon: Icon(Icons.work), text: 'Jobs'),
            Tab(icon: Icon(Icons.person), text: 'Profile'),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // appBar: AppBar(
      //   title: Text('Services'),
      // ),
      body: Center(
        child: Text(
          'Services Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
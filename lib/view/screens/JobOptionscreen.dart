import 'package:flutter/material.dart';
import 'OptionCard.dart';
import 'PostCastingsScreen.dart'; // Import the OptionCard widget

class JobOptionsScreen extends StatelessWidget {
  const JobOptionsScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Options'),
      // ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          OptionCard(
            title: 'View Castings',
            onTap: () {
              print('View Castings tapped');
            },
          ),
          OptionCard(
            title: 'Post Castings',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostCastingsScreen()),
              );
            },
          ),
          OptionCard(
            title: 'View Crew Jobs',
            onTap: () {
              print('View Crew Jobs tapped');
            },
          ),
          OptionCard(
            title: 'Post Crew Jobs',
            onTap: () {
              print('Post Crew Jobs tapped');
            },
          ),
        ],
      ),
    );
  }
}

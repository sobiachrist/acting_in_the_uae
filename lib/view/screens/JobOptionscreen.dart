import 'package:flutter/material.dart';
import 'OptionCard.dart';
import 'postcastingsscreen.dart'; // Import the OptionCard widget

class JobOptionsScreen extends StatelessWidget {
  const JobOptionsScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
        'What would you like to do?',
        style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black,
    ),
    ),
    elevation: 0, // Remove elevation
    backgroundColor: Colors.transparent, // Make app bar transparent
    toolbarHeight: 60, // Adjust the height of the app bar
    titleSpacing: 20, // Add spacing around the title
    toolbarOpacity: 1, // Make the app bar fully opaque
          ),
      body: Padding(
        padding: const EdgeInsets.only(top: 60), // Add top margin
        child: Center(
          // Wrap the GridView with Center
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 0, // Set cross axis spacing to zero
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 4), // Add top padding only
                child: OptionCard(
                  title: 'Cast Jobs',
                  onTap: () {
                    print('View Castings tapped');
                  },
                  image: const AssetImage('assets/images/casting.png'),
                ),
              )
,
              Padding(
                padding: const EdgeInsets.only(left: 4,right: 12), // Add top padding only
                child: OptionCard(
                  title: 'Hire Cast',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PostCastingsScreen(key: UniqueKey())),
                    );
                  },
                  image: const AssetImage('assets/images/hire.png'),

                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 12,right: 4), // Add top padding only
                child: OptionCard(
                  title: 'Crew Jobs',
                  onTap: () {
                    print('View Castings tapped');
                  },
                  image: const AssetImage('assets/images/crew.png'),

                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4,right: 12), // Add top padding only
                child: OptionCard(
                  title: 'Hire Crew',
                  onTap: () {

                  },
                  image: const AssetImage('assets/images/hirecrew.png'),

                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

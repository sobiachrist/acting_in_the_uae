import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const OptionCard({Key? key, required this.title, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.4; // Adjust the percentage as needed
    final cardHeight = cardWidth * 0.5; // Adjust the aspect ratio as needed

    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: InkWell(
        onTap: onTap,
        child: Card(
          margin: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final AssetImage? image; // Change type to AssetImage

  const OptionCard({
    Key? key,
    required this.title,
    required this.onTap,
    this.image, // Change type to AssetImage
  }) : super(key: key);

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (image != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0), // Add margin below the image
                  child: Image(
                    image: image!,
                    width: 60, // Adjust image width as needed
                    height: 60, // Adjust image height as needed
                    fit: BoxFit.cover, // Adjust fit as needed
                  ),
                ),
              Text(
                title,
                style: const TextStyle(fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

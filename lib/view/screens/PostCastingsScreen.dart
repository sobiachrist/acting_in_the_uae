import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../model/CastingDetails.dart';
import '../../model/Product.dart';
import 'package:flutter/material.dart';

class ResponseData {
  final CastingDetails castingDetails;

  ResponseData({required this.castingDetails});

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    final castingDetails = CastingDetails.fromJson(json);
    return ResponseData(castingDetails: castingDetails);
  }
}

class PostCastingsScreen extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController();

  PostCastingsScreen({super.key});

  Future<void> fetchCastingDetails() async {
    final message = Uri.encodeComponent(_textEditingController.text);
    final response = await http.get(Uri.parse('http://209.97.163.97:81/api/Message/UniformMessage?message=$message'));
    if (response.statusCode == 200) {
      // print('body: ${response.body}');

      try {
        final jsonData = jsonDecode(response.body);
        final dataString = jsonData['data']; // Extract the JSON string from the "data" field

        // Check if dataString is not null before parsing it
        print('datastring: $dataString');

        if (dataString != null) {
        parseJson(dataString);
        } else {
          // Handle case where "data" field is null
          print('Failed to parse JSON: "data" field is null');
        }
      } catch (e) {
        // Handle parsing error
        print('Failed to parse JSON: $e');
      }
    } else {
      // Handle error if needed
      print('Failed to fetch casting details');
    }
  }

  void parseJson(String res) {
    // Trim unwanted characters from the beginning of the JSON string
    final startIndex = res.indexOf('{'); // Find the index of the first '{' character
    final trimmedRes = startIndex >= 0 ? res.substring(startIndex) : res; // Trim the string from the first '{' character onward

    try {
      Map<String, dynamic> decodedRes = jsonDecode(trimmedRes);
      var candidates = decodedRes['candidates'];
      if (candidates != null && candidates.isNotEmpty) {
        var content = candidates[0]['content'];
        if (content != null && content['parts'].isNotEmpty) {
          var text = content['parts'][0]['text'];
          var parsedJson = jsonDecode(text);

          // Create an instance of CastingDetails from parsedJson
          CastingDetails castingDetails = CastingDetails.fromJson(parsedJson);

          // Now you can access the individual fields of castingDetails
          print('Header: ${castingDetails.header}');
          print('Date: ${castingDetails.date}');
          print('Phone Number: ${castingDetails.phoneNumber}');
          print('Country: ${castingDetails.country}');
          print('Contact Details: ${castingDetails.contactDetails}');
          print('Description: ${castingDetails.description}');
        }
      }
    } catch (e) {
      // Handle parsing error
      print('Failed to parse JSON: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Castings'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 12 * 24.0, // Minimum height for 12 lines
                  maxHeight: 12 * 24.0, // Maximum height for 12 lines
                ),
                child: TextFormField(
                  controller: _textEditingController,
                  maxLines: null, // Allows for multiple lines of text
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: 'Enter casting details...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10), // Margin above the button
          ElevatedButton(
            onPressed: fetchCastingDetails,
            child: const Text('Post Casting'),
          ),
          SizedBox(height: 10), // Margin below the button
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();

  }
}


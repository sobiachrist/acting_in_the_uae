import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../model/CastingDetails.dart';
import 'jobdetailscreen.dart';

class PostCastingsScreen extends StatefulWidget {
  PostCastingsScreen({required Key key}) : super(key: key);

  @override
  _PostCastingsScreenState createState() => _PostCastingsScreenState();
}

class _PostCastingsScreenState extends State<PostCastingsScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Job'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _textEditingController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Enter your job details\nor simply paste your content', // Updated hint message to display in two lines
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                      });
                      fetchCastingDetails(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text('Post Job'),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      'AI is processing your message. Please wait.',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> fetchCastingDetails(BuildContext context) async {
    final message = Uri.encodeComponent(_textEditingController.text);
    final response = await http.get(Uri.parse('http://209.97.163.97:81/api/Message/UniformMessage?message=$message'));
    if (response.statusCode == 200) {
      try {
        final jsonData = jsonDecode(response.body);
        final dataString = jsonData['data'];
        if (dataString != null) {
          CastingDetails castingDetails = parseJson(dataString);
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => JobDetailScreen(castingDetails: castingDetails)));
        } else {
          print('Failed to parse JSON: "data" field is null');
        }
      } catch (e) {
        print('Failed to parse JSON: $e');
      }
    } else {
      print('Failed to fetch casting details');
    }
    setState(() {
      _isLoading = false;
    });
  }

  CastingDetails parseJson(String res) {
    final startIndex = res.indexOf('{');
    final trimmedRes = startIndex >= 0 ? res.substring(startIndex) : res;

    try {
      Map<String, dynamic> decodedRes = jsonDecode(trimmedRes);
      var candidates = decodedRes['candidates'];
      if (candidates != null && candidates.isNotEmpty) {
        var content = candidates[0]['content'];
        if (content != null && content['parts'].isNotEmpty) {
          var text = content['parts'][0]['text'];
          var parsedJson = jsonDecode(text);
          return CastingDetails.fromJson(parsedJson);
        }
      }
    } catch (e) {
      print('Failed to parse JSON: $e');
    }
    return CastingDetails();
  }
}

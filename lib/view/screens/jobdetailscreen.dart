import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../model/CastingDetails.dart';

class JobDetailScreen extends StatefulWidget {
  final CastingDetails castingDetails;

  const JobDetailScreen({Key? key, required this.castingDetails})
      : super(key: key);

  @override
  _JobDetailScreenState createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _noteController;
  late TextEditingController _contentController;
  late TextEditingController _dateController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _countryController;
  late TextEditingController _contactDetailsController;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.castingDetails.header);
    _noteController = TextEditingController(text: "Please stay safe...");
    _contentController =
        TextEditingController(text: widget.castingDetails.description);
    _dateController = TextEditingController(text: widget.castingDetails.date);
    _phoneNumberController =
        TextEditingController(text: widget.castingDetails.phoneNumber);
    _countryController =
        TextEditingController(text: widget.castingDetails.country);
    _contactDetailsController =
        TextEditingController(text: widget.castingDetails.contactDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Acting in the UAE",
          style: TextStyle(fontSize: 18),
        ),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildEditableField("Title", _titleController),
                const SizedBox(height: 20),
                _buildEditableField("Note", _noteController),
                const SizedBox(height: 20),
                _buildEditableField("Casting content", _contentController,
                    maxLines: null),
                const SizedBox(height: 20),
                _buildEditableField("Date", _dateController),
                const SizedBox(height: 20),
                _buildEditableField("Phone Number", _phoneNumberController),
                const SizedBox(height: 20),
                _buildEditableField("Country", _countryController),
                const SizedBox(height: 20),
                _buildEditableField(
                    "Contact Details", _contactDetailsController),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _submitData();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                        padding: const EdgeInsets.symmetric(horizontal: 26),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text('Submit'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller,
      {int? maxLines}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _submitData() async {
    final url =
        Uri.parse('http://209.97.163.97:81/api/Message/SaveUniformMessage');
    final requestBody = {
      "title": _titleController.text,
      "endDate": "",
      "country": _countryController.text,
      "jobType": "Cast Jobs",
      "contents": _contentController.text,
      "staticData": "Please stay safe...",
      "phoneNumber": _phoneNumberController.text,
      "contactDetails": _contactDetailsController.text
    };

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      final responseData = jsonDecode(response.body);

      if (responseData['statusCode'] == 200) {
        // redirect to detail page
        print("Data Value: ${responseData['data']}");
      } else {
        throw Exception('Failed to submit data');
      }
    } catch (error) {
      print('Error submitting data: $error');
    }
  }
}

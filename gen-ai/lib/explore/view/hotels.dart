import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Hotels extends StatefulWidget {
  final String location; // Add location as a parameter

  const Hotels({Key? key, required this.location}) : super(key: key);

  @override
  _HotelsState createState() => _HotelsState();
}

class _HotelsState extends State<Hotels> {
  String destinationValue = '';
  bool isLoading = false;
  String apiResponse = ''; // To store the API response
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _locationController.text = widget.location; // Set the location in the controller
    makeApiCall(widget.location); // Call the API as soon as the page is displayed
  }

  Future<void> makeApiCall(String from) async {
    setState(() {
      isLoading = true;
    });

    const String apiUrl = "https://openrouter.ai/api/v1/chat/completions";
    const String openRouterApiKey =
        "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";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $openRouterApiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "mistralai/mixtral-8x7b-instruct",
          "messages": [
            {"role": "user", "content": "Give a list of good hotels to stay in ${widget.location}"}
          ]
        }),
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        final jsonResponse = jsonDecode(response.body);

        // Extract and store the content from the choices array
        final content = jsonResponse['choices'][0]['message']['content'];

        setState(() {
          apiResponse = content;
        });

      } else {
        // Handle errors
        print("Error: ${response.statusCode} - ${response.body}");
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AppBar(
              title: Text('${widget.location}'),
            ),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                apiResponse,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

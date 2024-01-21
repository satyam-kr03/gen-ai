import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Translation extends StatefulWidget {
  final String location; // Add location as a parameter

  const Translation({Key? key, required this.location}) : super(key: key);

  @override
  _TranslationState createState() => _TranslationState();
}

class _TranslationState extends State<Translation> {
  String destinationValue = '';
  bool isLoading = false;
  String apiResponse = ''; // To store the API response
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
            {"role": "user", "content": 'translate {$_locationController.text} to the language they speak in ${widget.location}'} // Use the text from the controller
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
      body: Column(
        children: <Widget>[
          AppBar(
            title: Text('${widget.location}'),
          ),
          TextField(
            controller: _locationController,
            decoration: InputDecoration(labelText: 'Translate', hintText: 'Enter English text to translate'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              makeApiCall(_locationController.text);
            },
            child: Text('Translate'),
          ),
          const SizedBox(height: 20),
          isLoading
              ? CircularProgressIndicator()
              : Text(
            apiResponse,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

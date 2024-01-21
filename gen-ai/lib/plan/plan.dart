import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlanPage extends StatefulWidget {
  const PlanPage({Key? key}) : super(key: key);

  @override
  _PlanPageState createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  // Variables to store entered values
  String fromValue = '';
  String destinationValue = '';
  bool isLoading = false;

  Future<void> makeApiCall(String from, String dest) async {
    setState(() {
      isLoading = true;
    });

    const String apiUrl = "https://openrouter.ai/api/v1/chat/completions";
    const String openRouterApiKey = "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";

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
            {"role": "user", "content": "Give a detailed travel itinerary from $from to $dest"}
          ]
        }),
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        final jsonResponse = jsonDecode(response.body);

        // Extract and print the content from the choices array
        final content = jsonResponse['choices'][0]['message']['content'];

        // Navigate to a new page with the content
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(content: content),
          ),
        );
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
            title: const Text('Plan Your Next Trip'),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Text field for "From"
                TextField(
                  onChanged: (value) {
                    setState(() {
                      fromValue = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'From',
                    hintText: 'Enter your starting location',
                  ),
                ),
                const SizedBox(height: 16.0), // Add some spacing between text fields
                // Text field for "Destination"
                TextField(
                  onChanged: (value) {
                    setState(() {
                      destinationValue = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Destination',
                    hintText: 'Enter your destination',
                  ),
                ),
                const SizedBox(height: 16.0), // Add some spacing
                // Submit button
                ElevatedButton(
                  onPressed: () {
                    // Call the API function here
                    makeApiCall(fromValue, destinationValue);
                  },
                  child: isLoading
                      ? CircularProgressIndicator() // Show loading indicator
                      : const Text('Submit'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final String content;

  ResultPage({required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Travel Itinerary'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            content,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}

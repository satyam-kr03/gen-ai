import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ApiContentDisplay extends StatefulWidget {
  @override
  _ApiContentDisplayState createState() => _ApiContentDisplayState();
}

class _ApiContentDisplayState extends State<ApiContentDisplay> {
  String apiContent = "Loading...";

  @override
  void initState() {
    super.initState();
    makeApiCall();
  }

  Future<void> makeApiCall() async {
    const String apiUrl = "https://openrouter.ai/api/v1/chat/completions";
    const String openRouterApiKey = "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";

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Authorization": "Bearer $openRouterApiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "model": "mistralai/mixtral-8x7b-instruct",
        "messages": [
          {"role": "user", "content": "Generate a detailed travel itinerary for a trip to Paris, France from Munich"}
        ]
      }),
    );

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = jsonDecode(response.body);

      // Extract and print the content from the choices array
      final content = jsonResponse['choices'][0]['message']['content'];
      print("$content");
      setState(() {
        apiContent = content;
      });
    } else {
      // Handle errors
      print("Error: ${response.statusCode} - ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("API Response Display"),
      ),
      body: Center(
        child: Text(apiContent),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ApiContentDisplay(),
  ));
}

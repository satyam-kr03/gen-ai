import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {

  String location = '';
  String destinationValue = '';
  bool isLoading = false;
  final TextEditingController _locationController = TextEditingController();

  Future<void> makeApiCall(String from, String optionTitle) async {
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
            {"role": "user", "content": "$optionTitle in $from"}
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AppBar(
              title: const Text('AI Travel Guide'),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Text field for "From"
                  TextField(
                    controller: _locationController,
                    onChanged: (value) {
                      setState(() {
                        location = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Location',
                      hintText: 'Enter your current location',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      // Clear the text field
                      _locationController.clear();
                    },
                    child: isLoading
                        ? const CircularProgressIndicator() // Show loading indicator
                        : const Text('Clear'),
                  ),
                  const SizedBox(height: 16.0),
                  for (final option in options)
                    OptionCard(
                      title: option.title,
                      icon: Icon(option.icon),
                      onPressed: () => context.go(option.route, extra: {"location": location}),
                    ),
                ],
              ),
            ),
          ],
        ),
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
        title: const Text('Travel Itinerary'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            content,
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}

class OptionCard extends StatelessWidget {
  const OptionCard({
    required this.title,
    required this.onPressed,
    required this.icon,
    super.key,
  });
  final String title;
  final VoidCallback onPressed;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              icon,
              const SizedBox(width: 16),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}

final options = [
  const Option(
    title: 'Hotels',
    route: '/explore/hotels',
    icon: Icons.hotel,
  ),
  const Option(
    title: 'Dining',
    route: '/explore/dining',
    icon: Icons.restaurant,
  ),
  const Option(
    title: 'Shopping',
    route: '/explore/shopping',
    icon: Icons.shopping_cart,
  ),
  const Option(
    title: 'Local Attractions',
    route: '/explore/local',
    icon: Icons.stadium,
  ),
  const Option(
    title: 'Weather Updates',
    route: '/explore/weather',
    icon: Icons.sunny,
  ),
  const Option(
    title: 'Translation Help',
    route: '/explore/translation',
    icon: Icons.translate,
  ),
  const Option(
    title: 'Currency Conversion',
    route: '/explore/currency',
    icon: Icons.attach_money,
  ),
];

class Option {
  const Option({
    required this.title,
    required this.route,
    required this.icon,
  });
  final String title;
  final String route;
  final IconData icon;
}

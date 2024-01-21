import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> favorites = [];
  List<String> locationSuggestions = [];

  Future<void> fetchLocationSuggestions(String query) async {
    final response = await http.get(
      Uri.parse('https://nominatim.openstreetmap.org/search?format=json&q=$query'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        locationSuggestions = data.map((item) => item['display_name'].toString()).toList();
      });
    }
  }

  void addToFavorites(String location) {
    setState(() {
      favorites.add(location);
      _searchController.clear();
      locationSuggestions.clear();
    });
  }

  void removeFromFavorites(String location) {
    setState(() {
      favorites.remove(location);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Search'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                onChanged: (query) {
                  if (query.isNotEmpty) {
                    fetchLocationSuggestions(query);
                  } else {
                    setState(() {
                      locationSuggestions.clear();
                    });
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Search for a location',
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  String location = _searchController.text;
                  if (location.isNotEmpty) {
                    addToFavorites(location);
                  }
                },
                child: const Text('Add to Favorites'),
              ),
              SizedBox(height: 16.0),
              if (locationSuggestions.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Suggestions:',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: locationSuggestions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(locationSuggestions[index]),
                          onTap: () {
                            _searchController.text = locationSuggestions[index];
                            addToFavorites(locationSuggestions[index]);
                          },
                        );
                      },
                    ),
                  ],
                ),
              const Text(
                'Favorites:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                reverse: true,
                shrinkWrap: true,
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(favorites[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        removeFromFavorites(favorites[index]);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

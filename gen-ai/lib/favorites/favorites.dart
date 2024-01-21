import 'package:flutter/material.dart';


class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  TextEditingController _searchController = TextEditingController();
  List<String> favorites = [];

  void addToFavorites(String location) {
    setState(() {
      favorites.add(location);
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
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
                  _searchController.clear();
                }
              },
              child: Text('Add to Favorites'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Favorites:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
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
            ),
          ],
        ),
      ),
    );
  }
}

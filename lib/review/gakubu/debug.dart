import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Algolia algolia = Algolia.init(
  applicationId: '78CZVABC2W',
  apiKey: 'c2377e7faad9a408d5867b849f25fae4',
);

Future<List<AlgoliaObjectSnapshot>> search(String query) async {
  AlgoliaQuery algoliaQuery = algolia.instance.index('INDEX_NAME').search(query);
  AlgoliaQuerySnapshot snap = await algoliaQuery.getObjects();
  return snap.hits;
}

Future<void> addToFavorites(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Set<String> favorites = prefs.getStringList('favorites')?.toSet() ?? {};
  favorites.add(id);
  await prefs.setStringList('favorites', favorites.toList());
}

Future<void> removeFromFavorites(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Set<String> favorites = prefs.getStringList('favorites')?.toSet() ?? {};
  favorites.remove(id);
  await prefs.setStringList('favorites', favorites.toList());
}

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  List<AlgoliaObjectSnapshot> _hits = [];
  Set<String> _favorites = {};

  @override
  void initState() {
    super.initState();
    _getFavorites();
  }

  Future<void> _getFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> favorites = prefs.getStringList('favorites')?.toSet() ?? {};
    setState(() {
      _favorites = favorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AlgoliaObjectSnapshot>>(
      future: search('SEARCH_QUERY'),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        _hits = snapshot.data!;

        return ListView.builder(
          itemCount: _hits.length,
          itemBuilder: (context, index) {
            AlgoliaObjectSnapshot hit = _hits[index];
            bool isFavorite = _favorites.contains(hit.objectID);
            return isFavorite
                ? ListTile(
              title: Text(hit.data['title']),
              subtitle: Text(hit.data['subtitle']),
              trailing: IconButton(
                icon: Icon(Icons.favorite),
                onPressed: () {
                  removeFromFavorites(hit.objectID);
                  setState(() {
                    _favorites.remove(hit.objectID);
                  });
                },
              ),
            )
                : ListTile(
              title: Text(hit.data['title']),
              subtitle: Text(hit.data['subtitle']),
              trailing: IconButton(
                icon: Icon(Icons.favorite_border),
                onPressed: () {
                  addToFavorites(hit.objectID);
                  setState(() {
                    _favorites.add(hit.objectID);
                  });
                },
              ),
            );
          },
        );
      },
    );
  }
}

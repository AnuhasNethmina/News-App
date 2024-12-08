import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Shared list of favorited articles
List<Map<String, String>> favoritedArticles = [];

class News extends StatefulWidget {
  final String title;
  final String description;
  final String imageUrl;
  final VoidCallback? onTap;

  const News({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.onTap,
  });

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  bool isFavorited = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  // Load favorites from SharedPreferences
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedFavorites = prefs.getString('favoritedArticles');
    if (storedFavorites != null) {
      setState(() {
        favoritedArticles =
            List<Map<String, String>>.from(jsonDecode(storedFavorites));
        isFavorited = favoritedArticles
            .any((article) => article['title'] == widget.title);
      });
    }
  }

  // Save favorites to SharedPreferences
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('favoritedArticles', jsonEncode(favoritedArticles));
  }

  // Toggle the favorite state and show a SnackBar
  void toggleFavorite() async {
    setState(() {
      isFavorited = !isFavorited;
    });

    if (isFavorited) {
      favoritedArticles.add({
        'title': widget.title,
        'description': widget.description,
        'imageUrl': widget.imageUrl,
      });
    } else {
      favoritedArticles
          .removeWhere((article) => article['title'] == widget.title);
    }

    await _saveFavorites();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            isFavorited ? 'Added to Favourites' : 'Removed from Favourites'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.imageUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(10.0)),
                    child: Image.network(
                      widget.imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.image,
                      size: 50,
                      color: Colors.grey[700],
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isFavorited ? Icons.star : Icons.star_border,
                          color: isFavorited ? Colors.yellow : Colors.grey,
                        ),
                        onPressed: toggleFavorite,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
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

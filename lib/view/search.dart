import 'package:flutter/material.dart';
import 'package:myapp/model/news_details.dart';
import 'package:myapp/services/service.dart';
import 'package:myapp/model/news.dart'; 

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _controller = TextEditingController();
  final ApiService apiService = ApiService();
  List<dynamic> _searchResults = [];

  void _performSearch() async {
    final results = await apiService.searchArticles(_controller.text);
    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: 'Search news...'),
          onSubmitted: (_) => _performSearch(),
        ),
      ),
      body: _searchResults.isEmpty
          ? const Center(child: Text('No results found'))
          : ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final title = _searchResults[index]['title'] ?? '';
                final description = _searchResults[index]['description'] ?? '';
                final imageUrl = _searchResults[index]['urlToImage'] ?? '';
                final content =
                    _searchResults[index]['content'] ?? 'No content available';

                return News(
                  title: title,
                  description: description,
                  imageUrl: imageUrl,
                  onTap: () {
                    // Navigate to the existing NewsDetails screen and pass the data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetails(
                          title: title,
                          content: content,
                          imageUrl: imageUrl,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

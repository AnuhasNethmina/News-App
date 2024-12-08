import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:myapp/model/news.dart';
import 'package:myapp/model/news_details.dart';
import 'package:myapp/services/service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ApiService apiService = ApiService();
  String _sortOption = 'Title'; // Default sorting option

  // Format date for display
  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'Unknown Date';
    try {
      final DateTime dateTime = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy').format(dateTime);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  // Sort articles based on selected option
  List<dynamic> sortArticles(List<dynamic> articles) {
    if (_sortOption == 'Title') {
      articles.sort((a, b) => (a['title'] ?? '').compareTo(b['title'] ?? ''));
    } else if (_sortOption == 'Latest') {
      articles.sort(
          (a, b) => (b['publishedAt'] ?? '').compareTo(a['publishedAt'] ?? ''));
    } else if (_sortOption == 'Oldest') {
      articles.sort(
          (a, b) => (a['publishedAt'] ?? '').compareTo(b['publishedAt'] ?? ''));
    }
    return articles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Headlines'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        actions: [
          // Single Dropdown: Sort by Title, Latest, Oldest
          DropdownButton<String>(
            value: _sortOption,
            dropdownColor: Colors.white,
            style: const TextStyle(color: Colors.black, fontSize: 16),
            underline: Container(
              height: 2,
              color: Colors.blue,
            ),
            onChanged: (String? newValue) {
              setState(() {
                _sortOption = newValue!;
              });
            },
            items: <String>['Title', 'Latest', 'Oldest']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      body: FutureBuilder(
        future: apiService.fetchTopHeadlines(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else {
            final articles = snapshot.data as List<dynamic>;
            final sortedArticles = sortArticles(articles);

            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: sortedArticles.length,
              itemBuilder: (context, index) {
                final article = sortedArticles[index];
                final title = article['title'] ?? 'No Title';
                final description = article['description'] ?? 'No Description';
                final imageUrl = article['urlToImage'] ?? '';
                final content = article['content'] ?? 'No Content';

                return News(
                  title: title,
                  description: description,
                  imageUrl: imageUrl,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NewsDetails(
                          title: title,
                          content: content,
                          imageUrl: imageUrl,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

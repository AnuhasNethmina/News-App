import 'package:flutter/material.dart';
import 'package:myapp/model/news.dart';
import 'package:myapp/services/service.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final ApiService apiService = ApiService();
  late Future<List<String>> categories; // Future for category list

  @override
  void initState() {
    super.initState();
    categories =
        apiService.fetchCategories(); // Fetch categories on screen load
  }

  // Define a smaller border radius for all cards
  final BorderRadius cardShape = BorderRadius.circular(8); // Smaller shape

  // Define a list of colors to cycle through
  final List<Color> cardColors = [
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.purpleAccent,
    Colors.orangeAccent,
    Colors.redAccent,
    Colors.tealAccent,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: FutureBuilder<List<String>>(
        future: categories, // Fetch categories from API
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching categories'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No categories available'));
          } else {
            final categories = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Keep this to 2 for smaller grid items
                crossAxisSpacing: 5,
                mainAxisSpacing: 10,
                childAspectRatio: 1.5,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cardColor = cardColors[index % cardColors.length];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CategoryArticlesScreen(
                          category: categories[index],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: cardColor,
                    shape: RoundedRectangleBorder(borderRadius: cardShape),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(
                          8.0), // Adjust padding inside cards
                      child: Center(
                        child: Text(
                          categories[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20, // Smaller font size
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

// Category Articles screen where you show articles of a selected category
class CategoryArticlesScreen extends StatelessWidget {
  final String category;
  final ApiService apiService = ApiService();

  CategoryArticlesScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: FutureBuilder(
        future: apiService.fetchCategoryArticles(category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching articles'));
          } else {
            final articles = snapshot.data as List<dynamic>;
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Navigate to the full article screen on tap
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AllNewsScreen(
                          article: articles[index],
                        ),
                      ),
                    );
                  },
                  child: News(
                    title: articles[index]['title'] ?? '',
                    description: articles[index]['description'] ?? '',
                    imageUrl: articles[index]['urlToImage'] ?? '',
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

// Full news screen where you display the full news article
class AllNewsScreen extends StatelessWidget {
  final dynamic article; // The article data passed from CategoryArticlesScreen

  const AllNewsScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article['title'] ?? '')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article['urlToImage'] != null)
              Image.network(article['urlToImage']),
            const SizedBox(height: 16.0),
            Text(
              article['title'] ?? '',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              article['publishedAt'] ?? '',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16.0),
            Text(
              article['content'] ?? 'No content available',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

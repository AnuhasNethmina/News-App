import 'package:flutter/material.dart';
import 'package:myapp/view/favorite.dart';
import 'package:myapp/view/home.dart';
import 'package:myapp/view/category.dart';
import 'package:myapp/view/search.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    Home(),
    Category(),
    Search(),
    Favorite(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        height: 70, // Set the height to ensure enough space for labels
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 13, 87, 225), // Background color
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0), // No corner radius (no cut-out)
            topRight: Radius.circular(0), // No corner radius (no cut-out)
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.transparent, // Make background transparent
          selectedItemColor: Colors.black, // Black for selected icon/text
          unselectedItemColor: Colors.black, // Black for unselected icon/text
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _currentIndex == 0
                    ? Colors.green
                    : Colors.black, // Color for home icon
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.category,
                color: _currentIndex == 1
                    ? Colors.blue
                    : Colors.black, // Color for category icon
              ),
              label: 'Category',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: _currentIndex == 2
                    ? Colors.orange
                    : Colors.black, // Color for search icon
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: _currentIndex == 3
                    ? Colors.red
                    : Colors.black, // Color for favorite icon
              ),
              label: 'Favourite',
            ),
          ],
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black, // Keep selected text black
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.black, // Keep unselected text black
          ),
          showSelectedLabels: true,
          showUnselectedLabels: true, // Ensure unselected labels are shown
        ),
      ),
    );
  }
}

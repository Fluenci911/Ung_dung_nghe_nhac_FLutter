import 'package:flutter/material.dart';

class PodcastPage extends StatelessWidget {
  // Danh sách danh mục
  final List<Map<String, dynamic>> categories = [
    {
      'title': 'Technology',
      'colors': [Colors.blue, Colors.blueAccent],
      'icon': Icons.computer,
    },
    {
      'title': 'Motivation',
      'colors': [Colors.orange, Colors.deepOrangeAccent],
      'icon': Icons.lightbulb,
    },
    {
      'title': 'History',
      'colors': [Colors.green, Colors.greenAccent],
      'icon': Icons.book,
    },
    {
      'title': 'Comedy',
      'colors': [Colors.pink, Colors.pinkAccent],
      'icon': Icons.sentiment_satisfied,
    },
    {
      'title': 'Science',
      'colors': [Colors.purple, Colors.purpleAccent],
      'icon': Icons.science,
    },
    {
      'title': 'Sports',
      'colors': [Colors.red, Colors.redAccent],
      'icon': Icons.sports_soccer,
    },
    {
      'title': 'Music',
      'colors': [Colors.teal, Colors.tealAccent],
      'icon': Icons.music_note,
    },
    {
      'title': 'Travel',
      'colors': [Colors.amber, Colors.amberAccent],
      'icon': Icons.travel_explore,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh Mục Podcasts'),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _buildCategoryCard(category);
          },
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return GestureDetector(
      onTap: () {
        // Hành động khi nhấn vào danh mục
        print('Selected category: ${category['title']}');
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: category['colors'],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: category['colors'][1].withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              category['icon'],
              size: 50,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Text(
              category['title'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

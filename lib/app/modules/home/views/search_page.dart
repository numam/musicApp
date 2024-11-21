import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Cari', style: TextStyle(color: Colors.white)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: Colors.white),
                    SizedBox(width: 8.0),
                    Text('Apa yang ingin kamu dengarkan?',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Explore categories
              const Text('Mulai jelajahi',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCategoryItem('Musik', Colors.pink),
                  _buildCategoryItem('Podcast', Colors.green),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCategoryItem('Acara Langsung', Colors.purple),
                  _buildCategoryItem('K-Pop On! Hub', Colors.blue),
                ],
              ),
              const SizedBox(height: 20),
              // Genre section
              const Text('Jelajahi genremu',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildGenreItem('#indie indonesia', 'assets/indie.png'),
                    _buildGenreItem('#rock remaja', 'assets/rock.png'),
                    _buildGenreItem('#angst', 'assets/angst.png'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Explore all
              const Text('Jelajahi semua',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCategoryItem('Dibuat Untuk Kamu', Colors.blue),
                  _buildCategoryItem('Rilis Baru', Colors.green),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String title, Color color) {
    return Container(
      height: 80,
      width: 150,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildGenreItem(String title, String imagePath) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          color: Colors.black.withOpacity(0.7),
          padding: const EdgeInsets.all(4.0),
          child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ),
      ),
    );
  }
}

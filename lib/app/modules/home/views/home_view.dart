import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'profile_page.dart';  // Import halaman baru
import 'detail_page.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Menambahkan background color hitam
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Listen Now',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => ProfilePage());  // Navigasi ke halaman baru saat CircleAvatar ditekan
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.red.shade800, Colors.red.shade600],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '80 million songs to\nplay or download. All\nad-free',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.apple, color: Colors.white, size: 30),
                        Text(
                          'Music',
                          style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Try it free',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      '1 month free, then US\$4.99/month.',
                      style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'New Songs Added',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 250,
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());  // Menampilkan loading indicator
                } else if (controller.songs.isEmpty) {
                  return Center(child: Text('No songs found', style: TextStyle(color: Colors.white)));
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.songs.length,
                    itemBuilder: (context, index) {
                      var song = controller.songs[index];
                      return _buildMusicItem(song['title'], song['artist']['name'], song['album']['cover_medium']);
                    },
                  );
                }
              }),
            ),

            // Bagian baru untuk "Stations by Genre" yang dinamis
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Stations by Genre',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 200,
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else if (controller.genres.isEmpty) {
                  return Center(child: Text('No genres found', style: TextStyle(color: Colors.white)));
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.genres.length,
                    itemBuilder: (context, index) {
                      var genre = controller.genres[index];
                      var radio = genre['radios'][0];  // Mengambil radio pertama dari genre
                      return _buildStationItem(genre['title'], radio['picture_medium']);  // Menampilkan gambar radio
                    },
                  );
                }
              }),
            ),



            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Albums We Love',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 250,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildAlbumItem('Moonlit Floor - Single', 'The 1978', () {
                    Get.to(() => DetailPage(title: 'Moonlit Floor - Single', artist: 'Billie Eilish'));
                  }),
                  _buildAlbumItem('D-Day', 'Machine Gun Kelly', () {}),
                  _buildAlbumItem('Sour', 'Oliva', () {}),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.play_circle_filled), label: 'Listen Now'),
          BottomNavigationBarItem(icon: Icon(Icons.radio), label: 'Radio'),
          BottomNavigationBarItem(icon: Icon(Icons.library_music), label: 'Library'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        ],
      ),
    );
  }

  Widget _buildMusicItem(String title, String artist, String imageUrl) {
    return Container(
      width: 150,
      margin: EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(imageUrl),  // Menggunakan gambar dari Deezer API
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(title, style: TextStyle(color: Colors.white, fontSize: 14)),
          Text(artist, style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildStationItem(String title, String imageUrl) {
    return Container(
      width: 150,
      margin: EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: imageUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(imageUrl),  // Menggunakan gambar dari API
                      fit: BoxFit.cover,
                    )
                  : null,
              color: imageUrl.isEmpty ? Colors.grey : null,  // Gambar placeholder jika tidak ada gambar
            ),
            child: imageUrl.isEmpty
                ? Center(child: Icon(Icons.music_note, color: Colors.white, size: 50))
                : null,
          ),
          SizedBox(height: 5),
          Text(title, style: TextStyle(color: Colors.white, fontSize: 14)),
          Text('Deezer Radio', style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }


  Widget _buildAlbumItem(String title, String artist, Function onTap) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        width: 150,
        margin: EdgeInsets.only(left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 5),
            Text(title, style: TextStyle(color: Colors.white, fontSize: 14)),
            Text(artist, style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

import 'package:apple_music/app/modules/home/views/search_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'profile_page.dart';
import 'detail_page.dart';
import 'library_page.dart';
import 'register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Halo',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () async {
                        final user = FirebaseAuth.instance.currentUser;
                        if (user == null) {
                          Get.to(() => RegisterScreen(), transition: Transition.noTransition);
                        } else {
                          Get.to(() => ProfilePage(), transition: Transition.noTransition);
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              // Promo Section
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

              // Chart Tracks Section
              _buildSectionTitle('Chart Tracks'),
              _buildHorizontalSongList(controller.songs),

              // Trending Tracks Section
              _buildSectionTitle('Trending Tracks'),
              _buildHorizontalSongList(controller.trendingSongs),

              // Pop Tracks Section
              _buildSectionTitle('Pop Tracks'),
              _buildHorizontalSongList(controller.popSongs),

              // Rock Tracks Section
              _buildSectionTitle('Rock Tracks'),
              _buildHorizontalSongList(controller.rockSongs),

              // Stations by Genre Section
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
                        var radio = genre['radios'][0];
                        return _buildStationItem(genre['title'], radio['picture_medium']);
                      },
                    );
                  }
                }),
              ),

              // Albums We Love Section
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
                      Get.to(() => DetailPage(title: 'Moonlit Floor - Single', artist: 'Billie Eilish'), transition: Transition.noTransition);
                    }),
                    _buildAlbumItem('D-Day', 'Machine Gun Kelly', () {}),
                    _buildAlbumItem('Sour', 'Oliva', () {}),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 2) {
            Get.to(() => LibraryPage(), transition: Transition.noTransition);
          }
          else if (index == 3) {
            Get.to(() => SearchPage(), transition: Transition.noTransition);
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.play_circle_filled), label: 'Listen Now'),
          BottomNavigationBarItem(icon: Icon(Icons.radio), label: 'Radio'),
          BottomNavigationBarItem(icon: Icon(Icons.library_music), label: 'Library'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        ],
      ),
    );
  }

  // Helper method to create section titles
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Helper method to create horizontal song list
  Widget _buildHorizontalSongList(RxList<dynamic> songList) {
    return Container(
      height: 250,
      child: Obx(() {
        if (songList.isEmpty) {
          return Center(
            child: CircularProgressIndicator(color: Colors.red),
          );
        }
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: songList.length,
          itemBuilder: (context, index) {
            var song = songList[index];
            return _buildMusicItem(
              song['title'], 
              song['artist']['name'], 
              song['album']['cover_medium'] ?? '', 
              song
            );
          },
        );
      }),
    );
  }

  Widget _buildMusicItem(String title, String artist, String imageUrl, dynamic songData) {
    return GestureDetector(
      onTap: () {
        Get.find<HomeController>().playTrack(songData);
      },
      child: Container(
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
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
                color: imageUrl.isEmpty ? Colors.grey.shade800 : null,
              ),
              child: imageUrl.isEmpty 
                ? Center(child: Icon(Icons.music_note, color: Colors.white, size: 50)) 
                : null,
            ),
            SizedBox(height: 5),
            Text(title, 
              style: TextStyle(color: Colors.white, fontSize: 14), 
              maxLines: 1, 
              overflow: TextOverflow.ellipsis
            ),
            Text(artist, 
              style: TextStyle(color: Colors.grey, fontSize: 12),
              maxLines: 1, 
              overflow: TextOverflow.ellipsis
            ),
          ],
        ),
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
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
              color: imageUrl.isEmpty ? Colors.grey : null,
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
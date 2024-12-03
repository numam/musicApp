import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'library_page.dart';
import 'search_page.dart';

class ShortVideoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        itemCount: 10, // Replace with your video list or API
        itemBuilder: (context, index) {
          return Center(
            child: Container(
              color: Colors.black,
              child: Stack(
                children: [
                  // Video content, can use a package like video_player
                  Positioned.fill(
                    child: Image.network('https://placekitten.com/800/1200', fit: BoxFit.cover), // Replace with actual video widget
                  ),
                  Positioned(
                    bottom: 50,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Video Title #$index',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        Text(
                          'Description of video $index',
                          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 1) {
            // Navigate to Short Video Page (like TikTok)
            Get.to(() => ShortVideoPage(), transition: Transition.noTransition);
          }
          else if (index == 2) {
            Get.to(() => LibraryPage(), transition: Transition.noTransition);
          } 
          else if (index == 3) {
            Get.to(() => SearchPage(), transition: Transition.noTransition);
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.play_circle_filled), label: 'Listen Now'),
          BottomNavigationBarItem(icon: Icon(Icons.radio), label: 'Story'),
          BottomNavigationBarItem(icon: Icon(Icons.library_music), label: 'Library'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        ],
      ),
    );
  }
}

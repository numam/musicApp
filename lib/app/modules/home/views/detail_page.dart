import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String title;
  final String artist;

  const DetailPage({Key? key, required this.title, required this.artist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              // Thumbnail image
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/album_cover.jpg'),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Main image
              Center(
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/album_cover.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                '$artist - $title',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 10),
              LinearProgressIndicator(
                value: 0.3,
                backgroundColor: Colors.grey[800],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('0:48', style: TextStyle(color: Colors.white)),
                  Text('4:30', style: TextStyle(color: Colors.white)),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.skip_previous, color: Colors.white, size: 40),
                  Icon(Icons.pause, color: Colors.white, size: 40),
                  Icon(Icons.skip_next, color: Colors.white, size: 40),
                ],
              ),
              SizedBox(height: 20),
              Slider(
                value: 0.5,
                onChanged: (value) {},
                activeColor: Colors.white,
                inactiveColor: Colors.grey[800],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.tv, color: Colors.white),
                  Icon(Icons.wifi, color: Colors.white),
                  Icon(Icons.battery_full, color: Colors.white),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
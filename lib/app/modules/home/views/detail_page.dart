import 'package:flutter/material.dart';
import 'music_player_screen.dart';
import 'artist_detail_screen.dart';

class DetailPage extends StatelessWidget {
  final String title;
  final String artist;

  const DetailPage({Key? key, required this.title, required this.artist})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: const DecorationImage(
                              image: AssetImage('lib/app/assets/lisa.webp'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          height: 400,
                          width: 400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SliderTheme(
                      data: const SliderThemeData(
                        trackHeight: 2,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 4),
                      ),
                      child: Slider(
                        value: 0.3,
                        onChanged: (value) {},
                        activeColor: Colors.white,
                        inactiveColor: Colors.grey[800],
                      ),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('03:45',
                            style:
                                TextStyle(color: Colors.white, fontSize: 12)),
                        Text('04:20',
                            style:
                                TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(Icons.skip_previous,
                          color: Colors.white, size: 32),
                      GestureDetector(
                        onTap: () {
                          // Navigate to MusicPlayerScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MusicPlayerScreen(),
                            ),
                          );
                        },
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.pause,
                              color: Colors.black, size: 32),
                        ),
                      ),
                      const Icon(Icons.skip_next,
                          color: Colors.white, size: 32),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.volume_up,
                          color: Colors.white, size: 20),
                      Expanded(
                        child: SliderTheme(
                          data: const SliderThemeData(
                            trackHeight: 2,
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 4),
                          ),
                          child: Slider(
                            value: 0.5,
                            onChanged: (value) {},
                            activeColor: Colors.white,
                            inactiveColor: Colors.grey[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chat_bubble_outline,
                            color: Colors.white, size: 24),
                        onPressed: () {
                          // Navigate to ArtistDetailScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ArtistDetailScreen(),
                            ),
                          );
                        },
                      ),
                      const Icon(Icons.wifi, color: Colors.white, size: 24),
                      const Icon(Icons.list, color: Colors.white, size: 24),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

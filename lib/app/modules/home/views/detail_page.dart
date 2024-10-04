import 'package:flutter/material.dart';

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
                              image: AssetImage('lib/app/assets/cover.webp'), // Menggunakan gambar yang sama
                              fit: BoxFit.cover,
                            ),
                          ),
                          height: 300, // Ukuran tinggi untuk menyesuaikan gambar
                          width: 300,  // Ukuran lebar untuk menyesuaikan gambar
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
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
                      Container(
                        width: 64,
                        height: 64,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.pause,
                            color: Colors.black, size: 32),
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.chat_bubble_outline,
                          color: Colors.white, size: 24),
                      Icon(Icons.wifi, color: Colors.white, size: 24),
                      Icon(Icons.list, color: Colors.white, size: 24),
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

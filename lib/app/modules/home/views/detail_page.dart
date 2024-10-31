import 'package:flutter/material.dart';
import 'artist_detail_screen.dart'; // Import halaman WebView yang sudah kita buat

class DetailPage extends StatelessWidget {
  final String title;
  final String artist;

  const DetailPage({Key? key, required this.title, required this.artist})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Save', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Gambar dan Info Musik
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Gambar Album
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: const DecorationImage(
                          image: AssetImage('lib/app/assets/lisa.webp'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      height: 250,
                      width: 250,
                    ),
                    const SizedBox(height: 20),
                    // Nama lagu dan artis
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Slider dan Waktu Lagu
                    SliderTheme(
                      data: const SliderThemeData(
                        trackHeight: 2,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 6),
                      ),
                      child: Slider(
                        value: 0.7,
                        onChanged: (value) {},
                        activeColor: Colors.white,
                        inactiveColor: Colors.grey[800],
                      ),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('03:45',
                            style: TextStyle(color: Colors.white, fontSize: 12)),
                        Text('04:20',
                            style: TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              // Kontrol Musik
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  children: [
                    // Tombol Play, Next, dan Previous
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(Icons.skip_previous,
                            color: Colors.white, size: 32),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.play_arrow,
                                color: Colors.black, size: 32),
                          ),
                        ),
                        const Icon(Icons.skip_next,
                            color: Colors.white, size: 32),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Deskripsi Artis dan Tombol Read More
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tentang Artis',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Billie Eilish remains one of the biggest stars to emerge in the 21st century. '
                            'Her third studio album, HIT ME HARD AND SOFT features 10 tracks written and recorded '
                            'in her hometown of Los Angeles, with her brother and producer FINNEAS.',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () {
                              // Navigate to WebView when 'Read More' is clicked
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ArtistDetailScreen(), // Navigate to WebView
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            child: const Center(
                              child: Text('Read More',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

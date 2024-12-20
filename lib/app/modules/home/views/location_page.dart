import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/location_controller.dart';
import 'home_view.dart';
import 'library_page.dart';
import 'search_page.dart';

class LocationPage extends StatelessWidget {
  final LocationController locationController = Get.put(LocationController());

  // List lokasi lokal dengan nama konser dan koordinat (tanpa gambar)
  final List<Map<String, dynamic>> localKonser = [
    {
      "name": "Dewa 19",
      "latitude": -7.919796810743284,
      "longitude": 112.5954652246449,
    },
    {
      "name": "Sunset di Kebun",
      "latitude": -7.798476467443606,
      "longitude": 112.73697876959105,
    },
    {
      "name": "IndieFest",
      "latitude": -7.975368965714673,
      "longitude": 112.62448892279613,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: locationController.getCurrentLocation,
          ),
        ],
        title: Text(
          'Konser Terdekat', style: TextStyle(color: Colors.white)
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          final position = locationController.currentPosition.value;

          if (position == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView(
              children: [
                Card(
                  color: Colors.red,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    title: Text('Lokasi Anda', style: TextStyle(color: Colors.white),),
                    subtitle: Text(locationController.locationMessage.value, style: TextStyle(color: Colors.white),),
                    leading:
                        const Icon(Icons.location_on, color: Colors.white),
                    onTap: locationController.openGoogleMaps,
                  ),
                ),
                const SizedBox(height: 20),
                ...localKonser.map((konser) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(konser['name']),
                      subtitle: const Text('Yuk, Beli Tiket!'),
                      onTap: () {
                        locationController.openGoogleMapsWithCoordinates(
                          konser['latitude'],
                          konser['longitude'],
                        );
                      },
                    ),
                  );
                }).toList(),
              ],
            );
          }
        }),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            backgroundBlendMode: BlendMode.overlay,
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed, // Tambahkan ini
              backgroundColor: Colors.transparent, // Ubah ke transparent
              selectedItemColor: Colors.red,
              unselectedItemColor: Colors.grey,
              currentIndex: 1, // Aktif di icon Lokasi
              onTap: (index) {
                switch (index) {
                  case 0:
                    Get.to(() => HomeView(), transition: Transition.noTransition);
                    break;
                  case 1:
                    // Sudah di halaman Location, jadi tidak perlu navigasi
                    break;
                  case 2:
                    Get.to(() => LibraryPage(), transition: Transition.noTransition);
                    break;
                  case 3:
                    Get.to(() => SearchPage(), transition: Transition.noTransition);
                    break;
                }
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.play_circle_filled), label: 'Beranda'),
                BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Konser'),
                BottomNavigationBarItem(icon: Icon(Icons.library_music), label: 'Playlist'),
                BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

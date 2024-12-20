import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../controllers/playlist_controller.dart';
import 'NoConnectionView.dart';
import 'home_view.dart';
import 'location_page.dart';
import 'playlist_detail_view.dart';
import 'search_page.dart';


class LibraryPage extends StatelessWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playlistController = Get.find<PlaylistController>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Playlist', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 30, color: Colors.white),
            onPressed: () {
              _showCreatePlaylistDialog(context, playlistController);
            },
          ),
        ],
      ),
      body: Obx(() {
        // Deteksi jika tidak ada koneksi internet
        if (!playlistController.isConnected.value) {
          return const NoConnectionView();
        }

        // Tampilkan grid playlist jika koneksi tersedia
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: playlistController.playlists.length,
          itemBuilder: (context, index) {
            final playlist = playlistController.playlists[index];
            return GestureDetector(
              onTap: () {
                Get.to(() => PlaylistDetailView(playlist: playlist));
              },
              child: Card(
                color: Colors.grey[900],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: playlist['coverMediaPath'] != null
                          ? Image.file(
                              File(playlist['coverMediaPath']),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[800],
                                  child: const Icon(Icons.music_note,
                                      size: 50, color: Colors.white),
                                );
                              },
                            )
                          : Container(
                              color: Colors.grey[800],
                              child: const Icon(Icons.music_note,
                                  size: 50, color: Colors.white),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              playlist['name'],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          PopupMenuButton<String>(
                            color: Colors.grey[800],
                            icon:
                                const Icon(Icons.more_vert, color: Colors.white),
                            onSelected: (value) {
                              if (value == 'edit') {
                                _showEditPlaylistDialog(
                                  context,
                                  playlistController,
                                  playlist['id'],
                                  currentName: playlist['name'],
                                );
                              } else if (value == 'delete') {
                                playlistController.deletePlaylist(
                                    playlist['id']);
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              const PopupMenuItem<String>(
                                value: 'edit',
                                child: Text('Edit',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('Delete',
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
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
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              selectedItemColor: Colors.red,
              unselectedItemColor: Colors.grey,
              currentIndex: 2,
              onTap: (index) {
                switch (index) {
                  case 0:
                    Get.to(() => HomeView(),
                        transition: Transition.noTransition);
                    break;
                  case 1:
                    Get.to(() => LocationPage(),
                        transition: Transition.noTransition);
                    break;
                  case 2:
                    break;
                  case 3:
                    Get.to(() => SearchPage(),
                        transition: Transition.noTransition);
                    break;
                }
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.play_circle_filled), label: 'Beranda'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.location_on), label: 'Konser'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.library_music), label: 'Playlist'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search), label: 'Search'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCreatePlaylistDialog(
      BuildContext context, PlaylistController controller) {
    final TextEditingController nameController = TextEditingController();
    File? selectedCoverMedia;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Playlist'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration:
                  const InputDecoration(hintText: 'Playlist Name'),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    selectedCoverMedia = await controller.pickCoverMedia();
                    if (selectedCoverMedia != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Media Selected')),
                      );
                    }
                  },
                  child: const Text('Gallery'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    selectedCoverMedia =
                        await controller.pickCoverMedia(fromCamera: true);
                    if (selectedCoverMedia != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Camera Photo Selected')),
                      );
                    }
                  },
                  child: const Text('Camera'),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                controller.createPlaylist(
                  nameController.text,
                  coverMedia: selectedCoverMedia,
                );
                Get.back();
              } else {
                Get.snackbar('Error', 'Playlist name cannot be empty');
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showEditPlaylistDialog(BuildContext context,
      PlaylistController controller, String playlistId,
      {String? currentName}) {
    final TextEditingController nameController =
        TextEditingController(text: currentName);
    File? selectedCoverMedia;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Playlist'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration:
                  const InputDecoration(hintText: 'New Playlist Name'),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    selectedCoverMedia = await controller.pickCoverMedia();
                    if (selectedCoverMedia != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Media Selected')),
                      );
                    }
                  },
                  child: const Text('Gallery'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    selectedCoverMedia =
                        await controller.pickCoverMedia(fromCamera: true);
                    if (selectedCoverMedia != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Camera Photo Selected')),
                      );
                    }
                  },
                  child: const Text('Camera'),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                controller.editPlaylist(
                  playlistId,
                  nameController.text,
                  newCoverMedia: selectedCoverMedia,
                );
                Get.back();
              } else {
                Get.snackbar('Error', 'Playlist name cannot be empty');
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}

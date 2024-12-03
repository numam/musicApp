import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../controllers/playlist_controller.dart';
import 'home_view.dart';
import 'playlist_detail_view.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playlistController = Get.find<PlaylistController>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Library', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showCreatePlaylistDialog(context, playlistController);
            },
          ),
        ],
      ),
      body: Obx(() {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                  child: Icon(Icons.music_note, size: 50, color: Colors.white),
                                );
                              },
                            )
                          : Container(
                              color: Colors.grey[800],
                              child: Icon(Icons.music_note, size: 50, color: Colors.white),
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
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          PopupMenuButton<String>(
                            color: Colors.grey[800],
                            icon: Icon(Icons.more_vert, color: Colors.white),
                            onSelected: (value) {
                              if (value == 'edit') {
                                _showEditPlaylistDialog(
                                  context, 
                                  playlistController, 
                                  playlist['id'],
                                  currentName: playlist['name']
                                );
                              } else if (value == 'delete') {
                                playlistController.deletePlaylist(playlist['id']);
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              PopupMenuItem<String>(
                                value: 'edit',
                                child: Text('Edit', style: TextStyle(color: Colors.white)),
                              ),
                              PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('Delete', style: TextStyle(color: Colors.red)),
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Get.to(() => HomeView(), transition: Transition.noTransition);
          }
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.play_circle_filled), label: 'Listen Now'),
          BottomNavigationBarItem(icon: Icon(Icons.radio), label: 'Radio'),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_music), label: 'Library'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        ],
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
        title: Text('Create Playlist'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(hintText: 'Playlist Name'),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    selectedCoverMedia = await controller.pickCoverMedia();
                    if (selectedCoverMedia != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Media Selected')),
                      );
                    }
                  },
                  child: Text('Gallery'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    selectedCoverMedia = await controller.pickCoverMedia(fromCamera: true);
                    if (selectedCoverMedia != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Camera Photo Selected')),
                      );
                    }
                  },
                  child: Text('Camera'),
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
                  coverMedia: selectedCoverMedia
                );
                Get.back();
              } else {
                Get.snackbar('Error', 'Playlist name cannot be empty');
              }
            },
            child: Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showEditPlaylistDialog(
      BuildContext context, 
      PlaylistController controller, 
      String playlistId, 
      {String? currentName}) {
    final TextEditingController nameController = TextEditingController(text: currentName);
    File? selectedCoverMedia;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Playlist'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(hintText: 'New Playlist Name'),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    selectedCoverMedia = await controller.pickCoverMedia();
                    if (selectedCoverMedia != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Media Selected')),
                      );
                    }
                  },
                  child: Text('Gallery'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    selectedCoverMedia = await controller.pickCoverMedia(fromCamera: true);
                    if (selectedCoverMedia != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Camera Photo Selected')),
                      );
                    }
                  },
                  child: Text('Camera'),
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
                  newCoverMedia: selectedCoverMedia
                );
                Get.back();
              } else {
                Get.snackbar('Error', 'Playlist name cannot be empty');
              }
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }
}
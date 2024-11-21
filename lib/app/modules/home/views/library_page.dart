import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/playlist_controller.dart';
import 'home_view.dart';

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
        return ListView.builder(
          itemCount: playlistController.playlists.length,
          itemBuilder: (context, index) {
            final playlist = playlistController.playlists[index];
            return ListTile(
              title: Text(
                playlist['name'],
                style: TextStyle(color: Colors.white),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.grey),
                    onPressed: () {
                      _showEditPlaylistDialog(
                          context, playlistController, playlist['id']);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      playlistController.deletePlaylist(playlist['id']);
                    },
                  ),
                ],
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create Playlist'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(hintText: 'Playlist Name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.createPlaylist(nameController.text);
              Get.back();
            },
            child: Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showEditPlaylistDialog(BuildContext context,
      PlaylistController controller, String playlistId) {
    final TextEditingController nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Playlist'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(hintText: 'New Playlist Name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.editPlaylist(playlistId, nameController.text);
              Get.back();
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }
}

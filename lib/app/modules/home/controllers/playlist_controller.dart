import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class PlaylistController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final playlists = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPlaylists();
  }

  // Fetch all playlists
  void fetchPlaylists() async {
    final playlistSnapshot = await _firestore.collection('playlists').get();
    playlists.value = playlistSnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Create a new playlist
  Future<void> createPlaylist(String name) async {
    await _firestore.collection('playlists').add({'name': name});
    fetchPlaylists();
  }

  // Edit a playlist
  Future<void> editPlaylist(String id, String newName) async {
    await _firestore.collection('playlists').doc(id).update({'name': newName});
    fetchPlaylists();
  }

  // Delete a playlist
  Future<void> deletePlaylist(String id) async {
    await _firestore.collection('playlists').doc(id).delete();
    fetchPlaylists();
  }
}

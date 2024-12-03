import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class PlaylistController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _storage = GetStorage();
  final playlists = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPlaylists();
  }

  // Fetch all playlists
  void fetchPlaylists() async {
    try {
      final playlistSnapshot = await _firestore.collection('playlists').get();
      playlists.value = playlistSnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      // Save local copy to get_storage
      _storage.write('playlists', json.encode(playlists.value));
    } catch (e) {
      print('Error fetching playlists: $e');
      Get.snackbar('Error', 'Failed to fetch playlists');
    }
  }

  // Create a new playlist with optional cover
  Future createPlaylist(String name, {File? coverMedia}) async {
    try {
      String? localMediaPath;
      
      if (coverMedia != null) {
        // Save local copy of media
        localMediaPath = await saveLocalMedia(coverMedia);
      }

      final playlistData = {
        'name': name,
        'coverMediaPath': localMediaPath,
        'createdAt': DateTime.now().toIso8601String(),
      };

      // Save to Firestore
      DocumentReference docRef = await _firestore.collection('playlists').add(playlistData);
      playlistData['id'] = docRef.id;

      // Update local storage
      List<dynamic> currentPlaylists = json.decode(_storage.read('playlists') ?? '[]');
      currentPlaylists.add(playlistData);
      _storage.write('playlists', json.encode(currentPlaylists));
      
      fetchPlaylists();
    } catch (e) {
      print('Create playlist error: $e');
      Get.snackbar('Error', 'Failed to create playlist');
    }
  }

  // Save local copy of media (image or video)
  Future<String?> saveLocalMedia(File mediaFile) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'playlist_media_${DateTime.now().millisecondsSinceEpoch}${_getFileExtension(mediaFile)}';
      final localFile = File('${directory.path}/$fileName');
      await mediaFile.copy(localFile.path);
      return localFile.path;
    } catch (e) {
      print('Error saving local media: $e');
      Get.snackbar('Error', 'Failed to save media');
      return null;
    }
  }

  // Get file extension
  String _getFileExtension(File file) {
    return '.${file.path.split('.').last}';
  }

  // Pick media from device
  Future<File?> pickCoverMedia({bool fromCamera = false}) async {
    try {
      if (fromCamera) {
        final pickedFile = await ImagePicker().pickImage(
          source: ImageSource.camera,
          maxWidth: 1800,
          maxHeight: 1800,
        );
        return pickedFile != null ? File(pickedFile.path) : null;
      }

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.media,
        allowMultiple: false,
      );

      if (result != null) {
        return File(result.files.single.path!);
      }
      return null;
    } catch (e) {
      print('Error picking media: $e');
      Get.snackbar('Error', 'Failed to pick media');
      return null;
    }
  }

  // Edit a playlist with optional new cover media
  Future editPlaylist(String id, String newName, {File? newCoverMedia}) async {
    try {
      Map<String, dynamic> updateData = {'name': newName};
      String? newLocalMediaPath;
      
      if (newCoverMedia != null) {
        newLocalMediaPath = await saveLocalMedia(newCoverMedia);
        if (newLocalMediaPath == null) {
          Get.snackbar('Error', 'Failed to save media');
          return;
        }
        updateData['coverMediaPath'] = newLocalMediaPath;
      }

      // Update Firestore
      await _firestore.collection('playlists').doc(id).update(updateData);

      // Update local storage
      List<dynamic> currentPlaylists = json.decode(_storage.read('playlists') ?? '[]');
      int index = currentPlaylists.indexWhere((playlist) => playlist['id'] == id);
      if (index != -1) {
        currentPlaylists[index].addAll(updateData);
        _storage.write('playlists', json.encode(currentPlaylists));
      }

      fetchPlaylists();
    } catch (e) {
      print('Edit playlist error: $e');
      Get.snackbar('Error', 'Failed to edit playlist');
    }
  }

  // Delete a playlist
  Future deletePlaylist(String id) async {
    try {
      // Delete from Firestore
      await _firestore.collection('playlists').doc(id).delete();

      // Update local storage
      List<dynamic> currentPlaylists = json.decode(_storage.read('playlists') ?? '[]');
      currentPlaylists.removeWhere((playlist) => playlist['id'] == id);
      _storage.write('playlists', json.encode(currentPlaylists));

      fetchPlaylists();
    } catch (e) {
      print('Delete playlist error: $e');
      Get.snackbar('Error', 'Failed to delete playlist');
    }
  }

  // Retrieve local playlists (fallback method)
  List<dynamic> getLocalPlaylists() {
    final playlistsJson = _storage.read('playlists');
    return playlistsJson != null ? json.decode(playlistsJson) : [];
  }
}
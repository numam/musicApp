import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import '../views/NoConnectionView.dart';
import '../views/library_page.dart';

class PlaylistController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _storage = GetStorage();
  final playlists = <Map<String, dynamic>>[].obs;
  final isConnected = true.obs;

  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen((connectivityResult) {
      isConnected.value = connectivityResult != ConnectivityResult.none;
      _updateConnectionStatus();
    });
    _checkInitialConnection(); // Check initial connection status
    fetchPlaylists(); // Fetch playlists on init
  }

  // Check initial connection
  Future<void> _checkInitialConnection() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    isConnected.value = connectivityResult != ConnectivityResult.none;
    _updateConnectionStatus();
  }

  // Handle connection status updates
  void _updateConnectionStatus() {
    if (!isConnected.value) {
      Get.offAll(() => const NoConnectionView()); // Navigate to NoConnectionView if no connection
    } else {
      if (Get.currentRoute == '/NoConnectionView') {
        Get.offAll(() => const LibraryPage()); // Navigate to LibraryPage if connection is restored
      }
    }
  }

  // Fetch playlists
  void fetchPlaylists() async {
    try {
      if (!isConnected.value) {
        Get.snackbar("No Connection", "Cannot fetch playlists without internet");
        return;
      }

      final playlistSnapshot = await _firestore.collection('playlists').get();
      playlists.value = playlistSnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      // Save to local storage
      _storage.write('playlists', json.encode(playlists.value));
    } catch (e) {
      print('Error fetching playlists: $e');
      Get.snackbar('Error', 'Failed to fetch playlists');
    }
  }

  // Create a new playlist
  Future createPlaylist(String name, {File? coverMedia}) async {
    try {
      if (!isConnected.value) {
        Get.snackbar("No Connection", "Cannot create playlist without internet");
        return;
      }

      String? localMediaPath;
      if (coverMedia != null) {
        localMediaPath = await saveLocalMedia(coverMedia);
      }

      final playlistData = {
        'name': name,
        'coverMediaPath': localMediaPath,
        'createdAt': DateTime.now().toIso8601String(),
      };

      DocumentReference docRef =
          await _firestore.collection('playlists').add(playlistData);
      playlistData['id'] = docRef.id;

      playlists.add(playlistData);
    } catch (e) {
      print('Create playlist error: $e');
      Get.snackbar('Error', 'Failed to create playlist');
    }
  }

  // Edit an existing playlist
  Future editPlaylist(String id, String newName, {File? newCoverMedia}) async {
    try {
      if (!isConnected.value) {
        Get.snackbar("No Connection", "Cannot edit playlist without internet");
        return;
      }

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

      await _firestore.collection('playlists').doc(id).update(updateData);

      int index = playlists.indexWhere((playlist) => playlist['id'] == id);
      if (index != -1) {
        playlists[index].addAll(updateData);
        playlists.refresh();
      }
    } catch (e) {
      print('Edit playlist error: $e');
      Get.snackbar('Error', 'Failed to edit playlist');
    }
  }

  // Delete a playlist
  Future deletePlaylist(String id) async {
    try {
      if (!isConnected.value) {
        Get.snackbar("No Connection", "Cannot delete playlist without internet");
        return;
      }

      await _firestore.collection('playlists').doc(id).delete();
      playlists.removeWhere((playlist) => playlist['id'] == id);
    } catch (e) {
      print('Delete playlist error: $e');
      Get.snackbar('Error', 'Failed to delete playlist');
    }
  }

  // Save local copy of media
  Future<String?> saveLocalMedia(File mediaFile) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          'playlist_media_${DateTime.now().millisecondsSinceEpoch}${_getFileExtension(mediaFile)}';
      final localFile = File('${directory.path}/$fileName');
      await mediaFile.copy(localFile.path);
      return localFile.path;
    } catch (e) {
      print('Error saving local media: $e');
      return null;
    }
  }

  // Get file extension
  String _getFileExtension(File file) {
    return '.${file.path.split('.').last}';
  }

  // Pick media
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
      return null;
    }
  }
}

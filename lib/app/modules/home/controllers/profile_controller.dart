import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';

import '../views/view_story_page.dart';

class ProfileController extends GetxController {
  var profileImage = Rx<File?>(null); // Observing the profile image
  final ImagePicker _picker = ImagePicker(); // Image picker instance
  final GetStorage storage = GetStorage(); // Instance of Get Storage

  // Function to pick an image
  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        profileImage.value = File(pickedFile.path); // Update the image
      } else {
        Get.snackbar('Error', 'No image selected'); // Show error if no image selected
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image'); // Handle error while picking image
    }
  }

  // Function to show image source options (gallery or camera)
  void showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Pick from Gallery'),
                onTap: () {
                  pickImage(ImageSource.gallery); // Pick from gallery
                  Navigator.of(context).pop(); // Close the modal
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a Photo'),
                onTap: () {
                  pickImage(ImageSource.camera); // Pick from camera
                  Navigator.of(context).pop(); // Close the modal
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to log out the user
  Future<void> logOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // Sign out from Firebase
      Get.offAllNamed('/home'); // Navigate to HomeView
      Get.snackbar('Success', 'Logged out successfully'); // Show success message
    } catch (e) {
      Get.snackbar('Error', 'Failed to log out: ${e.toString()}'); // Show error message
      print('Error during logout: ${e.toString()}'); // Print error to console
    }
  }

  // Function to clear or delete the selected image
  void deleteImage() {
    profileImage.value = null; // Reset the profile image to null
  }

  // Function to create a story
  Future<void> createStory(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.video_library),
                title: Text('Pilih dari Galeri'),
                onTap: () {
                  _pickVideo(ImageSource.gallery, context);
                },
              ),
              ListTile(
                leading: Icon(Icons.videocam),
                title: Text('Rekam Video'),
                onTap: () {
                  _pickVideo(ImageSource.camera, context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void viewStory() {
    Get.to(() => ViewStoryPage());
  }

  // Function to pick a video
  Future<void> _pickVideo(ImageSource source, BuildContext context) async {
    try {
      final pickedFile = await _picker.pickVideo(source: source);
      if (pickedFile != null) {
        // Save the video path to Get Storage
        String videoPath = pickedFile.path;
        storage.write('last_video', videoPath);

        Get.snackbar('Berhasil', 'Video berhasil disimpan');
      } else {
        Get.snackbar('Error', 'Tidak ada video yang dipilih');
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil video: ${e.toString()}');
    } finally {
      Navigator.of(context).pop(); // Close the modal
    }
  }
}

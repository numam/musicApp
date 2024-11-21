import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

class ProfileController extends GetxController {
  var profileImage = Rx<File?>(null); // Observing the profile image
  final ImagePicker _picker = ImagePicker(); // Image picker instance

  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        profileImage.value = File(pickedFile.path); // Update image
      } else {
        Get.snackbar('Error', 'No image selected'); // Show error if no image selected
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image'); // Handle error while picking image
    }
  }

  // Function to show the image source options (gallery or camera)
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
}

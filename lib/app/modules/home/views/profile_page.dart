import 'package:apple_music/app/modules/home/views/location_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/profile_controller.dart';
import 'artist_detail_screen.dart'; // Import FirebaseAuth

class ProfilePage extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.white),
          onPressed: () {
            Get.back(); // Navigate back to the previous page
          },
        ),
        title: Text(
          'Akun Saya', style: TextStyle(color: Colors.white)
        ),
        
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Obx(
                () => GestureDetector(
                  onTap: () => profileController.showImageSourceActionSheet(context),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: profileController.profileImage.value != null
                        ? FileImage(profileController.profileImage.value!)
                        : AssetImage('assets/default_avatar.png') as ImageProvider,
                    child: profileController.profileImage.value == null
                        ? Icon(Icons.camera_alt, size: 50, color: Colors.white)
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => profileController.showImageSourceActionSheet(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Change button color to red
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: Text('Change Photo', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
              SizedBox(height: 20),
              Divider(color: Colors.grey.shade700),
              ListTile(
                title: Text(
                  'Redeem Gift Card or Code',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  // Action for redeem
                },
              ),
              ListTile(
                title: Text(
                  'Add Funds to Apple ID',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  // Action for add funds
                },
              ),
              ListTile(
                title: Text(
                  'Get 1 Month for US\$4.99',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Get.to(() => ArtistDetailScreen(), transition: Transition.noTransition);
                },
              ),
              Divider(color: Colors.grey.shade700),
              ListTile(
                title: Text(
                  'Notifications',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white,),
                onTap: () {
                  // Navigate to Notifications page
                },
              ),
              ListTile(
                title: Text(
                  'Buat Story',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white,),
                onTap: () {
                  profileController.createStory(context); // Panggil fungsi createStory
                },
              ),

              ListTile(
                title: Text(
                  'Lihat Story',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white,),
                onTap: () {
                  profileController.viewStory(); // Panggil fungsi untuk navigasi ke halaman "Lihat Story"
                },
              ),

              Divider(color: Colors.grey.shade700),
              ListTile(
                title: Text(
                  'Log Out',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  profileController.logOut(context); // Call the logOut method
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

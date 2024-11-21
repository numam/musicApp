import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

import '../controllers/profile_controller.dart'; // Import FirebaseAuth

class ProfilePage extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Navigate back to the previous page
            },
            child: Text(
              'Done',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
        ],
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
                child: Text('Change Photo', style: TextStyle(fontSize: 16)),
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
                  // Action for subscription
                },
              ),
              Divider(color: Colors.grey.shade700),
              ListTile(
                title: Text('Notifications'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to Notifications page
                },
              ),
              Divider(color: Colors.grey.shade700),
              ListTile(
                title: Text(
                  'Log Out',
                  style: TextStyle(color: Colors.red),
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

import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class SearchController extends GetxController {
  // Speech to text instance
  final stt.SpeechToText speech = stt.SpeechToText();
  
  // Observable variables
  var isListening = false.obs;
  var searchText = ''.obs;
  var isSpeechEnabled = false.obs;
  
  // TextEditingController for the search field
  late TextEditingController searchTextController;

  @override
  void onInit() {
    super.onInit();
    // Initialize TextEditingController
    searchTextController = TextEditingController();
    initSpeechState();
    
    // Add listener to update searchText when text changes
    searchTextController.addListener(() {
      searchText.value = searchTextController.text;
    });
  }

  @override
  void onClose() {
    // Dispose of the controller when the controller is closed
    searchTextController.dispose();
    super.onClose();
  }

  // Initialize speech to text with error handling
  Future<void> initSpeechState() async {
    try {
      var hasSpeech = await speech.initialize(
        onError: (error) => print('Error: $error'),
        onStatus: (status) => print('Status: $status'),
      );
      
      isSpeechEnabled.value = hasSpeech;
    } catch (e) {
      isSpeechEnabled.value = false;
      print('Failed to initialize speech: $e');
    }
  }

  // Request microphone permission with error handling
  Future<void> requestMicPermission() async {
    try {
      var status = await Permission.microphone.status;
      if (status.isDenied) {
        await Permission.microphone.request();
      }
    } catch (e) {
      print('Error requesting microphone permission: $e');
    }
  }

  // Start speech to text with error handling
  Future<void> startListening() async {
    try {
      await requestMicPermission();
      
      if (isSpeechEnabled.value) {
        isListening.value = true;
        
        await speech.listen(
          onResult: (result) {
            searchText.value = result.recognizedWords;
            // Update TextEditingController
            searchTextController.text = searchText.value;
            // Move cursor to end of text
            searchTextController.selection = TextSelection.fromPosition(
              TextPosition(offset: searchTextController.text.length),
            );
          },
          localeId: "id_ID", // Use Indonesian language
          cancelOnError: true,
          partialResults: true,
        );
      } else {
        print('Speech recognition not available');
      }
    } catch (e) {
      print('Error starting speech recognition: $e');
      isListening.value = false;
    }
  }

  // Stop speech to text with error handling
  Future<void> stopListening() async {
    try {
      if (isListening.value) {
        await speech.stop();
        isListening.value = false;
      }
    } catch (e) {
      print('Error stopping speech recognition: $e');
      isListening.value = false;
    }
  }

  // Clear search text
  void clearSearch() {
    searchTextController.clear();
    searchText.value = '';
  }

  // Update search text manually (for keyboard input)
  void updateSearchText(String value) {
    searchText.value = value;
    // Only update controller if the value is different to avoid cursor jumping
    if (searchTextController.text != value) {
      searchTextController.text = value;
    }
  }
}
import 'package:get/get.dart';

class BottomNavController extends GetxController {
  var currentIndex = 2.obs; // Set initial index to the Library tab

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}

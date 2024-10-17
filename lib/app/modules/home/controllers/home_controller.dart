import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeController extends GetxController {
  // Variabel untuk menyimpan data lagu
  var songs = <dynamic>[].obs; // Gunakan <dynamic> untuk mendefinisikan tipe data
  var isLoading = false.obs;
  
  // Variabel penghitung, dapat digunakan sesuai kebutuhan
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Panggil API saat controller diinisialisasi
    fetchDeezerTracks();
  }

  @override
  void onReady() {
    super.onReady();
    // Lakukan aksi tambahan setelah controller siap
  }

  @override
  void onClose() {
    super.onClose();
    // Lakukan pembersihan jika perlu
  }

  // Fungsi untuk mengambil lagu dari API Deezer
  Future<void> fetchDeezerTracks() async {
    isLoading(true);
    final url = 'https://api.deezer.com/chart';  // API Deezer untuk mendapatkan chart musik
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        songs.value = data['tracks']['data'];  // Menyimpan daftar lagu
      } else {
        Get.snackbar("Error", "Failed to fetch data from Deezer API");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading(false);
    }
  }

  // Fungsi untuk increment count
  void increment() => count.value++;
}

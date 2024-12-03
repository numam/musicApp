import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../views/player_page.dart';

class HomeController extends GetxController {
  var songs = <dynamic>[].obs;
  var trendingSongs = <dynamic>[].obs;
  var popSongs = <dynamic>[].obs;
  var rockSongs = <dynamic>[].obs;
  var genres = <dynamic>[].obs;
  var isLoading = false.obs;
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllSongs();
    fetchGenres();
  }

  // Fetch songs from multiple Deezer API endpoints
  Future<void> fetchAllSongs() async {
    isLoading(true);
    try {
      // Fetch chart tracks
      await fetchDeezerTracks();
      
      // Fetch trending tracks
      await fetchTrendingTracks();
      
      // Fetch genre-specific tracks
      await fetchGenreTracks('pop');
      await fetchGenreTracks('rock');
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch songs: $e");
    } finally {
      isLoading(false);
    }
  }

  // Fetch chart tracks
  Future<void> fetchDeezerTracks() async {
    final url = 'https://api.deezer.com/chart/0/tracks';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        songs.value = data['data'];
      }
    } catch (e) {
      print('Error fetching chart tracks: $e');
    }
  }

  // Fetch trending tracks
  Future<void> fetchTrendingTracks() async {
    final url = 'https://api.deezer.com/chart/0/tracks?limit=20';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        trendingSongs.value = data['data'];
      }
    } catch (e) {
      print('Error fetching trending tracks: $e');
    }
  }

  // Fetch genre-specific tracks
  Future<void> fetchGenreTracks(String genre) async {
    final url = 'https://api.deezer.com/search?q=genre:"$genre"&limit=20';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (genre == 'pop') {
          popSongs.value = data['data'];
        } else if (genre == 'rock') {
          rockSongs.value = data['data'];
        }
      }
    } catch (e) {
      print('Error fetching $genre tracks: $e');
    }
  }

  // Fetch radio genres
  Future<void> fetchGenres() async {
    final url = 'https://api.deezer.com/radio/genres';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        genres.value = data['data'];
      }
    } catch (e) {
      print('Error fetching genres: $e');
    }
  }

  // Navigate to player page
  void playTrack(dynamic trackData) {
    Get.to(() => PlayerPage(trackData: trackData), 
      transition: Transition.rightToLeft
    );
  }

  // Optional: Method to get preview URL
  String? getTrackPreviewUrl(dynamic trackData) {
    return trackData['preview'] ?? null;
  }
}
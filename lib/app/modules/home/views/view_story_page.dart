import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:io';

class ViewStoryPage extends StatefulWidget {
  @override
  _ViewStoryPageState createState() => _ViewStoryPageState();
}

class _ViewStoryPageState extends State<ViewStoryPage> {
  VideoPlayerController? _videoPlayerController;
  String? videoPath;

  @override
  void initState() {
    super.initState();
    final storage = GetStorage();

    // Baca video path dari Get Storage
    videoPath = storage.read<String>('last_video');

    if (videoPath != null) {
      _videoPlayerController = VideoPlayerController.file(File(videoPath!))
        ..initialize().then((_) {
          setState(() {});
          _videoPlayerController!.play(); // Autoplay video
        });
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lihat Story'),
      ),
      body: videoPath != null
          ? Center(
              child: _videoPlayerController != null &&
                      _videoPlayerController!.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _videoPlayerController!.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController!),
                    )
                  : CircularProgressIndicator(),
            )
          : Center(
              child: Text(
                'Belum ada story yang dibuat.',
                style: TextStyle(fontSize: 18),
              ),
            ),
      floatingActionButton: _videoPlayerController != null
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  if (_videoPlayerController!.value.isPlaying) {
                    _videoPlayerController!.pause();
                  } else {
                    _videoPlayerController!.play();
                  }
                });
              },
              child: Icon(
                _videoPlayerController!.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
              ),
            )
          : null,
    );
  }
}

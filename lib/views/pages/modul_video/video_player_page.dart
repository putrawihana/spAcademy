import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/constans.dart';
import 'package:flutter_application_2/views/widgets/container/container_mentor.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoPath;
  final String judul;
  final String level;
  final String ringakasan;
  const VideoPlayerPage({
    super.key,
    required this.videoPath,
    required this.judul,
    required this.level,
    required this.ringakasan,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  ChewieController? _chewieController;

  @override
  void initState() {
    initializePlayer();
    super.initState();
  }

  Future<void> initializePlayer() async {
    _controller = VideoPlayerController.asset(widget.videoPath);
    try {
      await _controller.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _controller,
        autoPlay: false,
        looping: false,
        showOptions: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.red,
          handleColor: Colors.red,
          bufferedColor: Colors.grey,
          backgroundColor: Colors.black,
        ),
      );
      setState(() {});
    } catch (e) {
      print('gagal initsilasi video : $e');
    }
  }

  String formatDurasi(Duration durasi) {
    String duaDigit(int n) => n.toString().padLeft(2, '0');
    String menit = duaDigit(durasi.inMinutes.remainder(60));
    String detik = duaDigit(durasi.inSeconds.remainder(60));
    return "$menit:$detik";
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            child:
                _chewieController != null &&
                    _chewieController!.videoPlayerController.value.isInitialized
                ? Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey, width: 0.8),
                        bottom: BorderSide(color: Colors.grey, width: 0.8),
                      ),
                    ),
                    child: AspectRatio(
                      aspectRatio: 16 / 8,
                      child: Chewie(controller: _chewieController!),
                    ),
                  )
                : const CircularProgressIndicator(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.level),
                    Text(
                      formatDurasi(_controller.value.duration),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                Text(
                  widget.judul,
                  style: KTextStyle.normalText(warna: Colors.white),
                ),
                SizedBox(height: 20),
                ContainerMentor(),
                SizedBox(height: 20),
                Text(widget.ringakasan),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

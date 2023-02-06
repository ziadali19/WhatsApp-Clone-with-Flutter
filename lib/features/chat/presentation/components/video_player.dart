import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class VideosPlayer extends StatefulWidget {
  const VideosPlayer({super.key, required this.message});
  final String message;
  @override
  State<VideosPlayer> createState() => _VideosPlayerState();
}

class _VideosPlayerState extends State<VideosPlayer> {
  late VideoPlayerController controller;
  bool isPlay = false;
  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.network(
      widget.message,
    )..initialize().then((value) {
        controller.setVolume(1);
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Stack(
        alignment: AlignmentDirectional.topStart,
        children: [
          VideoPlayer(controller),
          IconButton(
              onPressed: () {
                setState(() {
                  isPlay = !isPlay;
                });
                if (isPlay) {
                  controller.play();
                } else {
                  controller.pause();
                }
              },
              icon: isPlay == false
                  ? Icon(
                      Icons.play_circle_rounded,
                      size: 40.sp,
                    )
                  : Icon(Icons.pause_circle_rounded, size: 40.sp))
        ],
      ),
    );
  }
}

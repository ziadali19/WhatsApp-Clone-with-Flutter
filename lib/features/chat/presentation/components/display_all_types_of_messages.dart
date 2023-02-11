import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/features/chat/presentation/components/video_player.dart';

import '../../../../core/common/enums/messgae_enum.dart';

Widget displayAllTypesOfMEssages(String messages, MessageEnum messageEnum) {
  bool isPlaying = false;
  final AudioPlayer audioPlayer = AudioPlayer();
  return messageEnum == MessageEnum.image
      ? CachedNetworkImage(imageUrl: messages)
      : messageEnum == MessageEnum.video
          ? VideosPlayer(
              message: messages,
            )
          : messageEnum == MessageEnum.gif
              ? CachedNetworkImage(imageUrl: messages)
              : messageEnum == MessageEnum.audio
                  ? StatefulBuilder(
                      builder: (BuildContext context,
                          void Function(void Function()) setState) {
                        return IconButton(
                            constraints: BoxConstraints(minWidth: 100.w),
                            onPressed: () async {
                              if (isPlaying) {
                                await audioPlayer.pause();
                                setState(
                                  () {
                                    isPlaying = false;
                                  },
                                );
                              } else {
                                await audioPlayer.play(UrlSource(messages));
                                setState(
                                  () {
                                    isPlaying = true;
                                  },
                                );
                              }
                            },
                            icon: Icon(
                              isPlaying
                                  ? Icons.pause_circle_rounded
                                  : Icons.play_circle_rounded,
                              size: 35.sp,
                            ));
                      },
                    )
                  : Text(
                      messages,
                      style: TextStyle(
                        fontSize: 16.sp,
                      ),
                    );
}

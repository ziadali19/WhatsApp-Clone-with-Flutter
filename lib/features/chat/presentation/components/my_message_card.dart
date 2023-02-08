import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsapp_clone/core/common/enums/messgae_enum.dart';
import 'package:whatsapp_clone/core/utilis/constants.dart';
import 'package:whatsapp_clone/features/chat/presentation/components/video_player.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum messageEnum;
  const MyMessageCard(
      {Key? key,
      required this.message,
      required this.date,
      required this.messageEnum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    AudioPlayer audioPlayer = AudioPlayer();
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 150.w,
          maxWidth: MediaQuery.of(context).size.width - 45.w,
        ),
        child: Card(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          color: AppConstants.messageColor,
          margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
          child: Stack(
            children: [
              Padding(
                padding: messageEnum == MessageEnum.image ||
                        messageEnum == MessageEnum.video ||
                        messageEnum == MessageEnum.gif
                    ? EdgeInsets.only(
                        left: 10.w,
                        right: 10.w,
                        top: 10.h,
                        bottom: 25.h,
                      )
                    : messageEnum == MessageEnum.audio
                        ? EdgeInsets.only(
                            left: 10.w,
                            right: 10.w,
                            top: 10.h,
                            bottom: 30.h,
                          )
                        : EdgeInsets.only(
                            left: 10.w,
                            right: 30.w,
                            top: 5.h,
                            bottom: 20.h,
                          ),
                child: messageEnum == MessageEnum.image
                    ? CachedNetworkImage(imageUrl: message)
                    : messageEnum == MessageEnum.video
                        ? VideosPlayer(
                            message: message,
                          )
                        : messageEnum == MessageEnum.gif
                            ? CachedNetworkImage(imageUrl: message)
                            : messageEnum == MessageEnum.audio
                                ? StatefulBuilder(
                                    builder: (BuildContext context,
                                        void Function(void Function())
                                            setState) {
                                      return IconButton(
                                          constraints:
                                              BoxConstraints(minWidth: 100.w),
                                          onPressed: () async {
                                            if (isPlaying) {
                                              await audioPlayer.pause();
                                              setState(
                                                () {
                                                  isPlaying = false;
                                                },
                                              );
                                            } else {
                                              await audioPlayer
                                                  .play(UrlSource(message));
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
                                    message,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                    ),
                                  ),
              ),
              Positioned(
                bottom: 4.h,
                right: 10.w,
                child: Row(
                  children: [
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.white60,
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Icon(
                      Icons.done_all,
                      size: 20.sp,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

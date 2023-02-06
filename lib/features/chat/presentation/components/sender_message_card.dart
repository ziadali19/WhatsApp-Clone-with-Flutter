import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/core/common/enums/messgae_enum.dart';
import 'package:whatsapp_clone/core/utilis/constants.dart';
import 'package:whatsapp_clone/features/chat/presentation/components/video_player.dart';

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.messageEnum,
  }) : super(key: key);
  final String message;
  final String date;
  final MessageEnum messageEnum;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 150.w,
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          color: AppConstants.senderMessageColor,
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
                            : Text(
                                message,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                ),
                              ),
              ),
              Positioned(
                bottom: 2.h,
                right: 10.w,
                child: Text(
                  date,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

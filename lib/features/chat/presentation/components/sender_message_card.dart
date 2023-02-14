import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whatsapp_clone/core/common/enums/messgae_enum.dart';
import 'package:whatsapp_clone/core/utilis/constants.dart';
import 'package:whatsapp_clone/features/chat/controller/cubit/chat_cubit.dart';
import 'package:whatsapp_clone/features/chat/presentation/components/display_all_types_of_messages.dart';
import 'package:whatsapp_clone/features/chat/presentation/components/video_player.dart';

class SenderMessageCard extends StatelessWidget {
  SenderMessageCard(
      {Key? key,
      required this.message,
      required this.date,
      required this.messageEnum,
      required this.replyOnMessageType,
      required this.replyOnUserName,
      required this.replyOn})
      : super(key: key);
  String replyOn;
  final MessageEnum replyOnMessageType;
  final String replyOnUserName;
  final String message;
  final String date;
  final MessageEnum messageEnum;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        switch (replyOnMessageType) {
          case MessageEnum.image:
            replyOn = '📷 Photo';
            break;
          case MessageEnum.video:
            replyOn = '📷 Video';
            break;
          case MessageEnum.audio:
            replyOn = '🎵 Audio';
            break;
          case MessageEnum.gif:
            replyOn = '📷 GIF';
            break;
          case MessageEnum.text:
            replyOn = replyOn;
            break;
          default:
            replyOn = '';
        }
        return SwipeTo(
          onRightSwipe: () {
            ChatCubit.get(context).swipeToReply(message, messageEnum, false);
          },
          child: Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 150.w,
                maxWidth: MediaQuery.of(context).size.width - 45,
              ),
              child: Container(
                padding: EdgeInsets.all(2.h),
                margin: EdgeInsets.all(5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: AppConstants.senderMessageColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    replyOn.isNotEmpty
                        ? Container(
                            constraints: BoxConstraints(
                              minWidth: 150.w,
                              maxWidth:
                                  MediaQuery.of(context).size.width - 45.w,
                            ),
                            padding: EdgeInsets.all(8.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: AppConstants.messageColor,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  replyOnUserName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: AppConstants.tabColor),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  replyOn,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Colors.grey[500], fontSize: 15.sp),
                                )
                              ],
                            ),
                          )
                        : const SizedBox(),
                    Container(
                      constraints: BoxConstraints(
                        minWidth: 150.w,
                        maxWidth: MediaQuery.of(context).size.width - 45.w,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: AppConstants.senderMessageColor,
                      ),
                      margin: EdgeInsets.symmetric(vertical: 5.h),
                      child: Stack(
                        children: [
                          Padding(
                            padding: messageEnum == MessageEnum.image ||
                                    messageEnum == MessageEnum.video ||
                                    messageEnum == MessageEnum.gif
                                ? EdgeInsets.only(
                                    left: 8.w,
                                    right: 8.w,
                                    top: 8.h,
                                    bottom: 23.h,
                                  )
                                : messageEnum == MessageEnum.audio
                                    ? EdgeInsets.only(
                                        left: 8.w,
                                        right: 8.w,
                                        top: 8.h,
                                        bottom: 28.h,
                                      )
                                    : EdgeInsets.only(
                                        left: 8.w,
                                        right: 28.w,
                                        top: 3.h,
                                        bottom: 25.h,
                                      ),
                            child:
                                displayAllTypesOfMEssages(message, messageEnum),
                          ),
                          Positioned(
                            bottom: 2.h,
                            right: 8.w,
                            child: Row(
                              children: [
                                Text(
                                  date,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.white60,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

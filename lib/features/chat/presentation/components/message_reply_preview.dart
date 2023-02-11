import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:whatsapp_clone/features/chat/presentation/components/display_all_types_of_messages.dart';

import '../../../../core/common/enums/messgae_enum.dart';
import '../../../../core/utilis/constants.dart';
import '../../controller/cubit/chat_cubit.dart';

class MessageReplyPreview extends StatelessWidget {
  const MessageReplyPreview({
    super.key,
    required this.name,
  });
  final String name;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        ChatCubit cubit = ChatCubit.get(context);
        late String message;
        switch (cubit.messageType) {
          case MessageEnum.image:
            message = '📷 Photo';
            break;
          case MessageEnum.video:
            message = '📷 Video';
            break;
          case MessageEnum.audio:
            message = '🎵 Audio';
            break;
          case MessageEnum.gif:
            message = '📷 GIF';
            break;
          case MessageEnum.text:
            message = cubit.message!;
            break;
          default:
            message = '';
        }
        return Padding(
          padding: EdgeInsets.only(left: 0.w, bottom: 5.h),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: EdgeInsets.all(8.h),
            decoration: BoxDecoration(
              color: AppConstants.mobileChatBoxColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: AppConstants.backgroundColor,
              ),
              child: Padding(
                padding: EdgeInsets.all(10.0.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.80,
                      child: Row(
                        children: [
                          Text(
                            cubit.isMe! ? 'You' : name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppConstants.tabColor),
                          ),
                          const Spacer(),
                          GestureDetector(
                            child: Icon(
                              Icons.cancel_rounded,
                              size: 20.sp,
                            ),
                            onTap: () {
                              ChatCubit.get(context).cancelReply();
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5.h),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text(
                        message,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style:
                            TextStyle(color: Colors.grey[500], fontSize: 15.sp),
                      ),
                    )
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

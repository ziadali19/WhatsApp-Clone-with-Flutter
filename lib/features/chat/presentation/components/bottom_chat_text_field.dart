import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/features/auth/data/model/user_model.dart';
import 'package:whatsapp_clone/features/chat/controller/cubit/chat_cubit.dart';

import '../../../../core/utilis/constants.dart';

class BottomChatTextField extends StatefulWidget {
  const BottomChatTextField({
    super.key,
    required this.recieverId,
  });
  final String recieverId;
  @override
  State<BottomChatTextField> createState() => _BottomChatTextFieldState();
}

class _BottomChatTextFieldState extends State<BottomChatTextField> {
  bool isThereAText = false;
  TextEditingController messageController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is SendMessageError) {
          AppConstants.showSnackBar(state.message, context, Colors.red);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(left: 5.w, bottom: 5.h),
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: TextField(
                  controller: messageController,
                  onChanged: (value) {
                    if (value.trim().isNotEmpty) {
                      setState(() {
                        isThereAText = true;
                      });
                    } else {
                      setState(() {
                        isThereAText = false;
                      });
                    }
                  },
                  cursorColor: AppConstants.tabColor,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppConstants.mobileChatBoxColor,
                    prefixIcon: SizedBox(
                      width: 100.w,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              child: const Icon(
                                Icons.emoji_emotions_rounded,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            GestureDetector(
                              child: const Icon(
                                Icons.gif,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    suffixIcon: SizedBox(
                      width: 100.w,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            GestureDetector(
                              child: const Icon(
                                Icons.attach_file,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    hintText: 'Type a message!',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0.r),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(10.h),
                  ),
                ),
              ),
              Expanded(
                child: RawMaterialButton(
                  constraints: BoxConstraints(minWidth: 100.w, minHeight: 45.h),
                  shape: const CircleBorder(),
                  fillColor: AppConstants.tabColor,
                  onPressed: () {
                    if (messageController.text.trim().isNotEmpty) {
                      ChatCubit.get(context).sendTextMessage(
                          senderUser: ChatCubit.get(context).userModel!,
                          recieverId: widget.recieverId,
                          text: messageController.text.trim());
                      messageController.text = '';
                    }
                  },
                  child: Icon(isThereAText == true
                      ? Icons.send_rounded
                      : Icons.mic_rounded),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

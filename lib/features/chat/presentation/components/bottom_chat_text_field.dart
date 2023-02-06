// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_clone/core/common/enums/messgae_enum.dart';
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
  FocusNode focusNode = FocusNode();
  bool emoji = false;
  bool isThereAText = false;
  TextEditingController messageController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  showEmojis() {
    setState(() {
      emoji = true;
    });
  }

  hideEmojis() {
    setState(() {
      emoji = false;
    });
  }

  File? imagePicked;
  File? videoPicked;
  imagePicker() async {
    imagePicked = await AppConstants.imagePicker(context);
  }

  videoPicker() async {
    videoPicked = await AppConstants.videoPicker(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is SendMessageError) {
          AppConstants.showSnackBar(state.message, context, Colors.red);
        }
        if (state is SendFileError) {
          AppConstants.showSnackBar(state.message, context, Colors.red);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(left: 5.w, bottom: 5.h),
          child: Column(
            children: [
              Row(
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
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppConstants.mobileChatBoxColor,
                        prefixIcon: SizedBox(
                          width: 100.w,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                emoji == false
                                    ? InkWell(
                                        onTap: () {
                                          focusNode.unfocus();
                                          showEmojis();
                                        },
                                        child: const Icon(
                                          Icons.emoji_emotions_rounded,
                                          color: Colors.grey,
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          hideEmojis();
                                          focusNode.requestFocus();
                                        },
                                        child: const Icon(
                                          Icons.keyboard_alt_outlined,
                                          color: Colors.grey,
                                        ),
                                      ),
                                SizedBox(
                                  width: 20.w,
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
                            padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    await imagePicker();
                                    if (imagePicked != null) {
                                      ChatCubit.get(context).sendFileMessage(
                                          senderUser:
                                              ChatCubit.get(context).userModel!,
                                          receiverId: widget.recieverId,
                                          file: imagePicked!,
                                          messageType: MessageEnum.image,
                                          context: context);
                                    }
                                  },
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                                InkWell(
                                  onTap: () async {
                                    await videoPicker();
                                    if (videoPicked != null) {
                                      ChatCubit.get(context).sendFileMessage(
                                          senderUser:
                                              ChatCubit.get(context).userModel!,
                                          receiverId: widget.recieverId,
                                          file: videoPicked!,
                                          messageType: MessageEnum.video,
                                          context: context);
                                    }
                                  },
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
                  state is SendFileLoading
                      ? Padding(
                          padding: EdgeInsets.only(left: 10.w),
                          child: const CircularProgressIndicator(
                            color: AppConstants.tabColor,
                          ),
                        )
                      : Expanded(
                          child: RawMaterialButton(
                            constraints: BoxConstraints(
                                minWidth: 100.w, minHeight: 45.h),
                            shape: const CircleBorder(),
                            fillColor: AppConstants.tabColor,
                            onPressed: () {
                              if (messageController.text.trim().isNotEmpty) {
                                ChatCubit.get(context).sendTextMessage(
                                    senderUser:
                                        ChatCubit.get(context).userModel!,
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
              emoji
                  ? SizedBox(
                      height: 310.h,
                      child: EmojiPicker(
                        onEmojiSelected: (category, emoji) {
                          messageController.text =
                              messageController.text + emoji.emoji;
                        },
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        );
      },
    );
  }
}

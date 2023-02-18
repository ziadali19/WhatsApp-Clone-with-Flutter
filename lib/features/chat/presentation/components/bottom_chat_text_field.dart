// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:giphy_get/giphy_get.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_clone/core/common/enums/messgae_enum.dart';

import 'package:whatsapp_clone/features/chat/controller/cubit/chat_cubit.dart';

import 'package:whatsapp_clone/features/chat/presentation/components/message_reply_preview.dart';

import '../../../../core/utilis/constants.dart';

class BottomChatTextField extends StatefulWidget {
  const BottomChatTextField({
    super.key,
    this.recieverId,
    required this.receiverName,
    required this.isGroupChat,
    this.groupId,
  });
  final String? recieverId;
  final bool isGroupChat;
  final String? groupId;
  final String receiverName;
  @override
  State<BottomChatTextField> createState() => _BottomChatTextFieldState();
}

class _BottomChatTextFieldState extends State<BottomChatTextField> {
  File? imagePicked;
  File? videoPicked;
  GiphyGif? gifPicked;
  FocusNode focusNode = FocusNode();
  bool emoji = false;
  bool isThereAText = false;
  TextEditingController messageController = TextEditingController();
  FlutterSoundRecorder? soundRecorder;
  bool isRecordInit = false;
  bool isRecording = false;
  @override
  void initState() {
    super.initState();
    soundRecorder = FlutterSoundRecorder();
    openRecoder();
  }

  @override
  void dispose() async {
    super.dispose();
    messageController.dispose();
    await soundRecorder!.closeRecorder();
    isRecordInit = false;
  }

  openRecoder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      AppConstants.showSnackBar(
          'Microphone permission is required', context, Colors.red);
    } else {
      await soundRecorder!.openRecorder();
      isRecordInit = true;
    }
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

  imagePicker() async {
    imagePicked = await AppConstants.imagePicker(context);
  }

  gifPicker() async {
    gifPicked = await AppConstants.gifPicker(context);
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
        ChatCubit cubit = ChatCubit.get(context);
        return Padding(
          padding: EdgeInsets.only(left: 5.w, bottom: 5.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ChatCubit.get(context).message != null
                  ? MessageReplyPreview(name: widget.receiverName)
                  : const SizedBox(),
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
                                InkWell(
                                  onTap: () async {
                                    await gifPicker();
                                    if (gifPicked != null) {
                                      ChatCubit.get(context).sendGifMessage(
                                          isGroupChat: widget.isGroupChat,
                                          senderUser:
                                              ChatCubit.get(context).userModel!,
                                          recieverId: widget.isGroupChat
                                              ? widget.groupId!
                                              : widget.recieverId!,
                                          text: gifPicked!.url!,
                                          replyOn: cubit.message ?? '',
                                          replyOnMessageType:
                                              cubit.messageType ??
                                                  MessageEnum.text,
                                          replyOnUserName: cubit.isMe == true
                                              ? cubit.userModel!.name!
                                              : cubit.isMe == false
                                                  ? widget.receiverName
                                                  : '');
                                    }
                                  },
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
                                          isGroupChat: widget.isGroupChat,
                                          senderUser:
                                              ChatCubit.get(context).userModel!,
                                          receiverId: widget.recieverId!,
                                          file: imagePicked!,
                                          messageType: MessageEnum.image,
                                          context: context,
                                          replyOn: cubit.message ?? '',
                                          replyOnMessageType:
                                              cubit.messageType ??
                                                  MessageEnum.text,
                                          replyOnUserName: cubit.isMe == true
                                              ? cubit.userModel!.name!
                                              : cubit.isMe == false
                                                  ? widget.receiverName
                                                  : '');
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
                                          isGroupChat: widget.isGroupChat,
                                          senderUser:
                                              ChatCubit.get(context).userModel!,
                                          receiverId: widget.isGroupChat
                                              ? widget.groupId!
                                              : widget.recieverId!,
                                          file: videoPicked!,
                                          messageType: MessageEnum.video,
                                          context: context,
                                          replyOn: cubit.message ?? '',
                                          replyOnMessageType:
                                              cubit.messageType ??
                                                  MessageEnum.text,
                                          replyOnUserName: cubit.isMe == true
                                              ? cubit.userModel!.name!
                                              : cubit.isMe == false
                                                  ? widget.receiverName
                                                  : '');
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
                            onPressed: () async {
                              if (messageController.text.trim().isNotEmpty) {
                                await ChatCubit.get(context).sendTextMessage(
                                    isGroupChat: widget.isGroupChat,
                                    senderUser:
                                        ChatCubit.get(context).userModel!,
                                    recieverId: widget.isGroupChat
                                        ? widget.groupId!
                                        : widget.recieverId!,
                                    text: messageController.text.trim(),
                                    replyOn: cubit.message ?? '',
                                    replyOnMessageType:
                                        cubit.messageType ?? MessageEnum.text,
                                    replyOnUserName: cubit.isMe == true
                                        ? cubit.userModel!.name!
                                        : cubit.isMe == false
                                            ? widget.receiverName
                                            : '');
                                if (cubit.message != null) {
                                  cubit.cancelReply();
                                }
                                messageController.text = '';
                                if (messageController.text.trim().isNotEmpty) {
                                  setState(() {
                                    isThereAText = true;
                                  });
                                } else {
                                  setState(() {
                                    isThereAText = false;
                                  });
                                }
                              } else {
                                if (!isRecordInit) {
                                  return;
                                }
                                Directory tempDirectory =
                                    await getTemporaryDirectory();
                                String path =
                                    '${tempDirectory.path}/flutter_sound.aac';
                                if (isRecording) {
                                  await soundRecorder!.stopRecorder();
                                  await ChatCubit.get(context).sendFileMessage(
                                      isGroupChat: widget.isGroupChat,
                                      senderUser:
                                          ChatCubit.get(context).userModel!,
                                      receiverId: widget.isGroupChat
                                          ? widget.groupId!
                                          : widget.recieverId!,
                                      file: File(path),
                                      messageType: MessageEnum.audio,
                                      context: context,
                                      replyOn: cubit.message ?? '',
                                      replyOnMessageType:
                                          cubit.messageType ?? MessageEnum.text,
                                      replyOnUserName: cubit.isMe == true
                                          ? cubit.userModel!.name!
                                          : cubit.isMe == false
                                              ? widget.receiverName
                                              : '');
                                  if (cubit.message != null) {
                                    cubit.cancelReply();
                                  }
                                } else {
                                  await soundRecorder!
                                      .startRecorder(toFile: path);
                                }
                                setState(() {
                                  isRecording = !isRecording;
                                });
                              }
                            },
                            child: Icon(isThereAText == true
                                ? Icons.send_rounded
                                : isRecording
                                    ? Icons.stop_rounded
                                    : Icons.mic_rounded),
                          ),
                        ),
                ],
              ),
              emoji
                  ? SizedBox(
                      height: 310.h,
                      child: EmojiPicker(
                        textEditingController: messageController,
                        onEmojiSelected: (category, emoji) {
                          if (messageController.text.trim().isNotEmpty) {
                            setState(() {
                              isThereAText = true;
                            });
                          } else {
                            setState(() {
                              isThereAText = false;
                            });
                          }
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

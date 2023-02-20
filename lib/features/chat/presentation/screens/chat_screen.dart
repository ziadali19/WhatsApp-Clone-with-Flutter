import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/core/utilis/constants.dart';
import 'package:whatsapp_clone/features/auth/data/model/user_model.dart';

import '../../../../core/services/service_locator.dart';
import '../../../call/controller/cubit/call_cubit.dart';
import '../../controller/cubit/chat_cubit.dart';
import '../../controller/cubit/text_field_cubit.dart';
import '../components/bottom_chat_text_field.dart';
import '../components/chat_list.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({
    super.key,
    required this.uID,
    required this.name,
    required this.profilePic,
    required this.isGroupChat,
  });
  final String? uID;

  final String? name;
  final String? profilePic;
  final bool isGroupChat;

  static const routeName = '/chat-screen';
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ChatCubit>()..getUserData()),
        BlocProvider(create: (context) => sl<TextFieldCubit>()..getUserData())
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppConstants.appBarColor,
          title: BlocConsumer<ChatCubit, ChatState>(
            listener: (context, state) {
              if (state is GetUserDataForChatError) {
                AppConstants.showSnackBar(state.message, context, Colors.red);
              }
            },
            builder: (context, state) {
              ChatCubit cubit = ChatCubit.get(context);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name!,
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 17.sp)),
                  isGroupChat
                      ? const SizedBox()
                      : StreamBuilder<UserModel>(
                          stream: cubit.getAnyUserData(uID!, context),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox(
                                width: 7.w,
                                height: 7.h,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppConstants.tabColor,
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return const SizedBox();
                            } else {
                              return Text(
                                snapshot.data!.isOnline! ? 'Online' : 'Offline',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13.sp),
                              );
                            }
                          })
                ],
              );
            },
          ),
          centerTitle: false,
          actions: [
            BlocConsumer<CallCubit, CallState>(
              listener: (context, state) {
                if (state is GetUserDataCallError) {
                  AppConstants.showSnackBar(
                      state.errorMsg, context, Colors.red);
                }
              },
              builder: (context, state) {
                CallCubit cubit = CallCubit.get(context);
                return IconButton(
                  onPressed: () {
                    cubit.createCalls(uID!, name!, profilePic!, isGroupChat);
                  },
                  icon: const Icon(Icons.video_call),
                );
              },
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.call),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ChatList(
                isGroupChat: isGroupChat,
                groupId: uID,
                recieverId: uID,
              ),
            ),
            BottomChatTextField(
              isGroupChat: isGroupChat,
              recieverId: uID,
              receiverName: name!,
              groupId: uID,
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/core/utilis/constants.dart';
import 'package:whatsapp_clone/features/auth/data/model/user_model.dart';

import '../../../../core/services/service_locator.dart';

import '../../controller/cubit/chat_cubit.dart';
import '../components/bottom_chat_text_field.dart';
import '../components/chat_list.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen(
      {super.key,
      required this.uID,
      required this.isOnline,
      required this.name,
      required this.profilePic});
  final String? uID;
  final bool? isOnline;
  final String? name;
  final String? profilePic;
  static const routeName = '/chat-screen';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChatCubit>()..getUserData(),
      child: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state is GetUserDataError) {
            AppConstants.showSnackBar(state.message, context, Colors.red);
          }
        },
        builder: (context, state) {
          ChatCubit cubit = ChatCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppConstants.appBarColor,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name!,
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 17.sp)),
                  StreamBuilder<UserModel>(
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
                          return const Text('');
                        } else {
                          return Text(
                            snapshot.data!.isOnline! ? 'Online' : 'Offline',
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 13.sp),
                          );
                        }
                      })
                ],
              ),
              centerTitle: false,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.video_call),
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
                    recieverId: uID!,
                  ),
                ),
                BottomChatTextField(
                  recieverId: uID!,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

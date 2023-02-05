import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'package:whatsapp_clone/features/chat/data/model/message_model.dart';
import 'package:whatsapp_clone/features/chat/presentation/components/sender_message_card.dart';

import '../../../../core/utilis/constants.dart';
import '../../controller/cubit/chat_cubit.dart';
import 'my_message_card.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key, required this.recieverId}) : super(key: key);
  final String recieverId;

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  var scrollController = ScrollController();
  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('en', null);
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        ChatCubit cubit = ChatCubit.get(context);
        return StreamBuilder<List<MessageModel>>(
            stream: cubit.getMessages(widget.recieverId, context),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                SchedulerBinding.instance
                    .addPersistentFrameCallback((timeStamp) {
                  scrollController
                      .jumpTo(scrollController.position.maxScrollExtent);
                });
                return snapshot.data!.isNotEmpty
                    ? ListView.builder(
                        controller: scrollController,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          if (snapshot.data![index].senderId ==
                              AppConstants.uID) {
                            return MyMessageCard(
                              message: snapshot.data![index].text.toString(),
                              date: DateFormat('hh:mm aa')
                                  .format(snapshot.data![index].timeSent),
                            );
                          }
                          return SenderMessageCard(
                            message: snapshot.data![index].text.toString(),
                            date: DateFormat('hh:mm aa')
                                .format(snapshot.data![index].timeSent),
                          );
                        },
                      )
                    : const SizedBox();
              } else if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(15.h),
                    child: Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppConstants.tabColor,
                  ),
                );
              }
            });
      },
    );
  }
}

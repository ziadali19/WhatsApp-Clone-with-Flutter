import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/utilis/constants.dart';
import '../../../chat/data/model/chat_contact_model.dart';
import '../../../chat/presentation/screens/chat_screen.dart';
import '../../../group/data/model/group_model.dart';
import '../../controller/cubit/layout_cubit.dart';

class ContactsList extends StatelessWidget {
  const ContactsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayoutCubit, LayoutState>(
      builder: (context, state) {
        LayoutCubit cubit = LayoutCubit.get(context);
        return SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<List<ChatContactModel>>(
                  stream: cubit.getContactsChats(context),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: EdgeInsets.only(top: 10.0.h),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, ChatScreen.routeName,
                                        arguments: {
                                          'isGroupChat': false,
                                          'uID':
                                              snapshot.data![index].contactId,
                                          'name': snapshot.data![index].name,
                                          'profilePic':
                                              snapshot.data![index].profilePic
                                        });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 8.0.h),
                                    child: ListTile(
                                      title: Text(
                                        snapshot.data![index].name.toString(),
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                        ),
                                      ),
                                      subtitle: Padding(
                                        padding: EdgeInsets.only(top: 6.0.h),
                                        child: Text(
                                          snapshot.data![index].lastMessage!,
                                          style: TextStyle(fontSize: 15.sp),
                                        ),
                                      ),
                                      leading: CircleAvatar(
                                        backgroundImage: snapshot.data![index]
                                                .profilePic!.isEmpty
                                            ? const AssetImage(
                                                    'assets/images/profile.jpg')
                                                as ImageProvider
                                            : NetworkImage(
                                                snapshot.data![index].profilePic
                                                    .toString(),
                                              ),
                                        radius: 30.r,
                                      ),
                                      trailing: Text(
                                        DateFormat('hh:mm aa').format(
                                            snapshot.data![index].timeSent),
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(
                                    color: AppConstants.dividerColor,
                                    indent: 85.w),
                              ],
                            );
                          },
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppConstants.tabColor,
                        ),
                      );
                    }
                  }),
///////////////////////////////////////////////////////
              StreamBuilder<List<GroupModel>>(
                  stream: cubit.getGroupsChats(context),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, ChatScreen.routeName,
                                      arguments: {
                                        'isGroupChat': true,
                                        'uID': snapshot.data![index].groupId,
                                        'name': snapshot.data![index].name,
                                        'profilePic':
                                            snapshot.data![index].groupPic
                                      });
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 8.0.h),
                                  child: ListTile(
                                    title: Text(
                                      snapshot.data![index].name.toString(),
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: EdgeInsets.only(top: 6.0.h),
                                      child: Text(
                                        snapshot.data![index].lastMessage,
                                        style: TextStyle(fontSize: 15.sp),
                                      ),
                                    ),
                                    leading: CircleAvatar(
                                      backgroundImage: snapshot
                                              .data![index].groupPic.isEmpty
                                          ? const AssetImage(
                                                  'assets/images/profile.jpg')
                                              as ImageProvider
                                          : NetworkImage(
                                              snapshot.data![index].groupPic
                                                  .toString(),
                                            ),
                                      radius: 30.r,
                                    ),
                                    trailing: Text(
                                      DateFormat('hh:mm aa').format(
                                          snapshot.data![index].timeSent),
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Divider(
                                  color: AppConstants.dividerColor,
                                  indent: 85.w),
                            ],
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppConstants.tabColor,
                        ),
                      );
                    }
                  })
            ],
          ),
        );
      },
    );
  }
}

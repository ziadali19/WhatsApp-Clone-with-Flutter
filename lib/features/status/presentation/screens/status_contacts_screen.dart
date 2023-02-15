// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/features/status/presentation/screens/stories_view_screen.dart';

import '../../../../core/utilis/constants.dart';
import '../../controller/cubit/status_cubit.dart';
import 'confirm_status_screen.dart';

class StatusContactsScreen extends StatelessWidget {
  const StatusContactsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StatusCubit, StatusState>(
      listener: (context, state) {
        if (state is GetStatusError) {
          AppConstants.showSnackBar(state.errorMsg, context, Colors.red);
        }
      },
      builder: (context, state) {
        StatusCubit cubit = StatusCubit.get(context);
        return cubit.userModel == null || cubit.status == null
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppConstants.tabColor,
                ),
              )
            : RefreshIndicator(
                color: AppConstants.tabColor,
                onRefresh: () {
                  return cubit.getStatus();
                },
                child: ListView(
                  children: [
                    cubit.status!['myStatus']!.isEmpty
                        ? InkWell(
                            onTap: () async {
                              File? pickedStory =
                                  await AppConstants.imagePicker(context);
                              if (pickedStory != null) {
                                Navigator.pushNamed(
                                    context, ConfirmStatusScreen.routeName,
                                    arguments: pickedStory);
                              }
                            },
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              horizontalTitleGap: 0,
                              leading: Stack(
                                alignment: AlignmentDirectional.bottomEnd,
                                children: [
                                  CircleAvatar(
                                    radius: 40.r,
                                    backgroundImage:
                                        cubit.userModel!.profilePic!.isNotEmpty
                                            ? NetworkImage(
                                                cubit.userModel!.profilePic!)
                                            : const AssetImage(
                                                    'assets/images/profile.jpg')
                                                as ImageProvider,
                                  ),
                                  Container(
                                    transform:
                                        Matrix4.translationValues(-9.w, 0, 0),
                                    child: CircleAvatar(
                                      backgroundColor: AppConstants.tabColor,
                                      radius: 10.r,
                                      child: Icon(
                                        Icons.add_rounded,
                                        color: Colors.white,
                                        size: 20.sp,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              title: Text(
                                'My status',
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                'Tap to add status update',
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, StoriesViewScreen.routeName,
                                  arguments: cubit.status!['myStatus']![0]);
                            },
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              horizontalTitleGap: 0,
                              leading: CircleAvatar(
                                radius: 40.r,
                                backgroundImage: cubit
                                        .userModel!.profilePic!.isNotEmpty
                                    ? NetworkImage(cubit.userModel!.profilePic!)
                                    : const AssetImage(
                                            'assets/images/profile.jpg')
                                        as ImageProvider,
                              ),
                              title: Text(
                                'My status',
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                DateFormat.yMMMMEEEEd().format(
                                    cubit.status!['myStatus']!.last.createdAt),
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 15.w, top: 10.h, right: 15.w),
                      child: Text(
                        'Recent updates',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ),
                    ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: cubit.status!['contactsStatus']!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return cubit.status!['contactsStatus']![index]
                                    .phoneNumber !=
                                cubit.userModel!.phoneNumber
                            ? Padding(
                                padding: EdgeInsets.only(top: 10.h),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, StoriesViewScreen.routeName,
                                        arguments: cubit
                                            .status!['contactsStatus']![index]);
                                  },
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    horizontalTitleGap: 0,
                                    leading: CircleAvatar(
                                      radius: 40.r,
                                      backgroundImage: cubit
                                              .status!['contactsStatus']![index]
                                              .profilePic
                                              .isNotEmpty
                                          ? NetworkImage(cubit
                                              .status!['contactsStatus']![index]
                                              .profilePic)
                                          : const AssetImage(
                                                  'assets/images/profile.jpg')
                                              as ImageProvider,
                                    ),
                                    title: Text(
                                      cubit.status!['contactsStatus']![index]
                                          .userName,
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    subtitle: Text(
                                      DateFormat.yMMMMEEEEd().format(cubit
                                          .status!['contactsStatus']![index]
                                          .createdAt),
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox();
                      },
                    ),
                  ],
                ),
              );
      },
    );
  }
}

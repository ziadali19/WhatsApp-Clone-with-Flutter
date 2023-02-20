import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/core/utilis/constants.dart';

import '../../controller/cubit/status_cubit.dart';

class ConfirmStatusScreen extends StatelessWidget {
  const ConfirmStatusScreen({super.key, required this.pickedStory});
  static const routeName = '/confirm-status-screen';
  final File pickedStory;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AspectRatio(aspectRatio: 9 / 16, child: Image.file(pickedStory)),
      ),
      floatingActionButton: BlocConsumer<StatusCubit, StatusState>(
        listener: (context, state) {
          if (state is GetUserDataError) {
            AppConstants.showSnackBar(state.errorMsg, context, Colors.red);
          }
          if (state is UploadStoryError) {
            AppConstants.showSnackBar(state.errorMsg, context, Colors.red);
          }
          if (state is UploadStorySuccess) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          StatusCubit cubit = StatusCubit.get(context);
          return FloatingActionButton(
            onPressed: () {
              if (cubit.userModel != null) {
                StatusCubit.get(context).uploadStatus(
                    userName: cubit.userModel!.name!,
                    profilePic: cubit.userModel!.profilePic!,
                    phoneNumber: cubit.userModel!.phoneNumber!,
                    storyImage: pickedStory,
                    context: context);
              }
            },
            backgroundColor: AppConstants.tabColor,
            child: Center(
              child: state is GetUserDataLoading || state is UploadStoryLoading
                  ? SizedBox(
                      width: 30.w,
                      height: 30.h,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 30.sp,
                    ),
            ),
          );
        },
      ),
    );
  }
}

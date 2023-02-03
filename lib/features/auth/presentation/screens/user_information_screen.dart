import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/core/utilis/constants.dart';
import 'package:whatsapp_clone/features/auth/controller/cubit/user_information_cubit.dart';

import '../../../layout/presentation/screens/layout_screen.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({super.key});
  static const routeName = '/user-information';
  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  TextEditingController nameController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: Center(
          child: Column(
            children: [
              BlocBuilder<UserInformationCubit, UserInformationState>(
                builder: (context, state) {
                  UserInformationCubit cubit =
                      UserInformationCubit.get(context);
                  return Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      CircleAvatar(
                        radius: 60.r,
                        backgroundImage: cubit.profileImage == null
                            ? const AssetImage('assets/images/profile.jpg')
                                as ImageProvider
                            : FileImage(cubit.profileImage!),
                      ),
                      GestureDetector(
                          onTap: () {
                            cubit.selectImage(context);
                          },
                          child: const Icon(Icons.camera_alt_rounded))
                    ],
                  );
                },
              ),
              SizedBox(
                height: 15.h,
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      controller: nameController,
                      decoration:
                          const InputDecoration(hintText: 'Enter your name'),
                    ),
                  ),
                  BlocConsumer<UserInformationCubit, UserInformationState>(
                    listener: (context, state) {
                      if (state is UploadProfileImageError) {
                        AppConstants.showSnackBar(
                            state.errorMsg, context, Colors.red);
                      }
                      if (state is SaveUserDataToFirebaseError) {
                        AppConstants.showSnackBar(
                            state.errorMsg, context, Colors.red);
                      }
                      if (state is GetUserDataError) {
                        AppConstants.showSnackBar(
                            state.errorMsg, context, Colors.red);
                      }
                      if (state is GetUserDataSuccess) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, LayoutScreen.routeName, (route) => false);
                      }
                    },
                    builder: (context, state) {
                      return Expanded(
                          child: state is UploadProfileImageLoading ||
                                  state is SaveUserDataToFirebaseLoading ||
                                  state is GetUserDataLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: AppConstants.tabColor,
                                    strokeWidth: 2,
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {
                                    if (nameController.text.trim().isNotEmpty) {
                                      UserInformationCubit.get(context)
                                          .saveUserDataToFirebase(
                                              nameController.text.trim(),
                                              UserInformationCubit.get(context)
                                                  .profileImage,
                                              context);
                                    } else {
                                      AppConstants.showSnackBar(
                                          'Enter your name',
                                          context,
                                          Colors.red);
                                    }
                                  },
                                  icon: const Icon(Icons.done_rounded)));
                    },
                  )
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}

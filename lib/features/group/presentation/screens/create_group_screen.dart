import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/core/utilis/constants.dart';

import '../../controller/cubit/group_cubit.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});
  static const String routeName = '/create-group-screen';

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  late TextEditingController nameController;
  late FocusNode focusNode;
  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Group'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<GroupCubit, GroupState>(
              builder: (context, state) {
                GroupCubit cubit = GroupCubit.get(context);
                return Center(
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      CircleAvatar(
                        radius: 60.r,
                        backgroundImage: cubit.groupImage == null
                            ? const AssetImage('assets/images/profile.jpg')
                                as ImageProvider
                            : FileImage(cubit.groupImage!),
                      ),
                      GestureDetector(
                          onTap: () {
                            cubit.selectImage(context);
                          },
                          child: const Icon(Icons.camera_alt_rounded))
                    ],
                  ),
                );
              },
            ),
            SizedBox(
              height: 10.h,
            ),
            Form(
                key: formKey,
                child: TextFormField(
                  focusNode: focusNode,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'Please set a name to the Group';
                    } else {
                      return null;
                    }
                  },
                  controller: nameController,
                  cursorColor: AppConstants.tabColor,
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppConstants.tabColor)),
                    hintText: 'Enter Group Name',
                  ),
                )),
            SizedBox(
              height: 15.h,
            ),
            Text(
              'Select Contacts',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.sp),
            ),
            SizedBox(
              height: 10.h,
            ),
            BlocBuilder<GroupCubit, GroupState>(
              builder: (context, state) {
                GroupCubit cubit = GroupCubit.get(context);
                return state is GetContactsForGroupLoading
                    ? const Center(
                        child: LinearProgressIndicator(
                          color: AppConstants.tabColor,
                        ),
                      )
                    : Expanded(
                        child: ListView.separated(
                          itemCount: cubit.contacts.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                cubit.selectContact(
                                    index, (cubit.contacts[index]));
                              },
                              child: ListTile(
                                trailing:
                                    cubit.selectContactsIndecies.contains(index)
                                        ? const Icon(
                                            Icons.done_rounded,
                                            color: AppConstants.tabColor,
                                          )
                                        : const SizedBox(),
                                leading: cubit.contacts[index].photo == null
                                    ? null
                                    : CircleAvatar(
                                        radius: 20.r,
                                        backgroundImage: MemoryImage(
                                            cubit.contacts[index].photo!),
                                      ),
                                title: Text(
                                  cubit.contacts[index].displayName,
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider(
                                color: AppConstants.dividerColor, indent: 0);
                          },
                        ),
                      );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: BlocConsumer<GroupCubit, GroupState>(
        listener: (context, state) {
          if (state is CreateGroupError) {
            AppConstants.showSnackBar(state.errorMsg, context, Colors.red);
          }
          if (state is CreateGroupSuccess) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: () {
              focusNode.unfocus();
              if (formKey.currentState!.validate()) {
                if (GroupCubit.get(context).groupImage != null) {
                  GroupCubit.get(context).createGroup(
                      context,
                      GroupCubit.get(context).groupImage,
                      nameController.text.trim(),
                      GroupCubit.get(context).selectContacts);
                } else {
                  AppConstants.showSnackBar(
                      'Set an image for the group', context, Colors.red);
                }
              }
            },
            backgroundColor: AppConstants.tabColor,
            child: state is CreateGroupLoading
                ? SizedBox(
                    width: 30.w,
                    height: 30.h,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                    ))
                : const Icon(
                    Icons.done_rounded,
                    color: Colors.white,
                  ),
          );
        },
      ),
    );
  }
}

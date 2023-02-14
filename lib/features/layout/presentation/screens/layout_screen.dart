// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/core/utilis/constants.dart';
import 'package:whatsapp_clone/features/chat/data/repository/chat_repository.dart';
import 'package:whatsapp_clone/features/layout/controller/cubit/layout_cubit.dart';
import 'package:whatsapp_clone/features/status/presentation/screens/status_contacts_screen.dart';

import '../../../../core/network/failure.dart';
import '../../../select_contacts/presentation/screens/contacts_screen.dart';
import '../../../status/presentation/screens/confirm_status_screen.dart';
import '../components/contacts_list.dart';

class LayoutScreen extends StatefulWidget {
  static const routeName = '/layout';
  const LayoutScreen({super.key, required this.baseChatRepository});
  final BaseChatRepository baseChatRepository;

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  userStatus(bool isOnline, context) async {
    dartz.Either<Failure, void> result =
        await widget.baseChatRepository.userStatus(isOnline);
    result.fold((l) {
      AppConstants.showSnackBar(l.message, context, Colors.red);
    }, (r) {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        userStatus(true, context);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        userStatus(false, context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppConstants.appBarColor,
            centerTitle: false,
            title: Text(
              'WhatsApp',
              style: TextStyle(
                fontSize: 20.sp,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.grey),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.grey),
                onPressed: () {},
              ),
            ],
            bottom: TabBar(
              controller: tabController,
              indicatorColor: AppConstants.tabColor,
              indicatorWeight: 4,
              labelColor: AppConstants.tabColor,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(
                  text: 'CHATS',
                ),
                Tab(
                  text: 'STATUS',
                ),
                Tab(
                  text: 'CALLS',
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: tabController,
            children: const [
              ContactsList(),
              StatusContactsScreen(),
              Text('calls')
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (tabController.index == 0) {
                Navigator.pushNamed(context, ContactsScreen.routeName);
              } else {
                File? pickedStory = await AppConstants.imagePicker(context);
                if (pickedStory != null) {
                  Navigator.pushNamed(context, ConfirmStatusScreen.routeName,
                      arguments: pickedStory);
                }
              }
            },
            backgroundColor: AppConstants.tabColor,
            child: const Icon(
              Icons.comment_rounded,
              color: Colors.white,
            ),
          )),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_clone/features/auth/presentation/screens/login_screen.dart';
import 'package:whatsapp_clone/features/auth/presentation/screens/otb_screen.dart';
import 'package:whatsapp_clone/features/auth/presentation/screens/user_information_screen.dart';
import 'package:whatsapp_clone/features/chat/data/repository/chat_repository.dart';
import 'package:whatsapp_clone/features/group/presentation/screens/create_group_screen.dart';
import 'package:whatsapp_clone/features/layout/presentation/screens/layout_screen.dart';
import 'package:whatsapp_clone/features/status/data/model/status_model.dart';
import 'package:whatsapp_clone/features/status/presentation/screens/confirm_status_screen.dart';
import 'package:whatsapp_clone/features/status/presentation/screens/stories_view_screen.dart';

import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/select_contacts/presentation/screens/contacts_screen.dart';
import '../services/service_locator.dart';

class AppConstants {
  static const backgroundColor = Color.fromRGBO(19, 28, 33, 1);
  static const textColor = Color.fromRGBO(241, 241, 242, 1);
  static const appBarColor = Color.fromRGBO(31, 44, 52, 1);
  static const webAppBarColor = Color.fromRGBO(42, 47, 50, 1);
  static const messageColor = Color.fromRGBO(5, 96, 98, 1);
  static const senderMessageColor = Color.fromRGBO(37, 45, 49, 1);
  static const tabColor = Color.fromRGBO(0, 167, 131, 1);
  static const searchBarColor = Color.fromRGBO(50, 55, 57, 1);
  static const dividerColor = Color.fromRGBO(37, 45, 50, 1);
  static const chatBarMessage = Color.fromRGBO(30, 36, 40, 1);
  static const mobileChatBoxColor = Color.fromRGBO(31, 44, 52, 1);
  static const greyColor = Colors.grey;
  static const blackColor = Colors.black;

  static onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LoginScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );
      case LayoutScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => LayoutScreen(
            baseChatRepository: sl<BaseChatRepository>(),
          ),
        );
      case UserInformationScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const UserInformationScreen(),
        );
      case ContactsScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const ContactsScreen(),
        );
      case ChatScreen.routeName:
        Map userData = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (context) => ChatScreen(
            uID: userData['uID'],
            name: userData['name'],
            profilePic: userData['profilePic'],
            isGroupChat: userData['isGroupChat'],
          ),
        );
      case OTBScreen.routeName:
        final verficationId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (context) => OTBScreen(
            verficationId: verficationId,
          ),
        );
      case ConfirmStatusScreen.routeName:
        final File pickedStory = settings.arguments as File;
        return MaterialPageRoute(
          builder: (context) => ConfirmStatusScreen(
            pickedStory: pickedStory,
          ),
        );
      case StoriesViewScreen.routeName:
        final StatusModel statusModel = settings.arguments as StatusModel;
        return MaterialPageRoute(
          builder: (context) => StoriesViewScreen(
            statusModel: statusModel,
          ),
        );

      case CreateGroupScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const CreateGroupScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(),
        );
    }
  }

  static showSnackBar(String? msg, BuildContext context, Color? clr) {
    showToast(
      msg,
      context: context,
      backgroundColor: clr,
      animation: StyledToastAnimation.slideFromTopFade,
      reverseAnimation: StyledToastAnimation.fade,
      position:
          const StyledToastPosition(align: Alignment.bottomCenter, offset: 70),
      animDuration: const Duration(seconds: 1),
      duration: const Duration(seconds: 4),
      curve: Curves.bounceOut,
      reverseCurve: Curves.linear,
    );
  }

  static String? uID;
  static String? user;

  static Future<File?>? imagePicker(context) async {
    File? image;
    try {
      final XFile? pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        image = File(pickedFile.path);
      }
    } catch (e) {
      AppConstants.showSnackBar(e.toString(), context, Colors.red);
    }
    return image;
  }

  static Future<File?>? videoPicker(context) async {
    File? video;
    try {
      final XFile? pickedFile =
          await ImagePicker().pickVideo(source: ImageSource.gallery);

      if (pickedFile != null) {
        video = File(pickedFile.path);
      }
    } catch (e) {
      AppConstants.showSnackBar(e.toString(), context, Colors.red);
    }
    return video;
  }

  static gifPicker(context) async {
    GiphyGif? gif;
    try {
      gif = await GiphyGet.getGif(
        context: context, //Required
        apiKey: 'Ihbvqck51mmBulmHUYmJbQgitgBEUFUC', //Required.
        lang: GiphyLanguage.english, //Optional - Language for query.
        randomID: "abcd", // Optional - An ID/proxy for a specific user.
        tabColor: AppConstants.tabColor, // Optional- default accent color.
        debounceTimeInMilliseconds:
            350, // Optional- time to pause between search keystrokes
      );
    } catch (e) {
      AppConstants.showSnackBar(e.toString(), context, Colors.red);
    }
    return gif;
  }
}

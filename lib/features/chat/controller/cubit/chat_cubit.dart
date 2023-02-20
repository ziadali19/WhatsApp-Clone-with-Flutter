import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:whatsapp_clone/core/network/failure.dart';
import 'package:whatsapp_clone/core/utilis/constants.dart';
import 'package:whatsapp_clone/features/auth/data/repository/auth_repository.dart';
import 'package:whatsapp_clone/features/chat/data/model/message_model.dart';
import 'package:whatsapp_clone/features/chat/data/repository/chat_repository.dart';

import '../../../../core/common/enums/messgae_enum.dart';
import '../../../auth/data/model/user_model.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(this.baseAuthRepository, this.baseChatRepository)
      : super(ChatInitial());
  final BaseAuthRepository baseAuthRepository;
  final BaseChatRepository baseChatRepository;

  static ChatCubit get(context) {
    return BlocProvider.of(context);
  }

  Stream<UserModel>? getAnyUserData(String uID, context) {
    Stream<UserModel>? userModel;
    baseAuthRepository.getAnyUserData(uID).fold((l) {
      AppConstants.showSnackBar(l.message, context, Colors.red);
    }, (r) {
      userModel = r;
    });
    return userModel;
  }

  Stream<List<MessageModel>>? getMessages(String recieverId, context) {
    Stream<List<MessageModel>>? messages;
    Either<Failure, Stream<List<MessageModel>>> result =
        baseChatRepository.getMessages(recieverId);

    result.fold((l) {
      AppConstants.showSnackBar(l.message, context, Colors.red);
    }, (r) {
      messages = r;
    });
    return messages;
  }

  UserModel? userModel;
  getUserData() async {
    //emit(GetUserDataForChatLoading());
    Either<Failure, UserModel> result = await baseAuthRepository.getUserData();
    result.fold((l) {
      emit(GetUserDataForChatError(l.message));
    }, (r) {
      userModel = r;
      // emit(GetUserDataForChatSuccess());
    });
  }

  setMessagesToSeen(
      String receiverId, String messageId, BuildContext context) async {
    Either<Failure, void> result =
        await baseChatRepository.setMessagesToSeen(receiverId, messageId);
    result.fold((l) {
      AppConstants.showSnackBar(l.message, context, Colors.red);
    }, (r) {});
  }

  Stream<List<MessageModel>>? getGroupMessages(String groupId, context) {
    Stream<List<MessageModel>>? messages;
    Either<Failure, Stream<List<MessageModel>>> result =
        baseChatRepository.getGroupMessages(groupId);

    result.fold((l) {
      AppConstants.showSnackBar(l.message, context, Colors.red);
    }, (r) {
      messages = r;
    });
    return messages;
  }
}

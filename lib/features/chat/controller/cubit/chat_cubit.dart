import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
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

  sendTextMessage(
      {required UserModel senderUser,
      required String recieverId,
      required String text,
      required MessageEnum replyOnMessageType,
      required String replyOn,
      required String replyOnUserName}) async {
    Either<Failure, void> result = await baseChatRepository.sendTextMessage(
        senderUser: senderUser,
        recieverId: recieverId,
        text: text,
        replyOn: replyOn,
        replyOnMessageType: replyOnMessageType,
        replyOnUserName: replyOnUserName);
    result.fold((l) {
      emit(SendMessageError(l.message));
    }, (r) {});
  }

  sendGifMessage(
      {required UserModel senderUser,
      required String recieverId,
      required String text,
      required MessageEnum replyOnMessageType,
      required String replyOn,
      required String replyOnUserName}) async {
    int lastIndexOfDashIncrement = text.lastIndexOf('-') + 1;
    String lastPart = text.substring(lastIndexOfDashIncrement);
    String newUrl = 'https://i.giphy.com/media/$lastPart/200.gif';
    Either<Failure, void> result = await baseChatRepository.sendGifMessage(
        senderUser: senderUser,
        recieverId: recieverId,
        text: newUrl,
        replyOn: replyOn,
        replyOnMessageType: replyOnMessageType,
        replyOnUserName: replyOnUserName);
    result.fold((l) {
      emit(SendMessageError(l.message));
    }, (r) {});
  }

  UserModel? userModel;
  getUserData() async {
    emit(GetUserDataLoading());
    Either<Failure, UserModel> result = await baseAuthRepository.getUserData();
    result.fold((l) {
      emit(GetUserDataError(l.message));
    }, (r) {
      userModel = r;
      emit(GetUserDataSuccess());
    });
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

  sendFileMessage(
      {required UserModel senderUser,
      required String receiverId,
      required File file,
      required MessageEnum messageType,
      required BuildContext context,
      required MessageEnum replyOnMessageType,
      required String replyOn,
      required String replyOnUserName}) async {
    emit(SendFileLoading());
    Either<Failure, void> result = await baseChatRepository.sendFileMessage(
        senderUser: senderUser,
        receiverId: receiverId,
        file: file,
        messageType: messageType,
        context: context,
        replyOn: replyOn,
        replyOnMessageType: replyOnMessageType,
        replyOnUserName: replyOnUserName);
    result.fold((l) {
      emit(SendMessageError(l.message));
    }, (r) {
      emit(SendFileSuccess());
    });
  }

  cancelReply() {
    message = null;
    messageType = null;
    isMe = null;
    emit(CancelReply());
  }

  String? message;
  MessageEnum? messageType;
  bool? isMe;
  swipeToReply(String message, MessageEnum messageType, bool isMe) {
    this.message = message;
    this.messageType = messageType;
    this.isMe = isMe;
    emit(MessageReplyContainer());
  }
}

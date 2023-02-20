import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:whatsapp_clone/features/auth/data/repository/auth_repository.dart';
import 'package:whatsapp_clone/features/chat/data/repository/chat_repository.dart';

import '../../../../core/common/enums/messgae_enum.dart';
import '../../../../core/network/failure.dart';
import '../../../auth/data/model/user_model.dart';

part 'text_field_state.dart';

class TextFieldCubit extends Cubit<TextFieldState> {
  TextFieldCubit(this.baseAuthRepository, this.baseChatRepository)
      : super(TextFieldInitial());
  final BaseAuthRepository baseAuthRepository;
  final BaseChatRepository baseChatRepository;
  static TextFieldCubit get(context) {
    return BlocProvider.of(context);
  }

  sendFileMessage(
      {required UserModel senderUser,
      required String receiverId,
      required File file,
      required MessageEnum messageType,
      required BuildContext context,
      required MessageEnum replyOnMessageType,
      required String replyOn,
      required String replyOnUserName,
      required bool isGroupChat}) async {
    emit(SendFileLoading());
    Either<Failure, void> result = await baseChatRepository.sendFileMessage(
        isGroupChat: isGroupChat,
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

  sendTextMessage(
      {required UserModel senderUser,
      required String recieverId,
      required String text,
      required MessageEnum replyOnMessageType,
      required String replyOn,
      required String replyOnUserName,
      required bool isGroupChat}) async {
    Either<Failure, void> result = await baseChatRepository.sendTextMessage(
        isGroupChat: isGroupChat,
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
      required String replyOnUserName,
      required bool isGroupChat}) async {
    int lastIndexOfDashIncrement = text.lastIndexOf('-') + 1;
    String lastPart = text.substring(lastIndexOfDashIncrement);
    String newUrl = 'https://i.giphy.com/media/$lastPart/200.gif';
    Either<Failure, void> result = await baseChatRepository.sendGifMessage(
        isGroupChat: isGroupChat,
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

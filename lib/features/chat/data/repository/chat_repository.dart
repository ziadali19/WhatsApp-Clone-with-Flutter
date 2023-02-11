import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/core/network/network_exception.dart';
import 'package:whatsapp_clone/features/chat/data/remote_data_source/chat_remote_data_source.dart';

import '../../../../core/common/enums/messgae_enum.dart';
import '../../../../core/network/failure.dart';
import '../../../auth/data/model/user_model.dart';
import '../model/message_model.dart';

abstract class BaseChatRepository {
  Future<Either<Failure, void>> sendTextMessage(
      {required UserModel senderUser,
      required String recieverId,
      required String text,
      required MessageEnum replyOnMessageType,
      required String replyOn,
      required String replyOnUserName});
  Either<Failure, Stream<List<MessageModel>>> getMessages(String recieverId);
  Future<Either<Failure, void>> userStatus(bool isOnline);
  Future<Either<Failure, void>> sendFileMessage(
      {required UserModel senderUser,
      required String receiverId,
      required File file,
      required MessageEnum messageType,
      required BuildContext context,
      required MessageEnum replyOnMessageType,
      required String replyOn,
      required String replyOnUserName});
  Future<Either<Failure, void>> sendGifMessage({
    required UserModel senderUser,
    required String recieverId,
    required String text,
    required MessageEnum replyOnMessageType,
    required String replyOn,
    required String replyOnUserName,
  });
}

class ChatRepository extends BaseChatRepository {
  final BaseChatRemoteDataSource baseChatRemoteDataSource;

  ChatRepository(this.baseChatRemoteDataSource);
  @override
  Future<Either<Failure, void>> sendTextMessage(
      {required UserModel senderUser,
      required String recieverId,
      required String text,
      required MessageEnum replyOnMessageType,
      required String replyOn,
      required String replyOnUserName}) async {
    try {
      await baseChatRemoteDataSource.sendTextMessage(
          senderUser: senderUser,
          recieverId: recieverId,
          text: text,
          replyOn: replyOn,
          replyOnMessageType: replyOnMessageType,
          replyOnUserName: replyOnUserName);
      return right(null);
    } on FireBaseException catch (e) {
      return left(FirebaseFailure(e.message));
    }
  }

  @override
  Either<Failure, Stream<List<MessageModel>>> getMessages(String recieverId) {
    try {
      return right(baseChatRemoteDataSource.getMessages(recieverId));
    } on FireBaseException catch (e) {
      return left(FirebaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> userStatus(bool isOnline) async {
    try {
      await baseChatRemoteDataSource.userStatus(isOnline);
      return right(null);
    } on FireBaseException catch (e) {
      return left(FirebaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> sendFileMessage(
      {required UserModel senderUser,
      required String receiverId,
      required File file,
      required MessageEnum messageType,
      required BuildContext context,
      required MessageEnum replyOnMessageType,
      required String replyOn,
      required String replyOnUserName}) async {
    try {
      await baseChatRemoteDataSource.sendFileMessage(
          senderUser: senderUser,
          receiverId: receiverId,
          file: file,
          messageType: messageType,
          context: context,
          replyOn: replyOn,
          replyOnMessageType: replyOnMessageType,
          replyOnUserName: replyOnUserName);
      return right(null);
    } on FireBaseException catch (e) {
      return left(FirebaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> sendGifMessage(
      {required UserModel senderUser,
      required String recieverId,
      required String text,
      required MessageEnum replyOnMessageType,
      required String replyOn,
      required String replyOnUserName}) async {
    try {
      await baseChatRemoteDataSource.sendGifMessage(
          senderUser: senderUser,
          recieverId: recieverId,
          text: text,
          replyOn: replyOn,
          replyOnMessageType: replyOnMessageType,
          replyOnUserName: replyOnUserName);
      return right(null);
    } on FireBaseException catch (e) {
      return left(FirebaseFailure(e.message));
    }
  }
}

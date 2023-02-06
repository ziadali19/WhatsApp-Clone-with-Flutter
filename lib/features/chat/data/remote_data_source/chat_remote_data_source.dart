import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/core/common/enums/messgae_enum.dart';
import 'package:whatsapp_clone/core/common/firebase_storage/firebase_storage_repository.dart';
import 'package:whatsapp_clone/core/network/failure.dart';
import 'package:whatsapp_clone/core/network/network_exception.dart';
import 'package:whatsapp_clone/features/auth/data/model/user_model.dart';
import 'package:whatsapp_clone/features/chat/data/model/chat_contact_model.dart';
import 'package:whatsapp_clone/features/chat/data/model/message_model.dart';

import '../../../../core/utilis/constants.dart';

abstract class BaseChatRemoteDataSource {
  Future<void> sendTextMessage({
    required UserModel senderUser,
    required String recieverId,
    required String text,
  });
  Future<void> sendFileMessage(
      {required UserModel senderUser,
      required String receiverId,
      required File file,
      required MessageEnum messageType,
      required BuildContext context});
  Stream<List<MessageModel>> getMessages(String recieverId);
  Future<void> userStatus(bool isOnline);
}

class ChatRemoteDataSource extends BaseChatRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final BaseFirebaseStorageRepository baseFirebaseStorageRepository;
  ChatRemoteDataSource(this.firebaseFirestore, this.firebaseAuth,
      this.baseFirebaseStorageRepository);

  _saveDataToContactsSubCollections(
      {required UserModel senderUser,
      required UserModel recieverUser,
      required String text,
      required DateTime time,
      required String recieverId}) async {
    ChatContactModel senderChatContactModel = ChatContactModel(
      name: recieverUser.name,
      profilePic: recieverUser.profilePic,
      timeSent: time,
      lastMessage: text,
      contactId: recieverUser.uID,
    );
    ChatContactModel recieverChatContactModel = ChatContactModel(
      name: senderUser.name,
      profilePic: senderUser.profilePic,
      timeSent: time,
      lastMessage: text,
      contactId: senderUser.uID,
    );
    try {
      await firebaseFirestore
          .collection('users')
          .doc(recieverId)
          .collection('chats')
          .doc(senderUser.uID)
          .set(recieverChatContactModel.toJson());
      await firebaseFirestore
          .collection('users')
          .doc(senderUser.uID)
          .collection('chats')
          .doc(recieverUser.uID)
          .set(senderChatContactModel.toJson());
    } on FirebaseException catch (e) {
      throw FireBaseException(e.code);
    }
  }

  _saveMessageToMessageSubCollections(
      {required String recieverUserId,
      required String text,
      required DateTime timeSent,
      required String messageId,
      required String userName,
      required String recieverUserNam,
      required MessageEnum messageType}) async {
    MessageModel messageModel = MessageModel(
        senderId: AppConstants.uID!,
        recieverId: recieverUserId,
        text: text,
        messageType: messageType,
        messageId: messageId,
        isSeen: false,
        timeSent: timeSent);

    try {
      await firebaseFirestore
          .collection('users')
          .doc(AppConstants.uID)
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(messageId)
          .set(messageModel.toJson());
      await firebaseFirestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(AppConstants.uID)
          .collection('messages')
          .doc(messageId)
          .set(messageModel.toJson());
    } on FirebaseException catch (e) {
      throw FireBaseException(e.code);
    }
  }

  @override
  Future<void> sendTextMessage({
    required UserModel senderUser,
    required String recieverId,
    required String text,
  }) async {
    try {
      DateTime time = DateTime.now();
      UserModel recieverUser = UserModel.fromJson(
          await firebaseFirestore.collection('users').doc(recieverId).get());
      String messageId = const Uuid().v1();
      _saveDataToContactsSubCollections(
          senderUser: senderUser,
          recieverUser: recieverUser,
          text: text,
          time: time,
          recieverId: recieverId);
      _saveMessageToMessageSubCollections(
          recieverUserId: recieverId,
          text: text,
          timeSent: time,
          messageId: messageId,
          userName: senderUser.name!,
          recieverUserNam: recieverUser.name!,
          messageType: MessageEnum.text);
    } on FirebaseException catch (e) {
      throw FireBaseException(e.code);
    }
  }

  @override
  Stream<List<MessageModel>> getMessages(String recieverId) {
    try {
      return firebaseFirestore
          .collection('users')
          .doc(AppConstants.uID)
          .collection('chats')
          .doc(recieverId)
          .collection('messages')
          .orderBy('timeSent', descending: false)
          .snapshots()
          .map((event) {
        List<MessageModel> messages = [];
        for (QueryDocumentSnapshot<Map<String, dynamic>> message
            in event.docs) {
          messages.add(MessageModel.fromJson(message.data()));
        }
        return messages;
      });
    } on FirebaseException catch (e) {
      throw FireBaseException(e.code);
    }
  }

  @override
  Future<void> userStatus(bool isOnline) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc(AppConstants.uID)
          .update({'isOnline': isOnline});
    } on FirebaseException catch (e) {
      throw FireBaseException(e.code);
    }
  }

  @override
  sendFileMessage(
      {required UserModel senderUser,
      required String receiverId,
      required File file,
      required MessageEnum messageType,
      required BuildContext context}) async {
    try {
      UserModel receiverUser = UserModel.fromJson(
          await firebaseFirestore.collection('users').doc(receiverId).get());
      String messageId = const Uuid().v1();
      String fileUrl = '';
      Either<Failure, String> result =
          await baseFirebaseStorageRepository.saveFileToFirebase(
              'chat/${messageType.type}/${senderUser.uID}/$receiverId/$messageId',
              file);
      result.fold((l) {
        AppConstants.showSnackBar(l.message, context, Colors.red);
      }, (r) {
        fileUrl = r;
      });

      late String contactMsg;
      switch (messageType) {
        case MessageEnum.image:
          contactMsg = '📷 Photo';
          break;
        case MessageEnum.video:
          contactMsg = '📷 Video';
          break;
        case MessageEnum.audio:
          contactMsg = '🎵 Audio';
          break;
        case MessageEnum.gif:
          contactMsg = '📷 GIF';
          break;
        default:
          contactMsg = '';
      }
      _saveDataToContactsSubCollections(
          senderUser: senderUser,
          recieverUser: receiverUser,
          text: contactMsg,
          time: DateTime.now(),
          recieverId: receiverId);
      _saveMessageToMessageSubCollections(
          recieverUserId: receiverId,
          text: fileUrl,
          timeSent: DateTime.now(),
          messageId: messageId,
          userName: senderUser.name!,
          recieverUserNam: receiverUser.name!,
          messageType: messageType);
    } on FirebaseException catch (e) {
      throw FireBaseException(e.code);
    }
  }
}

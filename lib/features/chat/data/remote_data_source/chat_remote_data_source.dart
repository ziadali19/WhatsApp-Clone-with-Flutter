import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/core/common/enums/messgae_enum.dart';
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
  Stream<List<MessageModel>> getMessages(String recieverId);
}

class ChatRemoteDataSource extends BaseChatRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;

  ChatRemoteDataSource(this.firebaseFirestore, this.firebaseAuth);

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
}

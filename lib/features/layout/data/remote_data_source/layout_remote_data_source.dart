import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:whatsapp_clone/core/network/network_exception.dart';
import 'package:whatsapp_clone/core/utilis/constants.dart';
import 'package:whatsapp_clone/features/chat/data/model/chat_contact_model.dart';

import '../../../group/data/model/group_model.dart';

abstract class BaseLayoutRemoteDataSource {
  Stream<List<ChatContactModel>> getContactsChats();
  Stream<List<GroupModel>> getGroupsChats();
}

class LayoutRemoteDataSource extends BaseLayoutRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;

  LayoutRemoteDataSource(this.firebaseFirestore);
  @override
  Stream<List<ChatContactModel>> getContactsChats() {
    try {
      return firebaseFirestore
          .collection('users')
          .doc(AppConstants.uID)
          .collection('chats')
          .snapshots()
          .map((event) {
        List<ChatContactModel> contacts = [];
        for (var document in event.docs) {
          contacts.add(ChatContactModel.fromJson(document.data()));
        }
        return contacts;
      });
    } on FirebaseException catch (e) {
      throw FireBaseException(e.code);
    }
  }

  @override
  Stream<List<GroupModel>> getGroupsChats() {
    try {
      return firebaseFirestore
          .collection('groups')
          .where('usersUIDs', arrayContains: AppConstants.uID)
          .snapshots()
          .map((event) {
        List<GroupModel> groupChats = [];
        for (var document in event.docs) {
          groupChats.add(GroupModel.fromJson(document.data()));
        }
        return groupChats;
      });
    } on FirebaseException catch (e) {
      throw FireBaseException(e.code);
    }
  }
}

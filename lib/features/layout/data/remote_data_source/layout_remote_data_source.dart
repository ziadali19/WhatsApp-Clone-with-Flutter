import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:whatsapp_clone/core/network/network_exception.dart';
import 'package:whatsapp_clone/core/utilis/constants.dart';
import 'package:whatsapp_clone/features/chat/data/model/chat_contact_model.dart';

abstract class BaseLayoutRemoteDataSource {
  Stream<List<ChatContactModel>> getContactsChats();
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
}

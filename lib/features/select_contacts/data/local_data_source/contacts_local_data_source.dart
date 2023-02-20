// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:whatsapp_clone/core/utilis/constants.dart';
import 'package:whatsapp_clone/features/auth/data/model/user_model.dart';

import '../../../../core/network/network_exception.dart';
import '../../../chat/presentation/screens/chat_screen.dart';

abstract class BaseContactsLocalDataSource {
  Future<List<Contact>> getContacts();
  Future<void> selectContact(Contact contact, context);
}

class ContactsLocalDataSource extends BaseContactsLocalDataSource {
  final FirebaseFirestore firebaseFirestore;

  ContactsLocalDataSource(this.firebaseFirestore);

  @override
  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(
            withProperties: true, withPhoto: true);
      }
    } catch (e) {
      print(e.toString());
    }
    return contacts;
  }

  @override
  Future<void> selectContact(Contact contact, context) async {
    bool isFound = false;
    try {
      QuerySnapshot<Map<String, dynamic>> users =
          await firebaseFirestore.collection('users').get();
      for (var user in users.docs) {
        UserModel usersModel = UserModel.fromJson(user.data());
        if (contact.phones[0].number.replaceAll(' ', '') ==
            usersModel.phoneNumber) {
          isFound = true;
          Navigator.pushNamed(
            context,
            ChatScreen.routeName,
            arguments: {
              'uID': usersModel.uID,
              'name': usersModel.name,
              'isOnline': usersModel.isOnline,
              'profilePic': usersModel.profilePic
            },
          );
        }
      }
      if (isFound == false) {
        AppConstants.showSnackBar(
            'This user isn\'t a member in our Application',
            context,
            Colors.red);
      }
    } on FirebaseException catch (e) {
      throw FireBaseException(e.code);
    }
  }
}

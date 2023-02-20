// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/core/common/firebase_storage/firebase_storage_repository.dart';
import 'package:whatsapp_clone/core/network/failure.dart';
import 'package:whatsapp_clone/core/network/network_exception.dart';
import 'package:whatsapp_clone/core/utilis/constants.dart';
import 'package:whatsapp_clone/features/auth/data/model/user_model.dart';
import 'package:whatsapp_clone/features/group/data/model/group_model.dart';

abstract class BaseGroupRemoteDataSource {
  Future<void> createGroup(BuildContext context, File? groupImage,
      String groupName, List<Contact> selectContacts);
}

class GroupRemoteDataSource extends BaseGroupRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final BaseFirebaseStorageRepository firebaseStorageRepository;

  GroupRemoteDataSource(this.firebaseFirestore, this.firebaseStorageRepository);
  @override
  Future<void> createGroup(BuildContext context, File? groupImage,
      String groupName, List<Contact> selectContacts) async {
    List<String> foundedUids = [];
    String groupPicture = '';
    String groupId = const Uuid().v1();

    try {
      selectContacts.forEach((element) async {
        QuerySnapshot<Map<String, dynamic>> foundedUser =
            await firebaseFirestore
                .collection('users')
                .where('phoneNumber',
                    isEqualTo: element.phones[0].number.replaceAll(' ', ''))
                .get();
        if (foundedUser.docs.isNotEmpty) {
          foundedUser.docs.forEach((element) {
            UserModel userModel = UserModel.fromJson(element.data());
            foundedUids.add(userModel.uID!);
          });
        }
      });
      Either<Failure, String> result =
          await firebaseStorageRepository.saveFileToFirebase(
              'groups/${AppConstants.uID}$groupId', groupImage!);
      result.fold((l) {
        AppConstants.showSnackBar(l.message, context, Colors.red);
      }, (r) {
        groupPicture = r;
      });
      GroupModel groupModel = GroupModel(
          senderId: AppConstants.uID!,
          name: groupName,
          lastMessage: '',
          groupId: groupId,
          groupPic: groupPicture,
          usersUIDs: [AppConstants.uID!, ...foundedUids],
          timeSent: DateTime.now());

      await firebaseFirestore
          .collection('groups')
          .doc(groupId)
          .set(groupModel.toJson());
    } on FirebaseException catch (e) {
      throw FireBaseException(e.code);
    }
  }
}

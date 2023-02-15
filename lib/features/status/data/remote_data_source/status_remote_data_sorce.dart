import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/core/network/failure.dart';
import 'package:whatsapp_clone/core/utilis/constants.dart';
import 'package:whatsapp_clone/features/auth/data/model/user_model.dart';
import 'package:whatsapp_clone/features/status/data/model/status_model.dart';

import '../../../../core/common/firebase_storage/firebase_storage_repository.dart';
import '../../../../core/network/network_exception.dart';

abstract class BaseStatusRemoteDataSource {
  Future<void> uploadStatus({
    required String userName,
    required String profilePic,
    required String phoneNumber,
    required File storyImage,
    required BuildContext context,
  });
  Future<Map<String, List<StatusModel>>> getStatus();
}

class StatusRemoteDataSource extends BaseStatusRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final BaseFirebaseStorageRepository baseFirebaseStorageRepository;

  StatusRemoteDataSource(this.firebaseFirestore, this.firebaseAuth,
      this.baseFirebaseStorageRepository);
  @override
  Future<void> uploadStatus({
    required String userName,
    required String profilePic,
    required String phoneNumber,
    required File storyImage,
    required BuildContext context,
  }) async {
    try {
      String statusId = const Uuid().v1();
      String uID = AppConstants.uID!;
      String statusImageUrl = '';
      List<Contact> contacts = [];
      List<String> whoCanSeeUIDs = [];
      List<String> statusImagesUrl = [];
      Either<Failure, String> result = await baseFirebaseStorageRepository
          .saveFileToFirebase('/status/$statusId$uID', storyImage);
      result.fold((l) {
        AppConstants.showSnackBar(l.message, context, Colors.red);
      }, (r) {
        statusImageUrl = r;
      });

      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(
            withProperties: true, withPhoto: true);
      }
      if (contacts.isNotEmpty) {
        contacts.forEach((element) async {
          QuerySnapshot<Map<String, dynamic>> usersWhoCanSee =
              await firebaseFirestore
                  .collection('users')
                  .where('phoneNumber',
                      isEqualTo: element.phones[0].number.replaceAll(' ', ''))
                  .get();
          if (usersWhoCanSee.docs.isNotEmpty) {
            usersWhoCanSee.docs.forEach((element) {
              UserModel userModel = UserModel.fromJson(element.data());
              whoCanSeeUIDs.add(userModel.uID!);
            });
          }
        });
      }
      QuerySnapshot<Map<String, dynamic>> status = await firebaseFirestore
          .collection('status')
          .where('uID', isEqualTo: AppConstants.uID)
          .get();
      if (status.docs.isNotEmpty) {
        status.docs.forEach((element) async {
          StatusModel statusModel = StatusModel.fromjson(element.data());
          statusImagesUrl = statusModel.photoUrl;
          statusImagesUrl.add(statusImageUrl);
          await firebaseFirestore
              .collection('status')
              .doc(element.id)
              .update({'photoUrl': statusImagesUrl});
        });
      } else {
        statusImagesUrl = [statusImageUrl];
        StatusModel statusModel = StatusModel(
            uID: uID,
            userName: userName,
            phoneNumber: phoneNumber,
            photoUrl: statusImagesUrl,
            createdAt: DateTime.now(),
            profilePic: profilePic,
            statusId: statusId,
            whoCanSee: whoCanSeeUIDs);
        await firebaseFirestore
            .collection('status')
            .doc(statusId)
            .set(statusModel.toMap());
      }
    } on FirebaseException catch (e) {
      throw FireBaseException(e.code);
    }
  }

  @override
  Future<Map<String, List<StatusModel>>> getStatus() async {
    try {
      List<StatusModel> contactsStatusList = [];
      List<StatusModel> myStatusList = [];
      List<Contact> contacts = [];
//myStatus

      QuerySnapshot<Map<String, dynamic>> myStatus = await firebaseFirestore
          .collection('status')
          .where('uID', isEqualTo: AppConstants.uID)
          .where('createdAt',
              isGreaterThan: DateTime.now()
                  .subtract(const Duration(hours: 24))
                  .millisecondsSinceEpoch)
          .get();
      if (myStatus.docs.isNotEmpty) {
        myStatus.docs.forEach((element) {
          StatusModel statusModel = StatusModel.fromjson(element.data());

          myStatusList.add(statusModel);
        });
      }
//contactsStatus
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }

      if (contacts.isNotEmpty) {
        contacts.forEach((element) async {
          QuerySnapshot<Map<String, dynamic>> contactsStatus =
              await firebaseFirestore
                  .collection('status')
                  .where('phoneNumber',
                      isEqualTo: element.phones[0].number.replaceAll(' ', ''))
                  .where('createdAt',
                      isGreaterThan: DateTime.now()
                          .subtract(const Duration(hours: 24))
                          .millisecondsSinceEpoch)
                  .get();
          if (contactsStatus.docs.isNotEmpty) {
            contactsStatus.docs.forEach((element) {
              StatusModel statusModel = StatusModel.fromjson(element.data());
              if (statusModel.whoCanSee.contains(AppConstants.uID)) {
                contactsStatusList.add(statusModel);
              }
            });
          }
        });
      }
      //return two lists
      return {'myStatus': myStatusList, 'contactsStatus': contactsStatusList};
    } on FirebaseAuthException catch (e) {
      throw FireBaseException(e.code);
    }
  }
}

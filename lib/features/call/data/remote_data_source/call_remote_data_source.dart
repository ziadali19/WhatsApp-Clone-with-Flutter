import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/core/utilis/constants.dart';
import 'package:whatsapp_clone/features/call/data/model/call_model.dart';

import '../../../../core/common/firebase_storage/firebase_storage_repository.dart';
import '../../../../core/network/network_exception.dart';

abstract class BaseCallRemoteDataSource {
  Future<void> createCalls(
      CallModel senderCallData, CallModel receiverCallData);
  Stream<CallModel> callsStream();
}

class CallRemoteDataSource extends BaseCallRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final BaseFirebaseStorageRepository firebaseStorageRepository;

  CallRemoteDataSource(this.firebaseFirestore, this.firebaseStorageRepository);
  @override
  Future<void> createCalls(
      CallModel senderCallData, CallModel receiverCallData) async {
    try {
      await firebaseFirestore
          .collection('calls')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());
      await firebaseFirestore
          .collection('calls')
          .doc(receiverCallData.receiverId)
          .set(receiverCallData.toMap());
    } on FirebaseException catch (e) {
      throw FireBaseException(e.code);
    }
  }

  @override
  Stream<CallModel> callsStream() {
    try {
      return firebaseFirestore
          .collection('calls')
          .doc(AppConstants.uID)
          .snapshots()
          .map((event) {
        return CallModel.fromMap(event.data()!);
      });
    } on FirebaseException catch (e) {
      throw FireBaseException(e.code);
    }
  }
}

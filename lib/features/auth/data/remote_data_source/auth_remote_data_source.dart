import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/core/utilis/constants.dart';

import '../../../../core/network/network_exception.dart';
import '../model/user_model.dart';

abstract class BaseAuthRemoteDataSource {
  Future<UserCredential> verifyOTB(
      BuildContext context, String verificationId, String userOTB);
  Future saveUserDataToFirebase(String uID, model, String path);
  Future<UserModel> getUserData();
  Stream<UserModel> getAnyUserData(String uID);
}

class AuthRemoteDataSource extends BaseAuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  AuthRemoteDataSource(this.firebaseAuth, this.firebaseFirestore);

  @override
  Future<UserCredential> verifyOTB(
      BuildContext context, String verificationId, String userOTB) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOTB);
      UserCredential response =
          await firebaseAuth.signInWithCredential(credential);
      return response;
    } on FirebaseAuthException catch (e) {
      throw FireBaseException(e.code);
    }
  }

  @override
  Future saveUserDataToFirebase(String uID, model, path) async {
    try {
      await firebaseFirestore.collection(path).doc(uID).set(model);
    } on FirebaseAuthException catch (e) {
      throw FireBaseException(e.code);
    }
  }

  @override
  Future<UserModel> getUserData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> response = await firebaseFirestore
          .collection('users')
          .doc(AppConstants.uID)
          .get();

      return UserModel.fromJson(response.data());
    } on FirebaseAuthException catch (e) {
      throw FireBaseException(e.code);
    }
  }

  @override
  Stream<UserModel> getAnyUserData(String uID) {
    try {
      Stream<UserModel> response = firebaseFirestore
          .collection('users')
          .doc(uID)
          .snapshots()
          .map((event) => UserModel.fromJson(event.data()));
      return response;
    } on FirebaseException catch (e) {
      throw FireBaseException(e.code);
    }
  }
}

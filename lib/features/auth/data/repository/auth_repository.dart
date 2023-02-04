import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/core/network/failure.dart';
import 'package:whatsapp_clone/core/network/network_exception.dart';
import 'package:whatsapp_clone/core/utilis/constants.dart';
import 'package:whatsapp_clone/features/auth/data/remote_data_source/auth_remote_data_source.dart';

import '../model/user_model.dart';

abstract class BaseAuthRepository {
  Future<Either<Failure, UserCredential>> verifyOTB(
      BuildContext context, String verificationId, String userOTB);
  Future<Either<Failure, void>> saveUserDataToFirebase(String uID, model, path);
  Future<Either<Failure, UserModel>> getUserData();
  Either<Failure, Stream<UserModel>> getAnyUserData(String uID);
}

class AuthRepository extends BaseAuthRepository {
  final BaseAuthRemoteDataSource baseAuthRemoteDataSource;

  AuthRepository(this.baseAuthRemoteDataSource);

  @override
  Future<Either<Failure, UserCredential>> verifyOTB(
      BuildContext context, String verificationId, String userOTB) async {
    try {
      UserCredential result = await baseAuthRemoteDataSource.verifyOTB(
          context, verificationId, userOTB);
      return right(result);
    } on FireBaseException catch (e) {
      return left(FirebaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> saveUserDataToFirebase(
      String uID, model, path) async {
    try {
      await baseAuthRemoteDataSource.saveUserDataToFirebase(uID, model, path);
      return right(null);
    } on FireBaseException catch (e) {
      return left(FirebaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getUserData() async {
    try {
      UserModel result = await baseAuthRemoteDataSource.getUserData();
      return right(result);
    } on FireBaseException catch (e) {
      return left(FirebaseFailure(e.message));
    }
  }

  @override
  Either<Failure, Stream<UserModel>> getAnyUserData(String uID) {
    try {
      return right(baseAuthRemoteDataSource.getAnyUserData(uID));
    } on FireBaseException catch (e) {
      return left(FirebaseFailure(e.message));
    }
  }
}

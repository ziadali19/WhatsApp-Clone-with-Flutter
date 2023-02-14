import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/core/network/network_exception.dart';
import 'package:whatsapp_clone/features/status/data/remote_data_source/status_remote_data_sorce.dart';

import '../../../../core/network/failure.dart';

abstract class BaseStatusRepository {
  Future<Either<Failure, void>> uploadStatus({
    required String userName,
    required String profilePic,
    required String phoneNumber,
    required File storyImage,
    required BuildContext context,
  });
}

class StatusRepository extends BaseStatusRepository {
  final BaseStatusRemoteDataSource baseStatusRemoteDataSource;

  StatusRepository(this.baseStatusRemoteDataSource);
  @override
  Future<Either<Failure, void>> uploadStatus(
      {required String userName,
      required String profilePic,
      required String phoneNumber,
      required File storyImage,
      required BuildContext context}) async {
    try {
      await baseStatusRemoteDataSource.uploadStatus(
          userName: userName,
          profilePic: profilePic,
          phoneNumber: phoneNumber,
          storyImage: storyImage,
          context: context);
      return right(null);
    } on FireBaseException catch (e) {
      throw left(FirebaseFailure(e.message));
    }
  }
}

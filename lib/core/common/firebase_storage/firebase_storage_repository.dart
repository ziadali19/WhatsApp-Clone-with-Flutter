import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:whatsapp_clone/core/common/firebase_storage/firebase_storage_remote_data_source.dart';
import 'package:whatsapp_clone/core/network/network_exception.dart';

import '../../network/failure.dart';

abstract class BaseFirebaseStorageRepository {
  Future<Either<Failure, String>> saveFileToFirebase(String path, File file);
}

class FirebaseStorageRepository extends BaseFirebaseStorageRepository {
  final BaseFirebaseStorageRemoteDataSource baseFirebaseStorageRemoteDataSource;

  FirebaseStorageRepository(this.baseFirebaseStorageRemoteDataSource);

  @override
  Future<Either<Failure, String>> saveFileToFirebase(
      String path, File file) async {
    try {
      String result = await baseFirebaseStorageRemoteDataSource
          .saveFileToFirebase(path, file);
      return right(result);
    } on FireBaseException catch (e) {
      return left(FirebaseFailure(e.message));
    }
  }
}

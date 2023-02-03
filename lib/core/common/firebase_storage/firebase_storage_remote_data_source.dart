import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:whatsapp_clone/core/network/network_exception.dart';

abstract class BaseFirebaseStorageRemoteDataSource {
  Future<String> saveFileToFirebase(String path, File file);
}

class FirebaseStorageRemoteDataSource
    extends BaseFirebaseStorageRemoteDataSource {
  final FirebaseStorage firebaseStorage;

  FirebaseStorageRemoteDataSource(this.firebaseStorage);
  @override
  Future<String> saveFileToFirebase(String path, File file) async {
    try {
      TaskSnapshot uploadTask =
          await firebaseStorage.ref().child(path).putFile(file);
      String downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      throw FireBaseException(e.code);
    }
  }
}

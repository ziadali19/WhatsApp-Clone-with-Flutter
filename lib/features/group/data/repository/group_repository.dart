import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:whatsapp_clone/core/network/network_exception.dart';
import 'package:whatsapp_clone/features/group/data/remote_data_source/group_remote_data_source.dart';

import '../../../../core/network/failure.dart';

abstract class BaseGroupRepository {
  Future<Either<Failure, void>> createGroup(BuildContext context,
      File? groupImage, String groupName, List<Contact> selectContacts);
}

class GroupRepository extends BaseGroupRepository {
  final BaseGroupRemoteDataSource baseGroupRemoteDataSource;

  GroupRepository(this.baseGroupRemoteDataSource);

  @override
  Future<Either<Failure, void>> createGroup(BuildContext context,
      File? groupImage, String groupName, List<Contact> selectContacts) async {
    try {
      await baseGroupRemoteDataSource.createGroup(
          context, groupImage, groupName, selectContacts);
      return right(null);
    } on FireBaseException catch (e) {
      return left(FirebaseFailure(e.message));
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:whatsapp_clone/core/network/failure.dart';
import 'package:whatsapp_clone/core/network/network_exception.dart';
import 'package:whatsapp_clone/features/layout/data/remote_data_source/layout_remote_data_source.dart';

import '../../../chat/data/model/chat_contact_model.dart';
import '../../../group/data/model/group_model.dart';

abstract class BaseLayoutRepository {
  Either<Failure, Stream<List<ChatContactModel>>> getContactsChats();
  Either<Failure, Stream<List<GroupModel>>> getGroupsChats();
}

class LayoutRepository extends BaseLayoutRepository {
  final BaseLayoutRemoteDataSource baseLayoutRemoteDataSource;

  LayoutRepository(this.baseLayoutRemoteDataSource);
  @override
  Either<Failure, Stream<List<ChatContactModel>>> getContactsChats() {
    try {
      return right(baseLayoutRemoteDataSource.getContactsChats());
    } on FireBaseException catch (e) {
      return left(FirebaseFailure(e.message));
    }
  }

  @override
  Either<Failure, Stream<List<GroupModel>>> getGroupsChats() {
    try {
      return right(baseLayoutRemoteDataSource.getGroupsChats());
    } on FireBaseException catch (e) {
      return left(FirebaseFailure(e.message));
    }
  }
}

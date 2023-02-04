import 'package:dartz/dartz.dart';
import 'package:whatsapp_clone/core/network/network_exception.dart';
import 'package:whatsapp_clone/features/chat/data/remote_data_source/chat_remote_data_source.dart';

import '../../../../core/network/failure.dart';
import '../../../auth/data/model/user_model.dart';

abstract class BaseChatRepository {
  Future<Either<Failure, void>> sendTextMessage({
    required UserModel senderUser,
    required String recieverId,
    required String text,
  });
}

class ChatRepository extends BaseChatRepository {
  final BaseChatRemoteDataSource baseChatRemoteDataSource;

  ChatRepository(this.baseChatRemoteDataSource);
  @override
  Future<Either<Failure, void>> sendTextMessage(
      {required UserModel senderUser,
      required String recieverId,
      required String text}) async {
    try {
      await baseChatRemoteDataSource.sendTextMessage(
          senderUser: senderUser, recieverId: recieverId, text: text);
      return right(null);
    } on FireBaseException catch (e) {
      return left(FirebaseFailure(e.message));
    }
  }
}

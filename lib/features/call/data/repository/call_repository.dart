import 'package:dartz/dartz.dart';
import 'package:whatsapp_clone/core/network/network_exception.dart';
import 'package:whatsapp_clone/core/utilis/constants.dart';
import 'package:whatsapp_clone/features/auth/data/repository/auth_repository.dart';
import 'package:whatsapp_clone/features/call/data/remote_data_source/call_remote_data_source.dart';

import '../../../../core/network/failure.dart';
import '../../../auth/data/model/user_model.dart';
import '../model/call_model.dart';

abstract class BaseCallRepository {
  Future<Either<Failure, void>> createCalls(
      CallModel senderCallData, CallModel receiverCallData);

  Either<Failure, Stream<CallModel>> callsStream();
}

class CallRepository extends BaseCallRepository {
  final BaseCallRemoteDataSource baseCallRemoteDataSource;

  CallRepository(this.baseCallRemoteDataSource);

  @override
  Future<Either<Failure, void>> createCalls(
      CallModel senderCallData, CallModel receiverCallData) async {
    try {
      await baseCallRemoteDataSource.createCalls(
          senderCallData, receiverCallData);
      return right(null);
    } on FireBaseException catch (e) {
      return left(FirebaseFailure(e.message));
    }
  }

  @override
  Either<Failure, Stream<CallModel>> callsStream() {
    try {
      return right(baseCallRemoteDataSource.callsStream());
    } on FireBaseException catch (e) {
      return left(FirebaseFailure(e.message));
    }
  }
}

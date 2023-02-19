import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/core/network/failure.dart';
import 'package:whatsapp_clone/core/utilis/constants.dart';
import 'package:whatsapp_clone/features/call/data/repository/call_repository.dart';

import '../../../auth/data/model/user_model.dart';
import '../../../auth/data/repository/auth_repository.dart';
import '../../data/model/call_model.dart';

part 'call_state.dart';

class CallCubit extends Cubit<CallState> {
  final BaseCallRepository baseCallRepository;
  final BaseAuthRepository baseAuthRepository;
  CallCubit(this.baseCallRepository, this.baseAuthRepository)
      : super(CallInitial());
  static CallCubit get(BuildContext context) {
    return BlocProvider.of(context);
  }

  createCalls(String receiverId, String receiverName, String receiverPic,
      bool isGroupChat) async {
    emit(CreatCallLoading());
    String callId = const Uuid().v1();
    CallModel senderCallData = CallModel(
        callerId: AppConstants.uID!,
        callerName: userModel!.name!,
        callerPic: userModel!.profilePic!,
        receiverId: receiverId,
        receiverName: receiverName,
        receiverPic: receiverPic,
        callId: callId,
        hasCall: true);
    CallModel receiverCallData = CallModel(
        callerId: AppConstants.uID!,
        callerName: userModel!.name!,
        callerPic: userModel!.profilePic!,
        receiverId: receiverId,
        receiverName: receiverName,
        receiverPic: receiverPic,
        callId: callId,
        hasCall: false);
    Either<Failure, void> result =
        await baseCallRepository.createCalls(senderCallData, receiverCallData);

    result.fold((l) {
      emit(CreatCallError(l.message));
    }, (r) {
      emit(CreatCallSuccess());
    });
  }

  UserModel? userModel;
  getUserData() async {
    emit(GetUserDataCallLoading());
    Either<Failure, UserModel> result = await baseAuthRepository.getUserData();
    result.fold((l) {
      emit(GetUserDataCallError(l.message));
    }, (r) {
      userModel = r;
      emit(GetUserDataCallSuccess());
    });
  }

  Stream<CallModel>? callsStream(context) {
    Stream<CallModel>? calls;
    Either<Failure, Stream<CallModel>> result =
        baseCallRepository.callsStream();

    result.fold((l) {
      AppConstants.showSnackBar(l.message, context, Colors.red);
    }, (r) {
      calls = r;
    });
    return calls;
  }
}

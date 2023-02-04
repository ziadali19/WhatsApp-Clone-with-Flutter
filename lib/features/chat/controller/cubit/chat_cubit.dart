import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:whatsapp_clone/core/network/failure.dart';
import 'package:whatsapp_clone/core/utilis/constants.dart';
import 'package:whatsapp_clone/features/auth/data/repository/auth_repository.dart';
import 'package:whatsapp_clone/features/chat/data/repository/chat_repository.dart';

import '../../../auth/data/model/user_model.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(this.baseAuthRepository, this.baseChatRepository)
      : super(ChatInitial());
  final BaseAuthRepository baseAuthRepository;
  final BaseChatRepository baseChatRepository;

  static ChatCubit get(context) {
    return BlocProvider.of(context);
  }

  Stream<UserModel>? getAnyUserData(String uID, context) {
    Stream<UserModel>? userModel;
    baseAuthRepository.getAnyUserData(uID).fold((l) {
      AppConstants.showSnackBar(l.message, context, Colors.red);
    }, (r) {
      userModel = r;
    });
    return userModel;
  }

  sendTextMessage({
    required UserModel senderUser,
    required String recieverId,
    required String text,
  }) async {
    emit(SendMessageLoading());
    Either<Failure, void> result = await baseChatRepository.sendTextMessage(
        senderUser: senderUser, recieverId: recieverId, text: text);
    result.fold((l) {
      emit(SendMessageError(l.message));
    }, (r) {
      emit(SendMessageSuccess());
    });
  }

  UserModel? userModel;
  getUserData() async {
    emit(GetUserDataLoading());
    Either<Failure, UserModel> result = await baseAuthRepository.getUserData();
    result.fold((l) {
      emit(GetUserDataError(l.message));
    }, (r) {
      userModel = r;
      emit(GetUserDataSuccess());
    });
  }
}

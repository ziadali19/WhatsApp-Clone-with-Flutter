import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:whatsapp_clone/core/network/failure.dart';
import 'package:whatsapp_clone/core/utilis/constants.dart';
import 'package:whatsapp_clone/features/auth/data/repository/auth_repository.dart';
import 'package:whatsapp_clone/features/status/data/repository/status_repository.dart';

import '../../../auth/data/model/user_model.dart';

part 'status_state.dart';

class StatusCubit extends Cubit<StatusState> {
  StatusCubit(this.baseStatusRepository, this.baseAuthRepository)
      : super(StatusInitial());
  final BaseStatusRepository baseStatusRepository;
  final BaseAuthRepository baseAuthRepository;
  static StatusCubit get(BuildContext context) {
    return BlocProvider.of(context);
  }

  uploadStatus(
      {required String userName,
      required String profilePic,
      required String phoneNumber,
      required File storyImage,
      required BuildContext context}) async {
    emit(UploadStoryLoading());
    Either<Failure, void> result = await baseStatusRepository.uploadStatus(
        userName: userName,
        profilePic: profilePic,
        phoneNumber: phoneNumber,
        storyImage: storyImage,
        context: context);

    result.fold((l) {
      emit(UploadStoryError(l.message));
    }, (r) {
      emit(UploadStorySuccess());
    });
  }

  UserModel? userModel;
  getUserData(context) async {
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

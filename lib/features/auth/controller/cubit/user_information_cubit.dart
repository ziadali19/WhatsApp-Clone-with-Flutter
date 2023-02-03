import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:whatsapp_clone/core/network/failure.dart';
import 'package:whatsapp_clone/core/utilis/cashe_helper.dart';

import 'package:whatsapp_clone/core/utilis/constants.dart';
import 'package:whatsapp_clone/features/auth/data/model/user_model.dart';
import 'package:whatsapp_clone/features/auth/data/repository/auth_repository.dart';

import '../../../../core/common/firebase_storage/firebase_storage_repository.dart';

part 'user_information_state.dart';

class UserInformationCubit extends Cubit<UserInformationState> {
  final BaseFirebaseStorageRepository baseFirebaseStorageRepository;
  final BaseAuthRepository baseAuthRepository;
  final FirebaseAuth firebaseAuth;

  UserInformationCubit(this.baseFirebaseStorageRepository, this.firebaseAuth,
      this.baseAuthRepository)
      : super(UserInformationInitial());
  static UserInformationCubit get(context) {
    return BlocProvider.of(context);
  }

  File? profileImage;
  selectImage(context) async {
    profileImage = await AppConstants.imagePicker(context);
    emit(UpdateProfileImage());
  }

  saveUserDataToFirebase(String name, File? image, BuildContext context) async {
    String uID = AppConstants.uID!;
    String profilePic = '';
    if (image != null) {
      emit(UploadProfileImageLoading());
      Either<Failure, String> result = await baseFirebaseStorageRepository
          .saveFileToFirebase('profilePic/$uID', image);
      result.fold((l) {
        emit(UploadProfileImageError(l.message));
      }, (r) {
        profilePic = r;
        emit(UploadProfileImageSuccess());
      });
    }
    UserModel userModel = UserModel(
        name: name,
        uID: uID,
        profilePic: profilePic,
        isOnline: true,
        phoneNumber: firebaseAuth.currentUser!.phoneNumber,
        groupId: []);
    emit(SaveUserDataToFirebaseLoading());
    Either<Failure, void> result1 = await baseAuthRepository
        .saveUserDataToFirebase(uID, userModel.toJson(), 'users');

    result1.fold((l) {
      emit(SaveUserDataToFirebaseError(l.message));
    }, (r) {
      emit(SaveUserDataToFirebaseSuccess());
      getUserData();
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
      CasheHelper.saveData('user', userModel!.uID);
      AppConstants.user = userModel!.uID;
    });
  }
}

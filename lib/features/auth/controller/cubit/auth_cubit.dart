import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:whatsapp_clone/core/network/network_exception.dart';

import '../../../../core/network/failure.dart';
import '../../../../core/utilis/constants.dart';
import '../../data/repository/auth_repository.dart';
import '../../presentation/screens/otb_screen.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final BaseAuthRepository baseAuthRepository;
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  AuthCubit(this.baseAuthRepository, this.firebaseAuth, this.firebaseFirestore)
      : super(AuthInitial());
  static AuthCubit get(context) {
    return BlocProvider.of(context);
  }

  Future signInWithPhoneNumber(BuildContext context, String phoneNumber) async {
    emit(AuthLoading());
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (phoneAuthCredential) async {
        await firebaseAuth.signInWithCredential(phoneAuthCredential);
      },
      verificationFailed: (error) {
        emit(AuthError(error.code));
      },
      codeSent: (verificationId, forceResendingToken) {
        Navigator.pushNamed(context, OTBScreen.routeName,
            arguments: verificationId);

        emit(AuthSuccess());
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  String phonecode = '20';
  changePhoneCode(value) {
    phonecode = value;
    emit(ChangePhoneCode());
  }
}

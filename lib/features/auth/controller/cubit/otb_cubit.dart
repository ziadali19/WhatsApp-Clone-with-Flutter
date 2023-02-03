import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_clone/core/network/failure.dart';
import 'package:whatsapp_clone/core/utilis/cashe_helper.dart';
import 'package:whatsapp_clone/core/utilis/constants.dart';
import 'package:whatsapp_clone/features/auth/data/repository/auth_repository.dart';
import 'package:whatsapp_clone/features/auth/presentation/screens/user_information_screen.dart';

part 'otb_state.dart';

class OtbCubit extends Cubit<OtbState> {
  final BaseAuthRepository baseAuthRepository;
  OtbCubit(this.baseAuthRepository) : super(OtbInitial());
  static OtbCubit get(context) {
    return BlocProvider.of(context);
  }

  UserCredential? userCredential;
  verifyOTB(BuildContext context, String verificationId, String userOTB) async {
    emit(OtbLoading());
    Either<Failure, UserCredential> result =
        await baseAuthRepository.verifyOTB(context, verificationId, userOTB);
    result.fold((l) {
      emit(OtbError(l.message));
      AppConstants.showSnackBar(l.message, context, Colors.red);
    }, (r) {
      userCredential = r;
      CasheHelper.saveData('uID', userCredential!.user!.uid);
      AppConstants.uID = userCredential!.user!.uid;
      emit(OtbSuccess());
      Navigator.pushNamedAndRemoveUntil(
          context, UserInformationScreen.routeName, (route) => false);
    });
  }
}

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_clone/core/network/failure.dart';
import 'package:whatsapp_clone/features/chat/data/repository/chat_repository.dart';
import 'package:whatsapp_clone/features/group/data/model/group_model.dart';

import '../../../../core/utilis/constants.dart';
import '../../../chat/data/model/chat_contact_model.dart';
import '../../data/repository/layout_repository.dart';

part 'layout_state.dart';

class LayoutCubit extends Cubit<LayoutState> {
  final BaseLayoutRepository baseLayoutRepository;
  final BaseChatRepository baseChatRepository;
  LayoutCubit(this.baseLayoutRepository, this.baseChatRepository)
      : super(LayoutInitial());
  static LayoutCubit get(BuildContext context) {
    return BlocProvider.of(context);
  }

  Stream<List<ChatContactModel>>? getContactsChats(context) {
    Stream<List<ChatContactModel>>? chatContacts;
    Either<Failure, Stream<List<ChatContactModel>>> result =
        baseLayoutRepository.getContactsChats();
    result.fold((l) {
      AppConstants.showSnackBar(l.message, context, Colors.red);
    }, (r) {
      chatContacts = r;
    });
    return chatContacts;
  }

  Stream<List<GroupModel>>? getGroupsChats(context) {
    Stream<List<GroupModel>>? chatContacts;
    Either<Failure, Stream<List<GroupModel>>> result =
        baseLayoutRepository.getGroupsChats();
    result.fold((l) {
      AppConstants.showSnackBar(l.message, context, Colors.red);
    }, (r) {
      chatContacts = r;
    });
    return chatContacts;
  }
}

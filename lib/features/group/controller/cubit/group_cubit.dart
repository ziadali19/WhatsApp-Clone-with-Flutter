import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:whatsapp_clone/core/network/failure.dart';
import 'package:whatsapp_clone/features/group/data/repository/group_repository.dart';

import 'package:whatsapp_clone/features/select_contacts/data/repository/contacts_repository.dart';

import '../../../../core/utilis/constants.dart';

part 'group_state.dart';

class GroupCubit extends Cubit<GroupState> {
  final BaseContactsRepository baseContactsRepository;
  final BaseGroupRepository baseGroupRepository;
  GroupCubit(this.baseContactsRepository, this.baseGroupRepository)
      : super(GroupInitial());
  static GroupCubit get(context) {
    return BlocProvider.of(context);
  }

  File? groupImage;
  selectImage(context) async {
    groupImage = await AppConstants.imagePicker(context);
    emit(UpdateGroupImage());
  }

  List<Contact> contacts = [];
  getContacts() async {
    emit(GetContactsForGroupLoading());
    contacts = await baseContactsRepository.getContacts();
    emit(GetContactsForGroupSuccess());
  }

  List<int> selectContactsIndecies = [];
  List<Contact> selectContacts = [];
  selectContact(int index, Contact contact) {
    if (selectContactsIndecies.contains(index) &&
        selectContacts.contains(contact)) {
      selectContactsIndecies.remove(index);
      selectContacts.remove(contact);
    } else {
      selectContactsIndecies.add(index);
      selectContacts.add(contact);
    }

    emit(SelectContact());
  }

  createGroup(BuildContext context, File? groupImage, String groupName,
      List<Contact> selectContacts) async {
    emit(CreateGroupLoading());
    Either<Failure, void> result = await baseGroupRepository.createGroup(
        context, groupImage, groupName, selectContacts);

    result.fold((l) {
      emit(CreateGroupError(l.message));
    }, (r) {
      emit(CreateGroupSuccess());
    });
  }
}

part of 'group_cubit.dart';

@immutable
abstract class GroupState {}

class GroupInitial extends GroupState {}

class UpdateGroupImage extends GroupState {}

class GetContactsForGroupLoading extends GroupState {}

class GetContactsForGroupSuccess extends GroupState {}

class SelectContact extends GroupState {}

class CreateGroupLoading extends GroupState {}

class CreateGroupSuccess extends GroupState {}

class CreateGroupError extends GroupState {
  final String? errorMsg;

  CreateGroupError(this.errorMsg);
}

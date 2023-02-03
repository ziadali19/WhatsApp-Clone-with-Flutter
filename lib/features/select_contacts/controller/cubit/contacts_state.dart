part of 'contacts_cubit.dart';

@immutable
abstract class ContactsState {}

class ContactsInitial extends ContactsState {}

class GetContactsSuccess extends ContactsState {}

class GetContactsLoading extends ContactsState {}

class SelectContactError extends ContactsState {
  final String? errorMsg;

  SelectContactError(this.errorMsg);
}

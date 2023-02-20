import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/contact.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:whatsapp_clone/features/select_contacts/data/repository/contacts_repository.dart';

part 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  ContactsCubit(this.baseContactsRepository) : super(ContactsInitial());

  static ContactsCubit get(context) {
    return BlocProvider.of(context);
  }

  final BaseContactsRepository baseContactsRepository;
  List<Contact> contacts = [];
  getContacts() async {
    emit(GetContactsLoading());
    contacts = await baseContactsRepository.getContacts();
    emit(GetContactsSuccess());
  }

  selectContact(Contact contact, context) async {
    var result = await baseContactsRepository.selectContact(contact, context);
    result.fold((l) {
      emit(SelectContactError(l.message));
    }, (r) => null);
  }
}

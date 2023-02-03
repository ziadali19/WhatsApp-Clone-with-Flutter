import 'package:dartz/dartz.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:whatsapp_clone/core/network/network_exception.dart';
import 'package:whatsapp_clone/features/select_contacts/data/local_data_source/contacts_local_data_source.dart';

import '../../../../core/network/failure.dart';

abstract class BaseContactsRepository {
  Future<List<Contact>> getContacts();
  Future<Either<Failure, void>> selectContact(Contact contact, context);
}

class ContactsRepository extends BaseContactsRepository {
  final BaseContactsLocalDataSource baseContactsLocalDataSource;

  ContactsRepository(this.baseContactsLocalDataSource);
  @override
  Future<List<Contact>> getContacts() async {
    return await baseContactsLocalDataSource.getContacts();
  }

  @override
  Future<Either<Failure, void>> selectContact(Contact contact, context) async {
    try {
      await baseContactsLocalDataSource.selectContact(contact, context);
      return right(null);
    } on FireBaseException catch (e) {
      return left(FirebaseFailure(e.message));
    }
  }
}

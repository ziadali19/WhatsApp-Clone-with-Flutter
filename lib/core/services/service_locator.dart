import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:whatsapp_clone/features/auth/controller/cubit/user_information_cubit.dart';

import '../../features/auth/controller/cubit/auth_cubit.dart';
import '../../features/auth/controller/cubit/otb_cubit.dart';
import '../../features/auth/data/remote_data_source/auth_remote_data_source.dart';
import '../../features/auth/data/repository/auth_repository.dart';
import '../../features/chat/controller/cubit/chat_cubit.dart';

import '../../features/chat/data/remote_data_source/chat_remote_data_source.dart';
import '../../features/chat/data/repository/chat_repository.dart';
import '../../features/select_contacts/controller/cubit/contacts_cubit.dart';
import '../../features/select_contacts/data/local_data_source/contacts_local_data_source.dart';
import '../../features/select_contacts/data/repository/contacts_repository.dart';
import '../common/firebase_storage/firebase_storage_remote_data_source.dart';
import '../common/firebase_storage/firebase_storage_repository.dart';

final sl = GetIt.instance;

class ServicesLocator {
  static void init() {
    sl.registerFactory(() =>
        AuthCubit(sl(), FirebaseAuth.instance, FirebaseFirestore.instance));
    sl.registerFactory(() => OtbCubit(sl()));
    sl.registerLazySingleton<BaseAuthRepository>(() => AuthRepository(sl()));
    sl.registerLazySingleton<BaseAuthRemoteDataSource>(() =>
        AuthRemoteDataSource(
            FirebaseAuth.instance, FirebaseFirestore.instance));

    sl.registerFactory(
        () => UserInformationCubit(sl(), FirebaseAuth.instance, sl()));

    sl.registerLazySingleton<BaseFirebaseStorageRepository>(
        () => FirebaseStorageRepository(sl()));
    sl.registerLazySingleton<BaseFirebaseStorageRemoteDataSource>(
        () => FirebaseStorageRemoteDataSource(FirebaseStorage.instance));

    sl.registerFactory(() => ContactsCubit(sl()));
    sl.registerLazySingleton<BaseContactsRepository>(
        () => ContactsRepository(sl()));
    sl.registerLazySingleton<BaseContactsLocalDataSource>(
        () => ContactsLocalDataSource(FirebaseFirestore.instance));

    sl.registerFactory(() => ChatCubit(sl(), sl()));
    sl.registerLazySingleton<BaseChatRepository>(() => ChatRepository(sl()));
    sl.registerLazySingleton<BaseChatRemoteDataSource>(() =>
        ChatRemoteDataSource(
            FirebaseFirestore.instance, FirebaseAuth.instance));
  }
}
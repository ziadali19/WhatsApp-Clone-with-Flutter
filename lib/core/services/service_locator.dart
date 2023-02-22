import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:whatsapp_clone/features/auth/controller/cubit/user_information_cubit.dart';

import '../../features/auth/controller/cubit/auth_cubit.dart';
import '../../features/auth/controller/cubit/otb_cubit.dart';
import '../../features/auth/data/remote_data_source/auth_remote_data_source.dart';
import '../../features/auth/data/repository/auth_repository.dart';
import '../../features/call/controller/cubit/call_cubit.dart';
import '../../features/call/data/remote_data_source/call_remote_data_source.dart';
import '../../features/call/data/repository/call_repository.dart';
import '../../features/chat/controller/cubit/chat_cubit.dart';

import '../../features/chat/controller/cubit/text_field_cubit.dart';
import '../../features/chat/data/remote_data_source/chat_remote_data_source.dart';
import '../../features/chat/data/repository/chat_repository.dart';
import '../../features/group/controller/cubit/group_cubit.dart';
import '../../features/group/data/remote_data_source/group_remote_data_source.dart';
import '../../features/group/data/repository/group_repository.dart';
import '../../features/layout/controller/cubit/layout_cubit.dart';
import '../../features/layout/data/remote_data_source/layout_remote_data_source.dart';
import '../../features/layout/data/repository/layout_repository.dart';

import '../../features/select_contacts/controller/cubit/contacts_cubit.dart';
import '../../features/select_contacts/data/local_data_source/contacts_local_data_source.dart';
import '../../features/select_contacts/data/repository/contacts_repository.dart';
import '../../features/status/controller/cubit/status_cubit.dart';
import '../../features/status/data/remote_data_source/status_remote_data_sorce.dart';
import '../../features/status/data/repository/status_repository.dart';
import '../common/firebase_storage/firebase_storage_remote_data_source.dart';
import '../common/firebase_storage/firebase_storage_repository.dart';

final sl = GetIt.instance;

class ServicesLocator {
  static void init() {
    sl.registerLazySingleton<FirebaseFirestore>(
        () => FirebaseFirestore.instance);
    sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

    sl.registerFactory(() => AuthCubit(sl(), sl(), sl()));
    sl.registerFactory(() => OtbCubit(sl()));
    sl.registerLazySingleton<BaseAuthRepository>(() => AuthRepository(sl()));
    sl.registerLazySingleton<BaseAuthRemoteDataSource>(
        () => AuthRemoteDataSource(sl(), sl()));

    sl.registerFactory(() => UserInformationCubit(sl(), sl(), sl()));

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
    sl.registerLazySingleton<BaseChatRemoteDataSource>(
        () => ChatRemoteDataSource(sl(), sl(), sl()));

    sl.registerFactory(() => LayoutCubit(sl(), sl()));
    sl.registerLazySingleton<BaseLayoutRepository>(
        () => LayoutRepository(sl()));
    sl.registerLazySingleton<BaseLayoutRemoteDataSource>(
        () => LayoutRemoteDataSource(sl()));

    sl.registerFactory(() => StatusCubit(sl(), sl()));
    sl.registerLazySingleton<BaseStatusRepository>(
        () => StatusRepository(sl()));
    sl.registerLazySingleton<BaseStatusRemoteDataSource>(
        () => StatusRemoteDataSource(sl(), sl(), sl()));

    sl.registerFactory(() => GroupCubit(sl(), sl()));
    sl.registerLazySingleton<BaseGroupRepository>(() => GroupRepository(sl()));
    sl.registerLazySingleton<BaseGroupRemoteDataSource>(
        () => GroupRemoteDataSource(sl(), sl()));

    sl.registerFactory(() => CallCubit(sl(), sl()));
    sl.registerLazySingleton<BaseCallRepository>(() => CallRepository(sl()));
    sl.registerLazySingleton<BaseCallRemoteDataSource>(
        () => CallRemoteDataSource(sl(), sl()));

    sl.registerFactory(() => TextFieldCubit(sl(), sl()));
  }
}

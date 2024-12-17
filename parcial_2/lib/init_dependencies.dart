import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:parcial_2/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:parcial_2/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:parcial_2/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:parcial_2/features/auth/domain/repositories/auth_repository.dart';
import 'package:parcial_2/features/auth/domain/usecases/current_user.dart';
import 'package:parcial_2/features/auth/domain/usecases/user_google_login.dart';
import 'package:parcial_2/features/auth/domain/usecases/user_login.dart';
import 'package:parcial_2/features/auth/domain/usecases/user_sign_up.dart';
import 'package:parcial_2/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:parcial_2/features/posts/data/datasources/entry_remote_data_source.dart';
import 'package:parcial_2/features/posts/data/repositories/entry_repository_impl.dart';
import 'package:parcial_2/features/posts/domain/repositories/entry_repository.dart';
import 'package:parcial_2/features/posts/domain/usecases/delete_entry.dart';
import 'package:parcial_2/features/posts/domain/usecases/get_all_entries.dart';
import 'package:parcial_2/features/posts/domain/usecases/get_entry.dart';
import 'package:parcial_2/features/posts/domain/usecases/update_entry.dart';
import 'package:parcial_2/features/posts/domain/usecases/upload_entry.dart';
import 'package:parcial_2/features/posts/presentation/bloc/entry_bloc.dart';
import 'package:parcial_2/firebase_options.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initEntry();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  serviceLocator.registerLazySingleton(() => FirebaseAuth.instance);
  serviceLocator.registerLazySingleton(() => FirebaseFirestore.instance);

  // Core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  // Datasource
  serviceLocator
  ..registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      serviceLocator<FirebaseAuth>(),
      serviceLocator<FirebaseFirestore>(),
    ),
  )
  // Repository
  ..registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      serviceLocator(),
    ),
  )
  // Use cases
  ..registerFactory(
    () => UserSignUp(
      serviceLocator(),
    ),
  )
  ..registerFactory(
    () => UserLogin(
      serviceLocator(),
    ),
  )
  ..registerFactory(
    () => UserGoogleLogin(
      serviceLocator(),
    ),
  )
  ..registerFactory(
    () => CurrentUser(
      serviceLocator(),
    ),
  )
  // Bloc
  ..registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userLogin: serviceLocator(),
      currentUser: serviceLocator(),
      appUserCubit: serviceLocator(),
      userGoogleLogin: serviceLocator(),
    ),
  );
}

void _initEntry() {
  // Datasource
  serviceLocator
  ..registerFactory<EntryRemoteDataSource>(
    () => EntryRemoteDataSourceImpl(
      serviceLocator<FirebaseFirestore>(),
    ),
  )
  // Repository
  ..registerFactory<EntryRepository>(
    () => EntryRepositoryImpl(
      entryRemoteDataSource: serviceLocator(),
    ),
  )
  // Use cases
  ..registerFactory(
    () => UploadEntry(
      serviceLocator(),
    ),
  )
  ..registerFactory(
    () => GetAllEntries(
      serviceLocator(),
    ),
  )
  ..registerFactory(
    () => GetEntry(
      serviceLocator(),
    ),
  )
  ..registerFactory(
    () => DeleteEntry(
      serviceLocator(),
    ),
  )
  ..registerFactory(
    () => UpdateEntry(
      serviceLocator(),
    ),
  )
  // Bloc
  ..registerLazySingleton(
    () => EntryBloc(
      uploadEntry: serviceLocator(),
      getAllEntries: serviceLocator(),
      deleteEntry: serviceLocator(),
      updateEntry: serviceLocator(),
    ),
  );
}
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:fpdart/fpdart.dart';
import 'package:parcial_2/core/error/failures.dart';
import 'package:parcial_2/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:parcial_2/core/common/entities/user.dart';
import 'package:parcial_2/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUserData();
      if(user == null) {
        return left(Failure('User not logged in'));
      }
      return right(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return left(Failure(e.message ?? 'Firebase Auth Error'));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password
  }) async {
    
    return _getUser(() async => await remoteDataSource.loginWithEmailPassword(
      email: email,
      password: password,
    ));
  }

  @override
  Future<Either<Failure, User>> loginWithGoogle(String idToken) async {
    return _getUser(() async => await remoteDataSource.loginWithGoogle(idToken));
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {

    return _getUser(() async => await remoteDataSource.signUpWithEmailPassword(
      userName: name,
      email: email,
      password: password,
    ));
  }

  Future<Either<Failure, User>> _getUser(
    Future<User> Function() fn,
  ) async {
    try {
      final user = await fn();

      return right(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return left(Failure(e.message ?? 'Firebase Auth Error'));
    }
  }

  Future<Either<Failure, String>> getCurrentUsername() async {
    final result = await currentUser();
    return result.fold(
      (failure) => left(failure),
      (user) => right(user.name),
    );
  }
}

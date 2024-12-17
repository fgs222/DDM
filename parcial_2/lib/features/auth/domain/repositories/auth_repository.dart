
import 'package:fpdart/fpdart.dart';
import 'package:parcial_2/core/error/failures.dart';
import 'package:parcial_2/core/common/entities/user.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> loginWithGoogle(String idToken);
  Future<Either<Failure, User>> currentUser();
}
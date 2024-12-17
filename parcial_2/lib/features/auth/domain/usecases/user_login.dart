import 'package:fpdart/fpdart.dart';
import 'package:parcial_2/core/error/failures.dart';
import 'package:parcial_2/core/usecase/usecase.dart';
import 'package:parcial_2/core/common/entities/user.dart';
import 'package:parcial_2/features/auth/domain/repositories/auth_repository.dart';

class UserLogin implements UseCase<User, UserLoginParams> {
  final AuthRepository authRepository;
  const UserLogin(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserLoginParams params) {
    return authRepository.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserLoginParams {
  final String email;
  final String password;

  UserLoginParams({
    required this.email,
    required this.password,
  });
}

class UserLoginWithGoogle implements UseCase<User, String> {
  final AuthRepository authRepository;

  const UserLoginWithGoogle(this.authRepository);

  @override
  Future<Either<Failure, User>> call(String idToken) {
    return authRepository.loginWithGoogle(idToken);
  }
}
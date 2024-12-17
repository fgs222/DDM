import 'package:fpdart/fpdart.dart';
import 'package:parcial_2/core/error/failures.dart';
import 'package:parcial_2/core/usecase/usecase.dart';
import 'package:parcial_2/core/common/entities/user.dart';
import 'package:parcial_2/features/auth/domain/repositories/auth_repository.dart';

class UserGoogleLogin implements UseCase<User, String> {
  final AuthRepository authRepository;

  const UserGoogleLogin(this.authRepository);

  @override
  Future<Either<Failure, User>> call(String idToken) {
    return authRepository.loginWithGoogle(idToken);
  }
}

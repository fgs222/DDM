import 'package:fpdart/fpdart.dart';
import 'package:parcial_2/core/error/failures.dart';
import 'package:parcial_2/core/usecase/usecase.dart';
import 'package:parcial_2/core/common/entities/user.dart';
import 'package:parcial_2/features/auth/domain/repositories/auth_repository.dart';

class CurrentUser implements UseCase<User, NoParams> {
  final AuthRepository authRepository;

  CurrentUser(this.authRepository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authRepository.currentUser();
  }
}


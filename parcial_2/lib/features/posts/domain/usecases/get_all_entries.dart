import 'package:fpdart/fpdart.dart';
import 'package:parcial_2/core/error/failures.dart';
import 'package:parcial_2/core/usecase/usecase.dart';
import 'package:parcial_2/features/posts/domain/entities/entry.dart';
import 'package:parcial_2/features/posts/domain/repositories/entry_repository.dart';

class GetAllEntries implements UseCase<List<Entry>, NoParams> {
  final EntryRepository entryRepository;

  GetAllEntries(this.entryRepository);

  @override
  Future<Either<Failure, List<Entry>>> call(NoParams params) async {
    return await entryRepository.getAllEntries();
  }
}
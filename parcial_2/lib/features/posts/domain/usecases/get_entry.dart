import 'package:fpdart/fpdart.dart';
import 'package:parcial_2/core/error/failures.dart';
import 'package:parcial_2/core/usecase/usecase.dart';
import 'package:parcial_2/features/posts/domain/entities/entry.dart';
import 'package:parcial_2/features/posts/domain/repositories/entry_repository.dart';

class GetEntry implements UseCase<Entry, String> {
  final EntryRepository entryRepository;

  GetEntry(this.entryRepository);

  @override
  Future<Either<Failure, Entry>> call(String entryId) async {
    return await entryRepository.getEntry(entryId);
  }
}
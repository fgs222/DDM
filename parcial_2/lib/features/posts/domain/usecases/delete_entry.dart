import 'package:fpdart/fpdart.dart';
import 'package:parcial_2/core/error/failures.dart';
import 'package:parcial_2/core/usecase/usecase.dart';
import 'package:parcial_2/features/posts/domain/repositories/entry_repository.dart';

class DeleteEntry implements UseCase<void, DeleteEntryParams> {
  final EntryRepository entryRepository;

  DeleteEntry(this.entryRepository);

  @override
  Future<Either<Failure, void>> call(DeleteEntryParams params) async {
    return await entryRepository.deleteEntry(params.entryId);
  }
}

class DeleteEntryParams {
  final String entryId;

  DeleteEntryParams({
    required this.entryId,
  });
}
import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:parcial_2/core/error/failures.dart';
import 'package:parcial_2/core/usecase/usecase.dart';
import 'package:parcial_2/features/posts/domain/entities/entry.dart';
import 'package:parcial_2/features/posts/domain/repositories/entry_repository.dart';

class UpdateEntry implements UseCase<Entry, UpdateEntryParams> {
  final EntryRepository entryRepository;

  UpdateEntry(this.entryRepository);

  @override
  Future<Either<Failure, Entry>> call(UpdateEntryParams params) {
    return entryRepository.updateEntry(
      title: params.title,
      content: params.content,
      entryId: params.entryId,
      images: params.images,
      posterId: params.posterId,
    );
  }
}

class UpdateEntryParams {
  final List<File> images;
  final String title;
  final String content;
  final String posterId;
  final String entryId;

  UpdateEntryParams({
    required this.images,
    required this.title,
    required this.content,
    required this.posterId,
    required this.entryId,
  });
}

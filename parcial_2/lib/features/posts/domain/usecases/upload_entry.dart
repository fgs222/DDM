import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:parcial_2/core/error/failures.dart';
import 'package:parcial_2/core/usecase/usecase.dart';
import 'package:parcial_2/features/posts/domain/entities/entry.dart';
import 'package:parcial_2/features/posts/domain/repositories/entry_repository.dart';

class UploadEntry implements UseCase<Entry, UploadEntryParams> {
  final EntryRepository entryRepository;

  UploadEntry(this.entryRepository);

  @override
  Future<Either<Failure, Entry>> call(UploadEntryParams params) async {
    return await entryRepository.uploadEntry(
      images: params.images,
      title: params.title,
      content: params.content,
      posterId: params.posterId,
    );
  }
}

class UploadEntryParams {
  final List<File> images;
  final String title;
  final String content;
  final String posterId;

  UploadEntryParams({
    required this.images,
    required this.title,
    required this.content,
    required this.posterId,
  });
}

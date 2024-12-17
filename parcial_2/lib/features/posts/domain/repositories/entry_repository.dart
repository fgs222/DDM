import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:parcial_2/core/error/failures.dart';
import 'package:parcial_2/features/posts/domain/entities/entry.dart';

abstract interface class EntryRepository {
  Future<Either<Failure, Entry>> uploadEntry({
    required List<File> images,
    required String title,
    required String content,
    required String posterId,
  });

  Future<Either<Failure, List<Entry>>> getAllEntries();

  Future<Either<Failure, Entry>> getEntry(String entryId);
  
  Future<Either<Failure, dynamic>> deleteEntry(String entryId);

  Future<Either<Failure, Entry>> updateEntry({
    required String entryId,
    required List<File> images,
    required String title,
    required String content,
    required String posterId,
  });
}

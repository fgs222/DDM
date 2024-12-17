import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:parcial_2/core/error/exceptions.dart';
import 'package:parcial_2/core/error/failures.dart';
import 'package:parcial_2/features/posts/data/datasources/entry_remote_data_source.dart';
import 'package:parcial_2/features/posts/data/models/entry_model.dart';
import 'package:parcial_2/features/posts/domain/entities/entry.dart';
import 'package:parcial_2/features/posts/domain/repositories/entry_repository.dart';
import 'package:uuid/uuid.dart';

class EntryRepositoryImpl implements EntryRepository {
  final EntryRemoteDataSource entryRemoteDataSource;

  EntryRepositoryImpl({required this.entryRemoteDataSource});

  @override
  Future<Either<Failure, Entry>> uploadEntry({
    required List<File> images,
    required String title,
    required String content,
    required String posterId,
  }) async {
    try {
      EntryModel entryModel = EntryModel(
        id: const Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrls: [],
      );

      final imageUrls = await Future.wait(
        images.map((image) => entryRemoteDataSource.uploadEntryImage(image, entryModel)),
      );

      entryModel = entryModel.copyWith(imageUrls: imageUrls);

      final uploadedEntry = await entryRemoteDataSource.uploadEntry(entryModel);
      return right(uploadedEntry);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Entry>>> getAllEntries() async {
    try {
      final entries = await entryRemoteDataSource.getAllEntries();
      return right(entries);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Entry>> getEntry(String entryId) async {
    try {
      final entry = await entryRemoteDataSource.getEntry(entryId);
      return right(entry as Entry);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, dynamic>> deleteEntry(String entryId) async {
    try {
      await entryRemoteDataSource.deleteEntry(entryId);
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Entry>> updateEntry({
    required String entryId,
    required List<File> images,
    required String title,
    required String content,
    required String posterId,
  }) async {
    try {
      EntryModel entryModel = EntryModel(
        id: entryId,
        posterId: posterId,
        title: title,
        content: content,
        imageUrls: [], // Initialize with an empty list, will be updated later
      );

      final imageUrls = await Future.wait(
        images.map((image) => entryRemoteDataSource.updateEntryImage(image, entryModel)),
      );

      entryModel = entryModel.copyWith(imageUrls: imageUrls);

      final updatedEntry = await entryRemoteDataSource.updateEntry(entryId, entryModel);
      return right(updatedEntry);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}

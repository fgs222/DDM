import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parcial_2/core/usecase/usecase.dart';
import 'package:parcial_2/features/posts/domain/entities/entry.dart';
import 'package:parcial_2/features/posts/domain/usecases/delete_entry.dart';
import 'package:parcial_2/features/posts/domain/usecases/get_all_entries.dart';
import 'package:parcial_2/features/posts/domain/usecases/update_entry.dart';
import 'package:parcial_2/features/posts/domain/usecases/upload_entry.dart';

part 'entry_event.dart';
part 'entry_state.dart';

class EntryBloc extends Bloc<EntryEvent, EntryState> {
  final UploadEntry _uploadEntry;
  final GetAllEntries _getAllEntries;
  final DeleteEntry _deleteEntry;
  final UpdateEntry _updateEntry;

  EntryBloc({
    required UploadEntry uploadEntry,
    required GetAllEntries getAllEntries,
    required DeleteEntry deleteEntry,
    required UpdateEntry updateEntry,
  })  : _uploadEntry = uploadEntry,
        _getAllEntries = getAllEntries,
        _deleteEntry = deleteEntry,
        _updateEntry = updateEntry,
        super(EntryInitial()) {
    on<EntryEvent>((event, emit) => emit(EntryLoading()));
    on<EntryUpload>(_onEntryUpload);
    on<EntryGetAllEntries>(_onGetAllEntries);
    on<EntryDeleteEntry>(_onDeleteEntry);
    on<EntryUpdate>(_onUpdateEntry);
  }

  void _onEntryUpload(EntryUpload event, Emitter<EntryState> emit) async {
    final result = await _uploadEntry(UploadEntryParams(
      images: event.images, // Pass the list of images
      title: event.title,
      content: event.content,
      posterId: event.posterId,
    ));
    result.fold(
      (failure) => emit(EntryFailure(failure.message)),
      (entry) => emit(EntryUploadSuccess()),
    );
  }

  void _onGetAllEntries(EntryGetAllEntries event, Emitter<EntryState> emit) async {
    final result = await _getAllEntries(NoParams());
    result.fold(
      (failure) => emit(EntryFailure(failure.message)),
      (entries) => emit(EntryDisplaySuccess(entries)),
    );
  }

  void _onDeleteEntry(EntryDeleteEntry event, Emitter<EntryState> emit) async {
    final result = await _deleteEntry(DeleteEntryParams(
      entryId: event.entryId,
    ));
    result.fold(
      (failure) => emit(EntryFailure(failure.message)),
      (_) => emit(EntryDeleteSuccess()),
    );
  }

  void _onUpdateEntry(EntryUpdate event, Emitter<EntryState> emit) async {
    final result = await _updateEntry(UpdateEntryParams(
      images: event.images,
      title: event.entry.title,
      content: event.entry.content,
      posterId: event.entry.posterId,
      entryId: event.entry.id,
    ));
    result.fold(
      (failure) => emit(EntryFailure(failure.message)),
      (_) => emit(EntryUpdateSuccess()),
    );
  }
}

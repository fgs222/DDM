part of 'entry_bloc.dart';

@immutable
sealed class EntryState {}

final class EntryInitial extends EntryState {}

final class EntryLoading extends EntryState {}

final class EntryFailure extends EntryState {
  final String message;

  EntryFailure(this.message);
}

final class EntryUploadSuccess extends EntryState {}

final class EntryUpdateSuccess extends EntryState {}

final class EntryDisplaySuccess extends EntryState {
  final List<Entry> entries;

  EntryDisplaySuccess(this.entries);
}

final class EntryDeleteSuccess extends EntryState {}

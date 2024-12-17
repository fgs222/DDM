part of 'entry_bloc.dart';

@immutable
sealed class EntryEvent {}

final class EntryUpload extends EntryEvent {
  final List<File> images;
  final String title;
  final String content;
  final String posterId;

  EntryUpload({
    required this.images,
    required this.title,
    required this.content,
    required this.posterId,
  });
}

final class EntryUpdate extends EntryEvent {
  final List<File> images;
  final Entry entry;

  EntryUpdate({
    required this.images,
    required this.entry,
  });
}

final class EntryGetAllEntries extends EntryEvent {}

final class EntryDeleteEntry extends EntryEvent {
  final String entryId;

  EntryDeleteEntry({required this.entryId});
}

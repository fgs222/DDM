import 'package:parcial_2/features/posts/domain/entities/entry.dart';

class EntryModel extends Entry {
  final String? posterName;

  EntryModel({
    required super.id,
    required super.posterId,
    required super.title,
    required super.content,
    required super.imageUrls,
    this.posterName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'posterId': posterId,
      'title': title,
      'content': content,
      'imageUrls': imageUrls,
      'posterName': posterName,
    };
  }

  factory EntryModel.fromMap(Map<String, dynamic> map, String? posterName) {
    return EntryModel(
      id: map['id'] as String,
      posterId: map['posterId'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      imageUrls: List<String>.from(map['imageUrls']),
      posterName: posterName,
    );
  }

  factory EntryModel.fromEntry(Entry entry) {
    return EntryModel(
      id: entry.id,
      posterId: entry.posterId,
      title: entry.title,
      content: entry.content,
      imageUrls: [],
      posterName: '',
    );
  }

  @override
  EntryModel copyWith({
    String? id,
    String? posterId,
    String? title,
    String? content,
    List<String>? imageUrls,
    String? posterName,
  }) {
    return EntryModel(
      id: id ?? this.id,
      posterId: posterId ?? this.posterId,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrls: imageUrls ?? this.imageUrls,
      posterName: posterName ?? this.posterName,
    );
  }
}

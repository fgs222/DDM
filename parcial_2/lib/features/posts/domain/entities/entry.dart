class Entry {
  final String id;
  final String posterId;
  final String title;
  final String content;
  final List<String> imageUrls;

  Entry({
    required this.id,
    required this.posterId,
    required this.title,
    required this.content,
    required this.imageUrls,
  });

  Entry copyWith({
    String? id,
    String? posterId,
    String? title,
    String? content,
    List<String>? imageUrls,
  }) {
    return Entry(
      id: id ?? this.id,
      posterId: posterId ?? this.posterId,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }
}

class Entry {
  final String category;
  final String title;
  final String noteTitle;
  final String note;

  Entry({
    required this.category,
    required this.title,
    this.noteTitle = '',    // Default is empty.
    required this.note,
  });

  Entry copyWith({
    String? category,
    String? title,
    String? noteTitle,
    String? note,
  }) {
    return Entry(
      category: category ?? this.category,
      title: title ?? this.title,
      noteTitle: noteTitle ?? this.noteTitle,
      note: note ?? this.note,
    );
  }
}

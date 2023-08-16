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
}

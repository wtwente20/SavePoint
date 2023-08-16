class Entry {
  final String category;
  final String title;
  final List<Note> notes;  // A list of Note objects

  Entry({
    required this.category,
    required this.title,
    required this.notes, // Ensure that you always initialize this list when creating an Entry object.
  });

  // A utility method to copy an Entry object and override specific properties if needed.
  Entry copyWith({
    String? category,
    String? title,
    List<Note>? notes,
  }) {
    return Entry(
      category: category ?? this.category,
      title: title ?? this.title,
      notes: notes ?? this.notes,
    );
  }
}

class Note {
  final String noteTitle;
  final String content;

  Note({
    required this.noteTitle,
    required this.content,
  });
}


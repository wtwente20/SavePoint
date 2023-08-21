class Entry {
  final String id;
  final String category;
  final String title;
  final List<Note> notes;

  Entry({
    required this.id,
    required this.category,
    required this.title,
    required this.notes,
  });

  Entry copyWith({
    String? id,
    String? category,
    String? title,
    List<Note>? notes,
  }) {
    return Entry(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      notes: notes ?? this.notes,
    );
  }

  // Convert Entry to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'title': title,
        'notes': notes.map((note) => note.toJson()).toList(),
      };

  // Convert JSON to Entry
  static Entry fromJson(Map<String, dynamic> json, {required String id}) {
    List<Note> notesList = [];
    if (json['notes'] != null) {
      notesList = (json['notes'] as List).map((n) {
        return Note(
          noteTitle: n['noteTitle'] as String,
          content: n['content'] as String,
        );
      }).toList();
    }

    return Entry(
      id: id,
      category: json['category'] as String,
      title: json['title'] as String,
      notes: notesList,
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

  // Convert Note to JSON
  Map<String, dynamic> toJson() => {
        'noteTitle': noteTitle,
        'content': content,
      };

  // Convert JSON to Note
  static Note fromJson(Map<String, dynamic> json) => Note(
        noteTitle: json['noteTitle'],
        content: json['content'],
      );
}

class Entry {
  final String id; // <-- New field for the unique ID
  final String category;
  final String title;
  final List<Note> notes;

  Entry({
    required this.id, // <-- New required parameter for the unique ID
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
        'notes': Map.fromIterable(notes,
            key: (note) => notes.indexOf(note).toString(),
            value: (note) => (note as Note).toJson()),
      };

  // Convert JSON to Entry
  // factory Entry.fromJson(Map<String, dynamic> json, {required String id}) =>
  //     Entry(
  //       id: id,
  //       category: json['category'],
  //       title: json['title'],
  //       notes: json['notes'] is List
  //           ? (json['notes'] as List)
  //               .map((noteJson) => noteJson is Map<String, dynamic>
  //                   ? Note.fromJson(noteJson)
  //                   : null)
  //               .where((note) => note != null)
  //               .cast<Note>()
  //               .toList()
  //           : [],
  //     );

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
  factory Note.fromJson(Map<String, dynamic> json) => Note(
        noteTitle: json['noteTitle'],
        content: json['content'],
      );
}

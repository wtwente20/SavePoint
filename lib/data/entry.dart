class Entry {
  final String id;  // <-- New field for the unique ID
  final String category;
  final String title;
  final List<Note> notes;

  

  Entry({
    required this.id,  // <-- New required parameter for the unique ID
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
  factory Entry.fromJson(Map<String, dynamic> json, {required String id}) => Entry(
        id: id,
        category: json['category'],
        title: json['title'],
        notes: (json['notes'] as List? ?? [])
            .map((noteJson) => Note.fromJson(noteJson as Map<String, dynamic>))
            .toList(),
      );
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

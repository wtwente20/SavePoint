import 'package:flutter/material.dart';

import '../data/entry.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback? onTap;

  const NoteCard({
    required this.note,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(note.noteTitle),
      subtitle: Text(note.content),
      onTap: onTap,
    );
  }
}

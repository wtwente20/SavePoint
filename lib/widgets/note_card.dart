import 'package:flutter/material.dart';

import '../data/entry.dart';

class NoteCard extends StatelessWidget {
  final Entry noteEntry;
  final VoidCallback? onTap;
  
  const NoteCard({
    required this.noteEntry,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(noteEntry.noteTitle), // Assuming the title of the note is what you want to display here
      subtitle: Text(noteEntry.note),
      onTap: onTap, // Use the onTap callback here
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/entry.dart';
import '../providers/entry_provider.dart'; // Import the unified provider here

class AddEntryScreen extends ConsumerWidget {
  final Entry entryData;
  final Note? editNote;

  AddEntryScreen({required this.entryData, this.editNote});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesController = TextEditingController(text: editNote?.content);
    final noteTitleController =
        TextEditingController(text: editNote?.noteTitle);

    return Scaffold(
      appBar: AppBar(
        title: Text(entryData.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: noteTitleController,
              decoration: InputDecoration(labelText: 'Note Title'),
            ),
            TextField(
              controller: notesController,
              maxLines: null,
              decoration: InputDecoration(labelText: 'Your notes here...'),
            ),
            ElevatedButton(
              onPressed: () {
                final newNote = Note(
                  noteTitle: noteTitleController.text,
                  content: notesController.text,
                );

                if (editNote != null) {
                  // Handle editing logic (update the note in the list)
                  ref.read(entryListProvider.notifier).updateNoteInTitle(
                      entryData.category,
                      entryData.title,
                      editNote!.noteTitle,
                      newNote);
                } else {
                  // Handle adding logic (add the note to the list)
                  ref.read(entryListProvider.notifier).addNoteToTitle(
                        entryData.category,
                        entryData.title,
                        newNote,
                      );
                }

                Navigator.of(context).pop();
              },
              child: Text(editNote == null ? "Add Note" : "Update Note"),
            )
          ],
        ),
      ),
    );
  }
}

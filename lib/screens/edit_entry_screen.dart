import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/entry.dart';
import '../providers/entry_provider.dart';

class EditEntryScreen extends ConsumerWidget {
  final Entry entryData;
  final Note editNote;

  const EditEntryScreen({super.key, required this.entryData, required this.editNote});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesController = TextEditingController(text: editNote.content);
    final noteTitleController = TextEditingController(text: editNote.noteTitle);

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
              decoration: const InputDecoration(labelText: 'Note Title'),
            ),
            TextField(
              controller: notesController,
              maxLines: null,
              decoration: const InputDecoration(labelText: 'Your notes here...'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedNote = Note(
                  noteTitle: noteTitleController.text,
                  content: notesController.text,
                );

                ref.read(entryListProvider.notifier).updateNoteInTitle(
                    entryData.category,
                    entryData.title,
                    editNote.noteTitle,
                    updatedNote);

                Navigator.of(context).pop({'updatedNote': updatedNote});
              },
              child: const Text("Update Note"),
            )
          ],
        ),
      ),
    );
  }
}

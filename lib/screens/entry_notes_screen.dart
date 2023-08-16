import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/entry.dart';
import '../providers/entry_provider.dart';  // Import the unified provider here

class EntryNotesScreen extends ConsumerWidget {
  final Entry entryData;

  EntryNotesScreen({required this.entryData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allEntries = ref.watch(entryListProvider);
    final currentEntry = allEntries.firstWhere(
      (e) => e.category == entryData.category && e.title == entryData.title,
      orElse: () => entryData,
    );

    final notesController = TextEditingController(text: currentEntry.note);
    final entryNameController = TextEditingController(text: currentEntry.title);
    final noteTitleController = TextEditingController(text: currentEntry.noteTitle);  // New controller for the note title

    return Scaffold(
      appBar: AppBar(
        title: Text(currentEntry.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: entryNameController,
              decoration: InputDecoration(labelText: 'Entry Name'),
            ),
            TextField(
              controller: noteTitleController,
              decoration: InputDecoration(labelText: 'Note Title'),
            ), // New TextField for the note title
            TextField(
              controller: notesController,
              maxLines: null,
              decoration: InputDecoration(labelText: 'Your notes here...'),
            ),
            ElevatedButton(
              onPressed: () {
                if (currentEntry.title != entryNameController.text) {
                  ref.read(entryListProvider.notifier).updateEntryTitle(
                    currentEntry.category,
                    currentEntry.title,
                    entryNameController.text,
                  );
                }

                ref.read(entryListProvider.notifier).updateEntry(
                  allEntries.indexOf(currentEntry),
                  currentEntry.copyWith(
                    title: entryNameController.text,
                    note: notesController.text,
                    noteTitle: noteTitleController.text,  // Saving the note title
                  ),
                );

                Navigator.of(context).pop();
              },
              child: Text("Save Notes"),
            )
          ],
        ),
      ),
    );
  }
}

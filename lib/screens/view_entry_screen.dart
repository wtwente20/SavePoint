import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/entry.dart';
import '../providers/entry_provider.dart';
import 'edit_entry_screen.dart';

class ViewEntryScreen extends ConsumerWidget {
  final Entry entryData;
  final Note noteData;

  ViewEntryScreen({required this.entryData, required this.noteData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(entryListProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(noteData.noteTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditEntryScreen(
                    entryData: entryData,
                    editNote: noteData,
                  ),
                ),
              );

              if (result != null && result.containsKey('updatedNote')) {
                Note updatedNote = result['updatedNote'] as Note;
                notifier.updateNote(entryData, noteData, updatedNote);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              notifier.removeNoteFromEntry(entryData, noteData);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              noteData.noteTitle,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(noteData.content),
          ],
        ),
      ),
    );
  }
}

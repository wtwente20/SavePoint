import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/entry.dart';
import '../providers/entry_provider.dart';
import '../screens/entry_notes_screen.dart';
import '../screens/note_view_screen.dart';
import 'note_card.dart';

class TitleCard extends ConsumerWidget {
  final Entry titleEntry;

  TitleCard({required this.titleEntry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allEntries = ref.watch(entryListProvider);

    // Extract the notes related to this title
    final titleNotes = titleEntry.notes;

    return ExpansionTile(
      title: Text(titleEntry.title),
      children: [
        if (titleNotes.isNotEmpty)
          ...titleNotes.map((note) {
            return NoteCard(
              note: note,
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                  builder: (context) =>
                      NoteViewScreen(entryData: titleEntry, noteData: note),
                ))
                    .then((result) {
                  if (result != null) {
                    // Handle deletions
                    if (result.containsKey('delete') && result['delete']) {
                      final updatedNotes = List<Note>.from(titleNotes)
                        ..remove(note);
                      final updatedEntry =
                          titleEntry.copyWith(notes: updatedNotes);
                      final index = allEntries.indexOf(titleEntry);
                      if (index != -1) {
                        ref
                            .read(entryListProvider.notifier)
                            .updateEntry(index, updatedEntry);
                      }
                    }
                    // Handle updates
                    else if (result.containsKey('updatedNote')) {
                      final updatedNote = result['updatedNote'] as Note;

                      final updatedNotes = List<Note>.from(titleNotes)
                        ..remove(note) // Remove the old note
                        ..add(updatedNote); // Add the updated note
                      final updatedEntry =
                          titleEntry.copyWith(notes: updatedNotes);
                      final index = allEntries.indexOf(titleEntry);
                      if (index != -1) {
                        ref
                            .read(entryListProvider.notifier)
                            .updateEntry(index, updatedEntry);
                      }
                    }
                  }
                });
              },
            );
          }).toList(),
        ListTile(
          leading: const Icon(Icons.add, color: Colors.blue),
          title: const Text('Add Note'),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return EntryNotesScreen(
                  entryData: titleEntry,
                );
              }),
            );
          },
        ),
      ],
    );
  }
}

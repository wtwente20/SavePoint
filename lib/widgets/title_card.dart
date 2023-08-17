import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/entry.dart';
import '../providers/entry_provider.dart';
import '../screens/add_entry_screen.dart';
import '../screens/note_view_screen.dart';
import 'note_card.dart';

class TitleCard extends ConsumerWidget {
  final Entry titleEntry;

  TitleCard({required this.titleEntry});

  Future<bool> _confirmDeletion(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Delete Title'),
            content: Text(
                'Are you sure you want to delete this title and all its notes?'),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              TextButton(
                child: Text('Delete'),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allEntries = ref.watch(entryListProvider);
    final titleNotes = titleEntry.notes;

    return Dismissible(
      key: ValueKey(titleEntry.title), // Unique key for the Dismissible
      background: Container(
        color: Colors.red,
        child: Icon(Icons.delete, color: Colors.white, size: 36),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
      ),
      direction: DismissDirection.startToEnd,
      confirmDismiss: (direction) => _confirmDeletion(context),
      onDismissed: (direction) {
        // Implement the removal logic here
        final index = allEntries.indexOf(titleEntry);
        if (index != -1) {
          ref.read(entryListProvider.notifier).deleteEntry(index);
        }
      },
      child: ExpansionTile(
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
                          ..remove(note)
                          ..add(updatedNote);
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
                  return AddEntryScreen(
                    entryData: titleEntry,
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}

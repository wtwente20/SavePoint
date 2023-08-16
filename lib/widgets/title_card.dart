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

    // Filter out entries that belong to the current title
    final titleEntries = allEntries
        .where((e) => e.title == titleEntry.title && e.note.isNotEmpty)
        .toList();

    return ExpansionTile(
      title: Text(titleEntry.title),
      children: [
        if (titleEntries.isNotEmpty)
          ...titleEntries.map((entry) {
            return NoteCard(
              noteEntry: entry,
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                  builder: (context) => NoteViewScreen(noteData: entry),
                ))
                    .then((result) {
                  if (result != null) {
                    // Use a Riverpod provider to handle any updates or deletions if necessary
                    if (result.containsKey('delete') && result['delete']) {
                      final index = allEntries.indexOf(entry);
                      if (index != -1) {
                        ref.read(entryListProvider.notifier).deleteEntry(index);
                      }
                    } else {
                      final updatedEntry = Entry(
                          category: entry.category,
                          title: result['newTitle'] as String,
                          note: result['note'] as String
                          );
                      final index = allEntries.indexOf(entry);
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
          title: const Text('Add Entry'),
          onTap: () {
            // You can navigate to an entry creation screen using Navigator
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return EntryNotesScreen(
                  entryData: Entry(
                    category: titleEntry.category,
                    title: titleEntry.title,
                    noteTitle: '',
                    note: '',
                  ),
                );
              }),
            );
          },
        ),
      ],
    );
  }
}

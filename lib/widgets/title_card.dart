import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/entry.dart';
import '../providers/entry_provider.dart';
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
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NoteViewScreen(noteData: entry),
                )).then((result) {
                  if (result != null) {
                    // Use a Riverpod provider to handle any updates or deletions if necessary
                  }
                });
              },
            );
          }).toList(),
        ListTile(
          leading: const Icon(Icons.add, color: Colors.blue),
          title: const Text('Add Entry'),
          onTap: () {
            // Here, you can either directly use a provider to handle adding an entry,
            // or call another function to open a dialog/form.
          },
        ),
      ],
    );
  }
}

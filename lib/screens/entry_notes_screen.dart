import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savepoint_app/providers/category_entries_notifier.dart';

import '../data/entry.dart';

class EntryNotesScreen extends ConsumerWidget {
  final Entry entryData;

  EntryNotesScreen({required this.entryData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryEntries = ref.watch(categoryEntriesProvider)!;
    final notesForCategory = categoryEntries[entryData.category];
    final noteText = notesForCategory?[entryData.title];

    final notesController = TextEditingController(text: noteText ?? "");
    final entryNameController = TextEditingController(text: entryData.title);

    return Scaffold(
      appBar: AppBar(
        title: Text(entryData.title),
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
              controller: notesController,
              maxLines: null,
              decoration: InputDecoration(labelText: 'Your notes here...'),
            ),
            ElevatedButton(
              onPressed: () {
                if (entryData.title != entryNameController.text) {
                  ref.read(categoryEntriesProvider.notifier).updateEntryTitle(
                        entryData.category,
                        entryData.title,
                        entryNameController.text,
                      );
                }

                ref.read(categoryEntriesProvider.notifier).updateEntry(Entry(
                    category: entryData.category,
                    title: entryNameController.text,
                    note: notesController.text));

                Navigator.of(context).pop({
                  'oldTitle': entryData.title,
                  'newTitle': entryNameController.text,
                  'note': notesController.text
                });
              },
              child: Text("Save Notes"),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savepoint_app/providers/category_entries_notifier.dart';

class EntryNotesScreen extends ConsumerWidget {
  final String category;
  final String entry;
  final Map<String, String> notesMap;

  EntryNotesScreen({required this.category, required this.entry, required this.notesMap});
  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryEntries = ref.watch(categoryEntriesProvider)!;
    final notesForCategory = categoryEntries[category];
    final noteText =
        (notesForCategory != null) ? notesForCategory[entry] : null;
    final notesController = TextEditingController(text: noteText ?? "");

    return Scaffold(
      appBar: AppBar(
        title: Text(entry),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: notesController,
              maxLines: null,
              decoration: InputDecoration(labelText: 'Your notes here...'),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(categoryEntriesProvider.notifier).updateEntry(
                      category,
                      entry,
                      notesController.text,
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

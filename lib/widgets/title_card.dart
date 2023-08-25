import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/entry.dart';
import '../providers/entry_provider.dart';
import '../screens/add_entry_screen.dart';
import '../screens/view_entry_screen.dart';
import 'note_card.dart';

class TitleCard extends ConsumerWidget {
  final Entry titleEntry;

  const TitleCard({super.key, required this.titleEntry});

  Future<bool> _confirmDeletion(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Delete Title'),
            content: const Text(
                'Are you sure you want to delete this title and all its notes?'),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(ctx).pop(false),
              ),
              TextButton(
                child: const Text('Delete'),
                onPressed: () => Navigator.of(ctx).pop(true),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _handleNavigationResult(BuildContext context, WidgetRef ref, result, List<Note> titleNotes) {
    if (result != null) {
      // Handle deletions
      if (result.containsKey('delete') && result['delete']) {
        final updatedNotes = List<Note>.from(titleNotes)..remove(result['deletedNote']);
        final updatedEntry = titleEntry.copyWith(notes: updatedNotes);
        ref.read(entryListProvider.notifier).updateEntry(titleEntry.id, updatedEntry);
      }
      // Handle updates
      else if (result.containsKey('updatedNote')) {
        final updatedNote = result['updatedNote'] as Note;
        final updatedNotes = List<Note>.from(titleNotes)
          ..remove(result['originalNote'])
          ..add(updatedNote);
        final updatedEntry = titleEntry.copyWith(notes: updatedNotes);
        ref.read(entryListProvider.notifier).updateEntry(titleEntry.id, updatedEntry);
      }
    }
  }

  @override
Widget build(BuildContext context, WidgetRef ref) {
    final titleNotes = titleEntry.notes;

    return Dismissible(
      key: ValueKey('${titleEntry.title}-${titleNotes.length}'),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 36),
      ),
      direction: DismissDirection.startToEnd,
      confirmDismiss: (direction) => _confirmDeletion(context),
      onDismissed: (direction) {
        ref.read(entryListProvider.notifier).deleteEntry(titleEntry.id);
      },
      child: ExpansionTile(
        title: Text('${titleEntry.title} (${titleNotes.length})'),
        children: [
          if (titleNotes.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: titleNotes.length,
              itemBuilder: (ctx, index) {
                return NoteCard(
                  note: titleNotes[index],
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                          builder: (context) => ViewEntryScreen(
                              entryData: titleEntry, noteData: titleNotes[index]),
                        ))
                        .then((result) => _handleNavigationResult(context, ref, result, titleNotes));
                  },
                );
              },
            ),
          ListTile(
            leading: const Icon(Icons.add, color: Colors.blue),
            title: const Text('Add Note'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddEntryScreen(entryData: titleEntry),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

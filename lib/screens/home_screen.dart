import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/entry.dart';
import '../providers/entry_provider.dart';
import '../widgets/category_card.dart';
import '../widgets/category_dialog.dart';
import '../widgets/title_dialog.dart';
import 'entry_notes_screen.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(entryListProvider);
    final navigatorKey = GlobalKey<NavigatorState>();

    void _addNewCategory(String category) {
      ref
          .read(entryListProvider.notifier)
          .addEntry(Entry(category: category, title: '', note: ''));
    }

    void _addNewTitle(String category) async {
      final titleDialog = TitleDialog();
      final newTitle = await titleDialog.show(context);

      if (newTitle != null && newTitle.isNotEmpty) {
        ref
            .read(entryListProvider.notifier)
            .addEntry(Entry(category: category, title: newTitle, note: ''));
      }
    }

    void _addOrUpdateEntry(String category, String title) async {
  final result = await navigatorKey.currentState!.push<Map<String, String>>(
    MaterialPageRoute(builder: (BuildContext context) => EntryNotesScreen(entryData: Entry(category: category, title: title, note: ''))),
  );

  if (result != null && result['note']?.isNotEmpty == true) {
    final oldTitle = result['oldTitle'] ?? '';
    final newNoteTitle = result['newTitle'] ?? '';
    final newNote = result['note'] ?? '';

    final index = entries.indexWhere((e) => e.category == category && e.title == oldTitle);
    
    if (index != -1) {
      final updatedEntry = Entry(
        category: category,
        title: oldTitle,
        noteTitle: newNoteTitle,
        note: newNote,
      );
      
      ref.read(entryListProvider.notifier).updateEntry(index, updatedEntry);
    } else {
      // Handle the case where the entry was not found
    }
  }
}


    final categories = entries.map((e) => e.category).toSet().toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Your Categories')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (ctx, index) {
                return CategoryCard(
                  categoryKey: categories[index],
                  addNewTitleCallback: _addNewTitle,
                  addOrUpdateEntryCallback: _addOrUpdateEntry,
                );
              },
            ),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add New Category'),
            onPressed: () async {
              final categoryDialog = CategoryDialog();
              final newCategory = await categoryDialog.show(context);

              if (newCategory != null && newCategory.isNotEmpty) {
                _addNewCategory(newCategory);
              }
            },
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/entry.dart';
import '../providers/entry_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/category_card.dart';
import '../widgets/category_dialog.dart';
import '../widgets/title_dialog.dart';
import 'add_entry_screen.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(entryListProvider);
    final navigatorKey = GlobalKey<NavigatorState>();
    final themeMode = ref.watch(themeProvider);

    void _addNewCategory(String category) {
      ref
          .read(entryListProvider.notifier)
          .addEntry(Entry(category: category, title: '', notes: []));
    }

    void _addNewTitle(String category) async {
      final titleDialog = TitleDialog();
      final newTitle = await titleDialog.show(context);

      if (newTitle != null && newTitle.isNotEmpty) {
        ref
            .read(entryListProvider.notifier)
            .addEntry(Entry(category: category, title: newTitle, notes: []));
      }
    }

    void _addOrUpdateEntry(String category, String title) async {
      final result =
          await navigatorKey.currentState!.push<Map<String, dynamic>>(
        MaterialPageRoute(
            builder: (BuildContext context) => AddEntryScreen(
                entryData: Entry(category: category, title: title, notes: []))),
      );

      if (result != null && result['updatedNote'] != null) {
        final oldTitle = result['oldTitle'] ?? '';
        final updatedNote = result['updatedNote'] as Note;
        final index = entries
            .indexWhere((e) => e.category == category && e.title == oldTitle);

        if (index != -1) {
          final entry = entries[index];
          final updatedNotes = List<Note>.from(entry.notes)..add(updatedNote);
          final updatedEntry = entry.copyWith(notes: updatedNotes);
          ref.read(entryListProvider.notifier).updateEntry(index, updatedEntry);
        } else {
          // Handle the case where the entry was not found
        }
      }
    }

    final categories = entries.map((e) => e.category).toSet().toList();

    return Scaffold(
      appBar: AppBar(title: const Text('SavePoint')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (themeMode == ThemeMode.light) {
            ref.read(themeProvider.notifier).state = ThemeMode.dark;
          } else {
            ref.read(themeProvider.notifier).state = ThemeMode.light;
          }
        },
        child: Icon(Icons.brightness_6),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (ctx, index) {
                return Dismissible(
                  key: ValueKey(
                      categories[index]), // unique key based on the category
                  background: Container(
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    // Remove the category from data source
                    String deletedCategory = categories[index];
                    ref
                        .read(entryListProvider.notifier)
                        .removeCategory(deletedCategory);

                    // Provide feedback to the user
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Category deleted')));
                  },
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Delete Category?"),
                        content: Text(
                            "Are you sure you want to delete this category? All titles in this category will be lost."),
                        actions: [
                          TextButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          TextButton(
                            child: Text("Delete"),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  child: CategoryCard(
                    categoryKey: categories[index],
                    addNewTitleCallback: _addNewTitle,
                    addOrUpdateEntryCallback: _addOrUpdateEntry,
                  ),
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

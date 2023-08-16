import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/entry.dart';

class CategoryEntriesProvider
    extends StateNotifier<Map<String, Map<String, String>>> {
  CategoryEntriesProvider()
      : super({
          'Books': {},
          'Video Games': {},
          'Tabletop RPGs': {},
        });

  // Update the notes of an existing entry within a category
  void updateEntry(Entry entry) {
    final updatedCategory = {
      ...(state[entry.category] ?? {}),
      entry.title: entry.note,
    };
    state = {...state, entry.category: updatedCategory};
  }

  // Add a new category to the state
  void addCategory(String category) {
    state[category] = {};
  }

  // Rename the title of an existing entry within a category
  void updateEntryTitle(
      String category, String oldEntryTitle, String newEntryTitle) {
    if (state[category] != null && state[category]![oldEntryTitle] != null) {
      String? note = state[category]![oldEntryTitle];
      state[category]!.remove(oldEntryTitle);
      state[category]![newEntryTitle] = note!;
    }
  }

  // Add a new entry title to a category without any notes (default is "No notes yet")
  void addEntry(String category, String entryTitle) {
    state[category] = {
      ...(state[category] ?? {}),
      entryTitle: "No notes yet",
    };
  }
}

final categoryEntriesProvider = StateNotifierProvider<CategoryEntriesProvider,
    Map<String, Map<String, String>>>((ref) => CategoryEntriesProvider());

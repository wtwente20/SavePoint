import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/entry.dart';

class EntryListNotifier extends StateNotifier<List<Entry>> {
  EntryListNotifier() : super([
    Entry(category: 'Books', title: '', noteTitle: '', note: ''),
    Entry(category: 'Video Games', title: '', noteTitle: '', note: ''),
    Entry(category: 'Tabletop RPGs', title: '', noteTitle: '', note: ''),
  ]);

  void addEntry(Entry entry) {
    state = [...state, entry];
  }

  void updateEntry(int index, Entry updatedEntry) {
    final newState = [...state];
    newState[index] = updatedEntry;
    state = newState;
  }

  void deleteEntry(int index) {
    final newState = [...state];
    newState.removeAt(index);
    state = newState;
  }

  // Merged methods from CategoryEntriesProvider

  void updateEntryNote(Entry entry, String updatedNote) {
    final index = state.indexWhere((e) => e.title == entry.title && e.category == entry.category);
    if(index != -1) {
      final updatedEntry = state[index].copyWith(note: updatedNote);
      updateEntry(index, updatedEntry);
    }
  }

  void addCategory(String category) {
    state = [...state, Entry(category: category, title: '', noteTitle: '', note: '')];
  }

  void updateEntryTitle(String category, String oldEntryTitle, String newEntryTitle) {
    final index = state.indexWhere((e) => e.title == oldEntryTitle && e.category == category);
    if(index != -1) {
      final updatedEntry = state[index].copyWith(title: newEntryTitle);
      updateEntry(index, updatedEntry);
    }
  }

}

final entryListProvider = StateNotifierProvider<EntryListNotifier, List<Entry>>((ref) => EntryListNotifier());
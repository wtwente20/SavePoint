import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/entry.dart';

class EntryListNotifier extends StateNotifier<List<Entry>> {
  EntryListNotifier() : super([]);

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
}

final entryListProvider = StateNotifierProvider<EntryListNotifier, List<Entry>>((ref) => EntryListNotifier());
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/entry.dart';

class EntryListNotifier extends StateNotifier<List<Entry>> {
  EntryListNotifier() : super([
    Entry(category: 'Books', title: '', notes: []),
    Entry(category: 'Video Games', title: '', notes: []),
    Entry(category: 'Tabletop RPGs', title: '', notes: []),
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

  void addNoteToTitle(String category, String title, Note note) {
    int index = state.indexWhere((e) => e.title == title && e.category == category);
    if (index != -1) {
      final entry = state[index];
      final updatedNotes = List<Note>.from(entry.notes)..add(note);
      final updatedEntry = entry.copyWith(notes: updatedNotes);
      updateEntry(index, updatedEntry);
    } else {
      // If the title doesn't exist, create a new entry with the given title and note.
      addEntry(Entry(category: category, title: title, notes: [note]));
    }
  }

  void updateNoteInTitle(String category, String title, String oldNoteTitle, Note updatedNote) {
    int index = state.indexWhere((e) => e.title == title && e.category == category);
    if (index != -1) {
      final entry = state[index];
      final noteIndex = entry.notes.indexWhere((n) => n.noteTitle == oldNoteTitle);
      if (noteIndex != -1) {
        final updatedNotes = List<Note>.from(entry.notes)
          ..[noteIndex] = updatedNote;
        final updatedEntry = entry.copyWith(notes: updatedNotes);
        updateEntry(index, updatedEntry);
      }
    }
  }

  void addCategory(String category) {
    state = [...state, Entry(category: category, title: '', notes: [])];
  }

  void updateEntryTitle(String category, String oldEntryTitle, String newEntryTitle) {
    final index = state.indexWhere((e) => e.title == oldEntryTitle && e.category == category);
    if (index != -1) {
      final updatedEntry = state[index].copyWith(title: newEntryTitle);
      updateEntry(index, updatedEntry);
    }
  }
}

final entryListProvider = StateNotifierProvider<EntryListNotifier, List<Entry>>((ref) => EntryListNotifier());

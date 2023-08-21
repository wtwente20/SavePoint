import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/entry.dart';
import '../services/auth_service.dart';

class EntryListNotifier extends StateNotifier<List<Entry>> {
  
  final String uid;
  final DatabaseReference databaseRef;

  EntryListNotifier(this.uid)
      : databaseRef = FirebaseDatabase.instance.reference().child('entries').child(uid),
        super([
          Entry(id: 'default1', category: 'Books', title: '', notes: []),
          Entry(id: 'default2', category: 'Video Games', title: '', notes: []),
          Entry(id: 'default3', category: 'Tabletop RPGs', title: '', notes: []),
        ]) {
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    try {
      DataSnapshot snapshot = (await databaseRef.once()).snapshot;
      print("Raw Firebase Data: ${snapshot.value}");

      List<Entry> entries = [];

      if (snapshot.value is Map<dynamic, dynamic>) {
        final rawValues = snapshot.value as Map<dynamic, dynamic>;
        final Map<String, dynamic> values = {};

        for (var key in rawValues.keys) {
          if (key is String && rawValues[key] is Map<dynamic, dynamic>) {
            values[key] = Map<String, dynamic>.from(rawValues[key] as Map);
          } else {
            print("Unexpected key or value type in Firebase data: $key");
          }
        }

        values.forEach((key, value) {
          final entry = Entry.fromJson(value, id: key);
          entries.add(entry);
        });
      }

      // Ensure default categories are always present
      const defaultCategories = [
        'Books',
        'Video Games',
        'Tabletop RPGs',
      ];

      for (var category in defaultCategories) {
        if (!entries.any((entry) => entry.category == category)) {
          entries.add(Entry(
              id: 'default-${category.hashCode}',
              category: category,
              title: '',
              notes: []));
        }
      }

      state = entries;
      print("Current state: $state");
    } catch (error) {
      print("Error loading entries: $error");
    }
  }

  Future<void> _saveEntry(Entry entry) async {
    try {
      databaseRef.child(entry.id).set(entry.toJson());
    } catch (error) {
      print("Error saving entry: $error");
    }
  }

  void addEntry(Entry entry) {
    final newEntry = entry.copyWith(id: databaseRef.push().key);
    state = [...state, newEntry];
    _saveEntry(newEntry);
  }

  void updateEntry(String id, Entry updatedEntry) {
    final index = state.indexWhere((e) => e.id == id);
    if (index == -1) return;

    state[index] = updatedEntry;
    state = List.from(state);

    _saveEntry(updatedEntry);
  }

  void deleteEntry(String id) {
    final index = state.indexWhere((e) => e.id == id);
    if (index == -1) return;

    state.removeAt(index);
    try {
      databaseRef.child(id).remove();
    } catch (error) {
      print("Error deleting entry: $error");
    }
  }

  void addNoteToTitle(String category, String title, Note note) {
    int index =
        state.indexWhere((e) => e.title == title && e.category == category);
    if (index != -1) {
      final entry = state[index];
      final updatedNotes = List<Note>.from(entry.notes)..add(note);
      final updatedEntry = entry.copyWith(notes: updatedNotes);
      updateEntry(entry.id,
          updatedEntry); // Ensure this is correctly updating the database
    } else {
      addEntry(Entry(id: '', category: category, title: title, notes: [note]));
    }
  }

  void updateNoteInTitle(
      String category, String title, String oldNoteTitle, Note updatedNote) {
    int index =
        state.indexWhere((e) => e.title == title && e.category == category);
    if (index != -1) {
      final entry = state[index];
      final noteIndex =
          entry.notes.indexWhere((n) => n.noteTitle == oldNoteTitle);
      if (noteIndex != -1) {
        final updatedNotes = List<Note>.from(entry.notes)
          ..[noteIndex] = updatedNote;
        final updatedEntry = entry.copyWith(notes: updatedNotes);
        updateEntry(entry.id, updatedEntry);
      }
    }
  }

  void addCategory(String category) {
    addEntry(Entry(id: '', category: category, title: '', notes: []));
  }

  void removeCategory(String category) {
    final index = state.indexWhere((e) => e.category == category);
    if (index != -1) {
      deleteEntry(state[index].id);
    }
  }

  void updateNote(Entry entry, Note oldNote, Note newNote) {
    final entryIndex = state.indexOf(entry);
    if (entryIndex == -1) return;
    final noteIndex = state[entryIndex].notes.indexOf(oldNote);
    if (noteIndex == -1) return;
    final updatedNotes = List<Note>.from(state[entryIndex].notes)
      ..[noteIndex] = newNote;
    final updatedEntry = state[entryIndex].copyWith(notes: updatedNotes);
    updateEntry(state[entryIndex].id, updatedEntry);
  }

  void removeNoteFromEntry(Entry entry, Note note) {
  final entryIndex = state.indexOf(entry);
  if (entryIndex == -1) return;

  // Remove the note from the entry
  final updatedNotes = List<Note>.from(state[entryIndex].notes)..remove(note);

  // Update the entry without the note
  final updatedEntry = state[entryIndex].copyWith(notes: updatedNotes);
  updateEntry(state[entryIndex].id, updatedEntry);
}



  void updateEntryTitle(
      String category, String oldEntryTitle, String newEntryTitle) {
    final index = state
        .indexWhere((e) => e.title == oldEntryTitle && e.category == category);
    if (index != -1) {
      final updatedEntry = state[index].copyWith(title: newEntryTitle);
      updateEntry(state[index].id, updatedEntry);
    }
  }
}

final entryListProvider = StateNotifierProvider<EntryListNotifier, List<Entry>>(
    (ref) {
  final userAsyncValue = ref.watch(authStateChangesProvider);
  
  if (userAsyncValue is AsyncData<User?> && userAsyncValue.value != null) {
    return EntryListNotifier(userAsyncValue.value!.uid);
  }
  
  // Handle the case where the user is null (e.g., not authenticated) or loading/error states
  throw Exception("User not authenticated or still loading");
});

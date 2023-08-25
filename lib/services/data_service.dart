import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../data/entry.dart';

class DataService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.reference();
  final User? _user = FirebaseAuth.instance.currentUser;

  String get uid => _user?.uid ?? ''; // Handle null

  Future<void> createEntry(Entry entry) async {
    if (_user != null) {
      final newEntryRef =
          _dbRef.child('entries').child(uid).child(entry.category).push();
      await newEntryRef.set(entry.toJson());
    } else {
      throw Exception("No user signed in");
    }
  }

  Future<void> updateEntry(Entry entry) async {
    if (_user != null) {
      await _dbRef
          .child('entries')
          .child(uid)
          .child(entry.category)
          .child(entry.id)
          .set(entry.toJson());
    } else {
      throw Exception("No user signed in");
    }
  }

  Future<List<Entry>> fetchEntriesForCategory(String categoryId) async {
    if (_user != null) {
      DataSnapshot dataSnapshot =
          (await _dbRef.child('entries').child(uid).child(categoryId).once())
              .snapshot;
      if (dataSnapshot.value != null) {
        Map<String, dynamic> entriesMap =
            dataSnapshot.value as Map<String, dynamic>;
        List<Entry> entries = [];
        entriesMap.forEach((key, value) {
          entries.add(Entry.fromJson(value, id: key));
        });
        return entries;
      }
      return [];
    } else {
      throw Exception("No user signed in");
    }
  }

  Future<void> deleteEntry(String categoryId, String entryId) async {
    if (_user != null) {
      await _dbRef
          .child('entries')
          .child(uid)
          .child(categoryId)
          .child(entryId)
          .remove();
    } else {
      throw Exception("No user signed in");
    }
  }

  // Method to fetch the pop-up flag from Firebase RTD
  Future<bool> fetchShowGetStartedPopup() async {
    if (_user != null) {
      DatabaseEvent event = await _dbRef
          .child('userSettings')
          .child(uid)
          .child('showGetStartedPopup')
          .once();
      DataSnapshot dataSnapshot = event.snapshot;

      if (dataSnapshot.value is bool) {
        return dataSnapshot.value as bool;
      } else {
        return true; // Default value if not set or if the type is not bool.
      }
    } else {
      throw Exception("No user signed in");
    }
  }

  // Method to update the pop-up flag in Firebase RTD
  Future<void> setShowGetStartedPopup(bool value) async {
    if (_user != null) {
      await _dbRef
          .child('userSettings')
          .child(uid)
          .child('showGetStartedPopup')
          .set(value);
    } else {
      throw Exception("No user signed in");
    }
  }
}

import 'package:flutter/material.dart';

import '../data/entry.dart';
import 'edit_entry_screen.dart';

class NoteViewScreen extends StatefulWidget {
  final Entry entryData;
  final Note noteData; // We'll pass the specific Note object for editing

  NoteViewScreen({required this.entryData, required this.noteData});

  @override
  _NoteViewScreenState createState() => _NoteViewScreenState();
}

class _NoteViewScreenState extends State<NoteViewScreen> {
  late TextEditingController notesController;
  late TextEditingController noteTitleController;

  @override
  void initState() {
    super.initState();
    notesController = TextEditingController(text: widget.noteData.content);
    noteTitleController =
        TextEditingController(text: widget.noteData.noteTitle);
  }

  @override
  void dispose() {
    notesController.dispose();
    noteTitleController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (notesController.text.isNotEmpty &&
        noteTitleController.text.isNotEmpty) {
      Note updatedNote = Note(
        noteTitle: noteTitleController.text,
        content: notesController.text,
      );

      Navigator.pop(context, {'updatedNote': updatedNote});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Title and Note content cannot be empty!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.noteData.noteTitle),  // Note this change here
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditEntryScreen(
                    entryData: widget.entryData,   // And here
                    editNote: widget.noteData,     // And here
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              Navigator.pop(context, {'delete': true});
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.noteData.noteTitle,  // And here
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(widget.noteData.content),  // And here
          ],
        ),
      ),
    );
  }
}

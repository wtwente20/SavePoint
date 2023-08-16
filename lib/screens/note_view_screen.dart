import 'package:flutter/material.dart';

import '../data/entry.dart';

class NoteViewScreen extends StatefulWidget {
  final Entry entryData;
  final Note noteData;  // We'll pass the specific Note object for editing

  NoteViewScreen({required this.entryData, required this.noteData});

  @override
  _NoteViewScreenState createState() => _NoteViewScreenState();
}

class _NoteViewScreenState extends State<NoteViewScreen> {
  late TextEditingController notesController;
  late TextEditingController noteTitleController;  // Renamed to make it more intuitive

  @override
  void initState() {
    super.initState();
    notesController = TextEditingController(text: widget.noteData.content);  // Adjusted for the new structure
    noteTitleController = TextEditingController(text: widget.noteData.noteTitle);  // Adjusted for the new structure
  }

  @override
  void dispose() {
    notesController.dispose();
    noteTitleController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    Note updatedNote = Note(
      noteTitle: noteTitleController.text,
      content: notesController.text,
    );

    Navigator.pop(context, {'updatedNote': updatedNote});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View & Edit Note'),
        actions: [
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
          children: [
            TextField(
              controller: noteTitleController,
              decoration: InputDecoration(labelText: 'Note Title'),
            ),
            Expanded(
              child: TextField(
                controller: notesController,
                maxLines: null,
                decoration: InputDecoration(labelText: 'Your notes here...'),
              ),
            ),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}

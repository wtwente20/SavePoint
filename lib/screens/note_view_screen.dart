import 'package:flutter/material.dart';

import '../data/entry.dart';

class NoteViewScreen extends StatefulWidget {
  final Entry noteData;

  NoteViewScreen({required this.noteData});

  @override
  _NoteViewScreenState createState() => _NoteViewScreenState();
}

class _NoteViewScreenState extends State<NoteViewScreen> {
  late TextEditingController notesController;
  late TextEditingController entryNameController;

  @override
  void initState() {
    super.initState();
    notesController = TextEditingController(text: widget.noteData.note);
    entryNameController = TextEditingController(text: widget.noteData.noteTitle);
  }

  @override
  void dispose() {
    notesController.dispose();
    entryNameController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    Entry updatedNote = Entry(
      category: widget.noteData.category,
      title: widget.noteData.title, // Keeping the original title intact
      noteTitle: entryNameController.text,
      note: notesController.text,
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
              // Logic to delete the note
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
              controller: entryNameController,
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

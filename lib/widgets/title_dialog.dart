import 'package:flutter/material.dart';

class TitleDialog {
  final TextEditingController _titleController = TextEditingController();

  Future<String?> show(BuildContext context) {
    _titleController
        .clear(); // Clear the controller to make sure it starts empty
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Title'),
          content: TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title Name'),
          ),
          actions: [
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () {
                Navigator.of(context).pop(_titleController.text);
              },
            ),
          ],
        );
      },
    );
  }
}

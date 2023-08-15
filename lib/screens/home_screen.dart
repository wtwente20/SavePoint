import 'package:flutter/material.dart';

import 'entry_notes_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, List<String>> categories = {
    'Books': [],
    'Video Games': [],
    'Tabletop RPGs': []
  };

  Map<String, Map<String, String>> categoryEntriesWithNotes = {
    'Books': {},
    'Video Games': {},
    'TRPGs': {}
  };

  void _addNewCategory(String category) {
    setState(() {
      categories[category] = [];
    });
  }

  void _addNewEntry(String category) async {
    final newEntry = await _showAddEntryDialog(context);
    if (newEntry != null && newEntry.isNotEmpty) {
      setState(() {
        categories[category]?.add(newEntry);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Categories')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: categories.keys.length,
              itemBuilder: (ctx, index) {
                String key = categories.keys.elementAt(index);
                return Card(
                  child: ExpansionTile(
                    title: Text(key),
                    children: [
                      ...categories[key]!.map((entry) => ListTile(
                            title: Text(entry),
                            subtitle: Text(
                                categoryEntriesWithNotes[key]![entry] ?? "No notes yet"),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EntryNotesScreen(
                                  category: key,
                                  entry: entry,
                                  notesMap: categoryEntriesWithNotes[key] ?? {},
                                ),
                              ));
                            },
                          )),
                      

                      // Add the Divider here to separate "Add Entry" from the rest
                      Divider(),

                      ListTile(
                        leading: Icon(Icons.add_box,
                            color: Colors.green), // Add an icon for visibility
                        title: Text(
                          'Add Entry',
                          style: TextStyle(
                              color: Colors
                                  .green, // Make the text green for emphasis
                              fontWeight: FontWeight
                                  .bold // Make the text bold for added emphasis
                              ),
                        ),
                        onTap: () => _addNewEntry(key),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Add New Category'),
            onPressed: () async {
              // This will show a dialog to add a new category
              final newCategory = await _showAddCategoryDialog(context);
              if (newCategory != null && newCategory.isNotEmpty) {
                _addNewCategory(newCategory);
              }
            },
          )
        ],
      ),
    );
  }

  Future<String?> _showAddCategoryDialog(BuildContext context) {
    TextEditingController _categoryController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Category'),
          content: TextField(
            controller: _categoryController,
            decoration: InputDecoration(labelText: 'Category Name'),
          ),
          actions: [
            ElevatedButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Closes the dialog
              },
            ),
            ElevatedButton(
              child: Text('Add'),
              onPressed: () {
                Navigator.of(context).pop(_categoryController.text);
              },
            ),
          ],
        );
      },
    );
  }

  Future<String?> _showAddEntryDialog(BuildContext context) {
    TextEditingController _entryController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Entry'),
          content: TextField(
            controller: _entryController,
            decoration: InputDecoration(labelText: 'Entry Name'),
          ),
          actions: [
            ElevatedButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Closes the dialog
              },
            ),
            ElevatedButton(
              child: Text('Add'),
              onPressed: () {
                Navigator.of(context).pop(_entryController.text);
              },
            ),
          ],
        );
      },
    );
  }
}

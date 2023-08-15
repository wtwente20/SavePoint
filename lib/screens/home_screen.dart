import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, List<String>> categories = {
    'Books': [],
    'Video Games': [],
    'Tabletop RPGs': [],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: ListView(
        children: categories.keys.map((category) {
          return Card(
            child: ExpandablePanel(
              header: Text(category),
              collapsed: Text('Tap to view entries'),
              expanded: categories[category]?.isEmpty ?? true
                  ? ElevatedButton(
                      onPressed: () {
                        // TODO: Navigate to add entry screen or handle adding entry
                      },
                      child: Text('Add Entry'),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: categories[category]?.length ?? 0,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(categories[category]![index]),
                        );
                      },
                    ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

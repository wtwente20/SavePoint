import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savepoint_app/widgets/title_card.dart';

import '../providers/entry_provider.dart';

class CategoryCard extends ConsumerWidget {
  final String categoryKey;
  final Function addNewTitleCallback;
  final Function addOrUpdateEntryCallback; // Add this line

  CategoryCard({
    required this.categoryKey,
    required this.addNewTitleCallback,
    required this.addOrUpdateEntryCallback, // Add this line
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(entryListProvider);

    // Filter out unique titles that belong to the current category
    final categoryTitles = entries
        .where((e) => e.category == categoryKey && e.title.isNotEmpty)
        .map((e) => e.title)
        .toSet()
        .toList();

    return Card(
      child: ExpansionTile(
        title: Text(categoryKey),
        children: [
          ...categoryTitles.map((title) {
            final titleEntry = entries.firstWhere((e) => e.title == title);
            return TitleCard(
              titleEntry: titleEntry,  // Only pass the titleEntry parameter
            );
          }).toList(),
          ListTile(
            leading: const Icon(Icons.add_box, color: Colors.green),
            title: const Text('Add Title'),
            onTap: () => addNewTitleCallback(categoryKey),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savepoint_app/screens/sign_in_screen.dart';

import '../data/entry.dart';
import '../providers/entry_provider.dart';
import '../providers/theme_provider.dart';
import '../services/auth_service.dart';
import '../services/data_service.dart';
import '../widgets/category_card.dart';
import '../widgets/category_dialog.dart';
import '../widgets/title_dialog.dart';
import 'add_entry_screen.dart';
import 'get_started_screen.dart';

class HomeScreen extends ConsumerWidget {
  final AuthService _authService = AuthService();
  final DataService _dataService = DataService();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseUser = ref.watch(authStateChangesProvider).when(
          data: (user) => user,
          loading: () => null,
          error: (err, _) => null,
        );

    final entries = firebaseUser != null ? ref.watch(entryListProvider) : [];
    final themeMode = ref.watch(themeProvider);

    void _addNewCategory(String category) {
      ref.read(entryListProvider.notifier).addCategory(category);
    }

    void _addNewTitle(String category) async {
      final titleDialog = TitleDialog();
      final newTitle = await titleDialog.show(context);

      if (newTitle != null && newTitle.isNotEmpty) {
        ref.read(entryListProvider.notifier).addEntry(
              Entry(id: '', category: category, title: newTitle, notes: []),
            );
      }
    }

    void _addOrUpdateEntry(String category, String title) async {
      final result = await Navigator.of(context).push<Map<String, dynamic>>(
        MaterialPageRoute(
          builder: (BuildContext context) => AddEntryScreen(
            entryData:
                Entry(id: '', category: category, title: title, notes: []),
          ),
        ),
      );

      if (result != null && result['updatedNote'] != null) {
        final oldTitle = result['oldTitle'] ?? '';
        final updatedNote = result['updatedNote'] as Note;

        ref.read(entryListProvider.notifier).addNoteToTitle(
              category,
              oldTitle,
              updatedNote,
            );
      }
    }

    void _showGetStartedPopup() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const GetStartedScreen()),
      );
    }

    final categories = entries.map((e) => e.category).toSet().toList();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Fetch the value from Firebase RTD
      bool showPopup = await _dataService.fetchShowGetStartedPopup();
      if (showPopup) {
        _showGetStartedPopup();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('SavePoint'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              if (themeMode == ThemeMode.light) {
                ref.read(themeProvider.notifier).state = ThemeMode.dark;
              } else {
                ref.read(themeProvider.notifier).state = ThemeMode.light;
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final bool? shouldLogOut = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Logout Confirmation"),
                  content: const Text(
                    "Are you sure you want to log out?",
                  ),
                  actions: [
                    TextButton(
                      child: const Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context)
                            .pop(false); // Return false to not log out
                      },
                    ),
                    TextButton(
                      child: const Text("Logout"),
                      onPressed: () {
                        Navigator.of(context)
                            .pop(true); // Return true to confirm logout
                      },
                    ),
                  ],
                ),
              );

              // If the user confirmed to log out
              if (shouldLogOut == true) {
                await _authService.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                  (Route<dynamic> route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (ctx, index) {
                return Dismissible(
                  key: ValueKey(categories[index]),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    String deletedCategory = categories[index];
                    ref.read(entryListProvider.notifier).removeCategory(
                          deletedCategory,
                        );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Category deleted')),
                    );
                  },
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Delete Category?"),
                        content: const Text(
                          "Are you sure you want to delete this category? All titles in this category will be lost.",
                        ),
                        actions: [
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          TextButton(
                            child: const Text("Delete"),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  child: CategoryCard(
                    categoryKey: categories[index],
                    addNewTitleCallback: _addNewTitle,
                    addOrUpdateEntryCallback: _addOrUpdateEntry,
                  ),
                );
              },
            ),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add New Category'),
            onPressed: () async {
              final categoryDialog = CategoryDialog();
              final newCategory = await categoryDialog.show(context);

              if (newCategory != null && newCategory.isNotEmpty) {
                _addNewCategory(newCategory);
              }
            },
          ),
        ],
      ),
    );
  }
}

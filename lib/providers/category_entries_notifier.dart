import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryEntriesProvider
    extends StateNotifier<Map<String, Map<String, String>>> {
  CategoryEntriesProvider()
      : super({
          'Books': {},
          'Video Games': {},
          'TRPGs': {},
        });

  void updateEntry(String category, String entry, String note) {
    state[category] = {
      ...(state[category] ?? {}),
      entry: note,
    };
  }

  void addCategory(String category) {
    state[category] = {};
  }
}

final categoryEntriesProvider = StateNotifierProvider<CategoryEntriesProvider,
    Map<String, Map<String, String>>>((ref) => CategoryEntriesProvider());

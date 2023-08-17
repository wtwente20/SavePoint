import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/theme_provider.dart'; // Import your theme provider
import 'screens/home_screen.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: Color.fromARGB(255, 10, 40, 175),
);

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 5, 99, 125),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ProviderScope(
      child: SavePoint(),
    ),
  );
}

class SavePoint extends ConsumerWidget {
  const SavePoint({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'SavePoint',
      darkTheme: ThemeData.dark().copyWith(
          // ... (all your dark theme configurations here)
          ),
      theme: ThemeData().copyWith(
          // ... (all your light theme configurations here)
          ),
      themeMode: themeMode,
      home: HomeScreen(),
    );
  }
}

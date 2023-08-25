import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savepoint_app/screens/auth_wrapper.dart';

import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 10, 40, 175),
);

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 5, 99, 125),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const ProviderScope(
      child: SavePoint(),
    ),
  );
}

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

class SavePoint extends ConsumerWidget {
  const SavePoint({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final firebaseUserAsyncValue = ref.watch(authStateChangesProvider);

    return MaterialApp(
      title: 'SavePoint',
      darkTheme: ThemeData.dark().copyWith(),
      theme: ThemeData().copyWith(),
      themeMode: themeMode,
      routes: {
        '/home': (context) => HomeScreen(),
        // Add other routes here as necessary
      },
      home: firebaseUserAsyncValue.when(
        data: (firebaseUser) => firebaseUser != null ? HomeScreen() : const AuthWrapper(),
        loading: () => const CircularProgressIndicator(), // Display a loading spinner while waiting
        error: (error, stack) => const Center(child: Text('An error occurred')), // Handle error state
      ),
    );
  }
}

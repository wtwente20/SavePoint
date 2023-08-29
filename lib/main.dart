import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savepoint_app/screens/auth_wrapper.dart';

import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';

Future main() async {  // <-- Make main() async
  await dotenv.load(fileName: ".env");  // <-- Load the .env file

  WidgetsFlutterBinding.ensureInitialized();

  // Define required keys
const requiredEnvKeys = [
  'API_KEY',
  'AUTH_DOMAIN',
  'DATABASE_URL',
  'PROJECT_ID',
  'STORAGE_BUCKET',
  'MESSAGING_SENDER_ID',
  'APP_ID',
  'MEASUREMENT_ID'
];

// Validate required keys
final env = dotenv.env;
for (final key in requiredEnvKeys) {
  if (env[key] == null) {
    throw Exception('$key is missing in .env file');
  }
}

// Initialize Firebase using environment variables
final firebaseOptions = FirebaseOptions(
  apiKey: env['API_KEY']!,
  authDomain: env['AUTH_DOMAIN']!,
  databaseURL: env['DATABASE_URL']!,
  projectId: env['PROJECT_ID']!,
  storageBucket: env['STORAGE_BUCKET']!,
  messagingSenderId: env['MESSAGING_SENDER_ID']!,
  appId: env['APP_ID']!,
  measurementId: env['MEASUREMENT_ID']!,
);

await Firebase.initializeApp(options: firebaseOptions);

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

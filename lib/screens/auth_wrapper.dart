import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savepoint_app/screens/sign_in_screen.dart';

import '../services/auth_service.dart';
import 'home_screen.dart';

class AuthWrapper extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUser = ref.watch(authStateChangesProvider);

    if (asyncUser is AsyncData<User?>) {
      final firebaseUser = asyncUser.value;

      if (firebaseUser != null) {
        return HomeScreen();
      }
    }

    return SignInScreen();
  }
}

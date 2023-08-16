import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/home_screen.dart';

void main() => runApp(
  const ProviderScope(
    child: SavePoint(),
  ),
);

class SavePoint extends StatelessWidget {
  const SavePoint ({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SavePoint',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = StateProvider<ThemeMode>((ref) {
  final Brightness brightness = WidgetsBinding.instance.window.platformBrightness;
  return brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
});

import 'package:flutter/material.dart';

/// Provides the application's shared Material themes.
abstract final class AppTheme {
  /// The light application theme.
  static ThemeData get light => _buildTheme(Brightness.light);

  /// The dark application theme.
  static ThemeData get dark => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    return ThemeData(
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: brightness,
      ),
      useMaterial3: true,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:random_color_test/random_color_screen.dart';

/// Root application widget
class RandomColorApp extends StatelessWidget {
  /// Initialises root application widget
  const RandomColorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Random Color App',
      home: RandomColorScreen(),
    );
  }
}

import 'dart:math' show Random;

import 'package:flutter/material.dart';

/// Lazy Singleton Color wrapper with interface
/// providing random color and it's correspondent luminance color
class AppColorRandomizer {
  static const _maxColorHex = 0xFFFFFFFF;
  static const _luminanceEdge = 0.5;
  static AppColorRandomizer? _instance;

  /// Stores current random color's state
  Color _currentColor = const Color(_maxColorHex).withOpacity(1.0);

  /// Provides read-only access to [_currentColor] state variable
  Color get currentColor => _currentColor;

  /// Initiates [AppColorRandomizer] instance lazily
  factory AppColorRandomizer() => _instance ?? AppColorRandomizer._internal();

  AppColorRandomizer._internal() {
    _instance = this;
    getRandomColor();
  }

  /// Generates random color and updates [_currentColor] state with it
  Color getRandomColor() {
    return _currentColor =
        Color(Random().nextInt(_maxColorHex)).withOpacity(1.0);
  }

  /// Provides a luminant to [_currentColor]'s state
  Color getCurrentColorLuminant() {
    return _currentColor.computeLuminance() > _luminanceEdge
        ? Colors.black
        : Colors.white;
  }
}

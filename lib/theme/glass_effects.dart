// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GlassEffects {
  final List<Color> bgGradient;
  final List<Color> borderGradient;
  final double blur;

  const GlassEffects({
    required this.bgGradient,
    this.borderGradient = const [],
    this.blur = 20.0,
  });

  // ==========================================================================
  // LIQUID BLUE
  // ==========================================================================

  static GlassEffects get liquidBlue => GlassEffects(
    bgGradient: [
      Colors.blue.shade400.withValues(alpha: 0.65),
      Colors.blue.shade900.withValues(alpha: 0.35),
    ],
  );

  // ==========================================================================
  // LIQUID RED
  // ==========================================================================

  static GlassEffects get liquidRed => GlassEffects(
    bgGradient: [
      Colors.redAccent.shade400.withValues(alpha: 0.70),
      Colors.red.shade900.withValues(alpha: 0.40),
    ],
  );

  // ==========================================================================
  // LIQUID GREEN
  // ==========================================================================

  static GlassEffects get liquidGreen => GlassEffects(
    bgGradient: [
      Colors.tealAccent.shade400.withValues(alpha: 0.60),
      Colors.green.shade900.withValues(alpha: 0.40),
    ],
  );

  // ==========================================================================
  // LIQUID AMBER
  // ==========================================================================

  static GlassEffects get liquidAmber => GlassEffects(
    bgGradient: [
      Colors.orange.shade400.withValues(alpha: 0.65),
      Colors.amber.shade900.withValues(alpha: 0.35),
    ],
  );

  // ==========================================================================
  // LIQUID DARK
  // ==========================================================================

  static GlassEffects get liquidDark => GlassEffects(
    bgGradient: [
      Colors.indigo.shade900.withValues(alpha: 0.50),
      Colors.black.withValues(alpha: 0.65),
    ],
  );

  // ==========================================================================
  // LIQUID WHITE
  // ==========================================================================

  static GlassEffects get liquidWhite => GlassEffects(
    bgGradient: [
      // Très bas pour conserver la transparence vitreuse.
      Colors.white.withValues(alpha: 0.12),
      Colors.white.withValues(alpha: 0.02),
    ],
  );

  // ==========================================================================
  // EQUALITY
  // ==========================================================================

  @override
  bool operator ==(covariant GlassEffects other) {
    if (identical(this, other)) {
      return true;
    }

    return listEquals(other.bgGradient, bgGradient) &&
        listEquals(other.borderGradient, borderGradient) &&
        other.blur == blur;
  }

  // ==========================================================================
  // HASH CODE
  // ==========================================================================

  @override
  int get hashCode =>
      bgGradient.hashCode ^ borderGradient.hashCode ^ blur.hashCode;
}

import 'package:flutter/material.dart';

class GlassClassicSbDecoration {
  const GlassClassicSbDecoration._();

  /// Génère la décoration asymétrique exacte "Welcome Card" (Aqua / Classic).
  static BoxDecoration resolve({
    required bool useAquaStyle,
    double borderRadius = 26.0,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: useAquaStyle
            ? [
                Colors.white.withValues(alpha: .15),
                Colors.cyanAccent.withValues(alpha: .055),
                Colors.white.withValues(alpha: .035),
              ]
            : [
                Colors.white.withValues(alpha: .10),
                Colors.white.withValues(alpha: .035),
              ],
      ),
      border: Border.all(color: Colors.white.withValues(alpha: .14)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .20),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }
}

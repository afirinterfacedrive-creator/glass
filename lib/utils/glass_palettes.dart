import 'package:flutter/material.dart';
import 'package:universal_glass/theme/glass_color_palette.dart';

/// Palettes centralisées pour toute l'app.
class GlassPalettes {
  GlassPalettes._();

  /// Palette par défaut KDTV - Aqua.
  static const GlassColorPalette aqua = GlassColorPalette(
    aqua: Color(0xFF4DD0E1),
    aquaLight: Color(0xFF80DEEA),
    aquaDark: Color(0xFF0097A7),

    classic: Color(0xFFFFA726),
    classicLight: Color(0xFFFFCC80),
    classicDark: Color(0xFFEF6C00),

    surface: Color(0xFF172027),
    surfaceSecondary: Color(0xFF10161C),

    white: Colors.white,
    black: Colors.black,

    textPrimary: Colors.white,
    textSecondary: Color(0xB3FFFFFF),
    textTertiary: Color(0x80FFFFFF),
    textDisabled: Color(0x4DFFFFFF),

    border: Color(0x2EFFFFFF),

    success: Color(0xFF69F0AE),
    warning: Color(0xFFFFD740),
    error: Color(0xFFFF5252),
    info: Color(0xFF40C4FF),

    accent: Color(0xFF4DD0E1),
  );

  /// Palette Classic Orange.
  static const GlassColorPalette classic = GlassColorPalette(
    aqua: Color(0xFF4DD0E1),
    aquaLight: Color(0xFF80DEEA),
    aquaDark: Color(0xFF0097A7),

    classic: Color(0xFFFFA726),
    classicLight: Color(0xFFFFCC80),
    classicDark: Color(0xFFEF6C00),

    surface: Color(0xFF172027),
    surfaceSecondary: Color(0xFF10161C),

    white: Colors.white,
    black: Colors.black,

    textPrimary: Colors.white,
    textSecondary: Color(0xB3FFFFFF),
    textTertiary: Color(0x80FFFFFF),
    textDisabled: Color(0x4DFFFFFF),

    border: Color(0x2EFFFFFF),

    success: Color(0xFF69F0AE),
    warning: Color(0xFFFFD740),
    error: Color(0xFFFF5252),
    info: Color(0xFF40C4FF),

    accent: Color(0xFFFFA726),
  );
}
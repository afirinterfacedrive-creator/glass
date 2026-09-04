import 'package:flutter/material.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/provider/glass_theme_provider.dart';
import 'package:universal_glass/theme/glass_color_palette.dart';

class GlassSurfaceGradient {
  const GlassSurfaceGradient._();

  static List<Color> resolve({
    required GlassStyle style,
    required bool useAquaStyle,
    required double baseAlpha,
    required GlassColorPalette palette,
    required GlassThemeState theme,
    List<Color>? customGradient,
    List<Color>? loadedGradient,
  }) {
    // ==========================================================================
    // PRIORITÉ 1 : GRADIENT DU WIDGET / GRADIENT CHARGÉ
    // ==========================================================================
    final List<Color>? source = customGradient ?? loadedGradient;
    if (source != null && source.isNotEmpty) {
      return source.map((color) => color.withValues(alpha: baseAlpha)).toList();
    }

    // ==========================================================================
    // PRIORITÉ 2 : GRADIENT DU THÈME DYNAMIQUE
    // ==========================================================================
    final List<Color>? themeGradient = theme.customGradientColors;
    if (themeGradient != null && themeGradient.isNotEmpty) {
      final double opacity = theme.gradientOpacity;
      return themeGradient
          .map((color) => color.withValues(alpha: baseAlpha * opacity))
          .toList();
    }

    // ==========================================================================
    // PRIORITÉ 3 : STYLES DU PACKAGE (Switch exhaustif)
    // ==========================================================================
    switch (style) {
      case GlassStyle.classicSb:
        return [
          Colors.white.withValues(alpha: 0.10),
          Colors.white.withValues(alpha: 0.035),
        ];

      case GlassStyle.sage:
        return [
          Colors.black.withValues(alpha: 0.85 * baseAlpha),
          Colors.black.withValues(alpha: 0.2 * baseAlpha),
          Colors.black.withValues(alpha: 0.4 * baseAlpha),
        ];

      case GlassStyle.sagePro:
        return [
          Colors.black.withValues(alpha: 0.10),
          Colors.black.withValues(alpha: 0.04),
        ];

      case GlassStyle.sageOled:
        return [
          Colors.black,
          const Color(0xFF0A0A0A),
        ];

      case GlassStyle.sageGlass:
        return [
          Colors.black.withValues(alpha: 0.05),
          Colors.black.withValues(alpha: 0.10),
        ];

      case GlassStyle.opaqueHeavy:
      case GlassStyle.opaqueMat:
        if (!useAquaStyle) {
          return [
            const Color(0xFF121212).withValues(alpha: baseAlpha),
            const Color(0xFF1E1E1E).withValues(alpha: baseAlpha * 0.95),
          ];
        }
        return [
          const Color(0xFF0D151C).withValues(alpha: baseAlpha),
          const Color(0xFF131D26).withValues(alpha: baseAlpha * 0.95),
        ];

      default:
        // ==========================================================================
        // FALLBACKS (Si aucun style préconfiguré ne correspond)
        // ==========================================================================
        if (!useAquaStyle) {
          return [
            const Color(0xFF121212).withValues(alpha: baseAlpha),
            const Color(0xFF1A1A1A).withValues(alpha: baseAlpha * 0.9),
          ];
        }

        // FALLBACK AQUA DYNAMIQUE
        final Color primary = palette.primaryForStyle(true);
        final int density = theme.gradientDensity;

        if (density <= 2) {
          return [
            primary.withValues(alpha: baseAlpha),
            primary.withValues(alpha: baseAlpha * 0.6),
          ];
        }
        if (density == 3) {
          return [
            primary.withValues(alpha: baseAlpha),
            primary.withValues(alpha: baseAlpha * 0.7),
            primary.withValues(alpha: baseAlpha * 0.4),
          ];
        }
        return [
          primary.withValues(alpha: baseAlpha),
          primary.withValues(alpha: baseAlpha * 0.8),
          primary.withValues(alpha: baseAlpha * 0.6),
          primary.withValues(alpha: baseAlpha * 0.3),
        ];
    }
  }
}

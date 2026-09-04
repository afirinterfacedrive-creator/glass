import 'package:flutter/material.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/provider/glass_theme_provider.dart';
import 'package:universal_glass/theme/glass_color_palette.dart';

class GlassGradientResolution {
  final List<Color> colors;
  final List<double>? stops;
  const GlassGradientResolution({required this.colors, this.stops});
}

class GlassSurfaceGradientResolver {
  static GlassGradientResolution resolve({
    required GlassStyle style,
    required bool isClassicSb,
    required bool useAquaStyle,
    required Color accent,
    required double baseAlpha,
    required double disabledAlpha,
    required GlassColorPalette palette,
    required GlassThemeState theme,
    required List<Color>? customGradient,
    required List<Color>? loadedGradient,
    required List<Color> Function() originalResolver,
  }) {
    // PRIORITE 1: Gradient chargé
    if (loadedGradient != null && loadedGradient.isNotEmpty) {
      return _applyDisabled(loadedGradient, baseAlpha, disabledAlpha);
    }
    // PRIORITE 2: Gradient custom
    if (customGradient != null && customGradient.isNotEmpty) {
      return _applyDisabled(customGradient, baseAlpha, disabledAlpha);
    }

    List<Color> gradientColors;
    List<double>? gradientStops;

    // 1. CLASSIC SB
    if (isClassicSb) {
      if (useAquaStyle) {
        gradientColors = [
          Colors.white.withValues(alpha: .15),
          Colors.cyanAccent.withValues(alpha: .055),
          Colors.white.withValues(alpha: .035),
        ];
      } else {
        gradientColors = [
          Colors.white.withValues(alpha: .10),
          Colors.white.withValues(alpha: .035),
        ];
      }
      gradientStops = null; 
    } 
    
    // 2. STYLES SPECIFIQUES
    else {
      switch (style) {
        // ==========================================================================
        // CONFIGURATION SIGNATURE : transparentAqua
        // ==========================================================================
        case GlassStyle.transparentAqua:
          if (useAquaStyle) {
            gradientColors = [
              Colors.white.withValues(alpha: .15),
              Colors.cyanAccent.withValues(alpha: .055),
              Colors.white.withValues(alpha: .035),
            ];
          } else {
            gradientColors = [
              Colors.white.withValues(alpha: .10),
              Colors.white.withValues(alpha: .035),
            ];
          }
          gradientStops = null; 
          break;

        // ==========================================================================
        // SAGE PACK - Fond sombre uni avec reflet
        // ==========================================================================
        case GlassStyle.sage:
          gradientColors = [
            Colors.black.withValues(alpha: baseAlpha),
            Colors.black.withValues(alpha: baseAlpha * 0.9),
          ];
          gradientStops = [0.0, 1.0];
          break;
        
        case GlassStyle.sagePro:
          gradientColors = [
            Colors.black.withValues(alpha: baseAlpha),
            Colors.black.withValues(alpha: baseAlpha),
          ];
          gradientStops = [0.0, 1.0];
          break;

        case GlassStyle.sageOled:
          gradientColors = [
            Colors.black, // #000 100%
            Colors.black,
          ];
          gradientStops = [0.0, 1.0];
          break;

        case GlassStyle.sageGlass:
          gradientColors = [
            Colors.black.withValues(alpha: baseAlpha),
            const Color(0xFF0A0A0A).withValues(alpha: baseAlpha * 0.8),
          ];
          gradientStops = [0.0, 1.0];
          break;

        // ==========================================================================
        // DEFAULT : THEME DYNAMIQUE / STANDARD
        // ==========================================================================
        default:
          if (theme.customGradientColors != null) {
            gradientColors = theme.customGradientColors!
                .map((c) => c.withValues(alpha: baseAlpha))
                .toList();
            gradientStops = null;
          } else {
            gradientColors = originalResolver();
            gradientStops = null;
          }
      }
    }

    // Application finale du ratio d'opacité si l'élément est désactivé
    return _applyDisabled(gradientColors, baseAlpha, disabledAlpha, stops: gradientStops);
  }

  static GlassGradientResolution _applyDisabled(
    List<Color> colors, 
    double baseAlpha, 
    double disabledAlpha, {
    List<double>? stops
  }) {
    if (baseAlpha != disabledAlpha) {
      final double ratio = baseAlpha > 0 ? (disabledAlpha / baseAlpha) : 1.0;
      
      final disabledColors = colors.map((c) {
        // ignore: deprecated_member_use
        return c.withValues(alpha: (c.alpha * ratio).clamp(0.0, 1.0));
      }).toList();

      return GlassGradientResolution(colors: disabledColors, stops: stops);
    }
    
    return GlassGradientResolution(colors: colors, stops: stops);
  }
}
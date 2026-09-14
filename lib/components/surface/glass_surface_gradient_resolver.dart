import 'package:flutter/material.dart';

import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/provider/glass_theme_state.dart';
import 'package:universal_glass/theme/glass_color_palette.dart';

import 'glass_surface_gradient.dart';

class GlassGradientResolution {
  final List<Color> colors;
  final List<double>? stops;

  const GlassGradientResolution({
    required this.colors,
    this.stops,
  });
}

class GlassSurfaceGradientResolver {
  const GlassSurfaceGradientResolver._();

  /// Résolution centralisée du gradient.
  ///
  /// Toute la logique réelle appartient à [GlassSurfaceGradient].
  ///
  /// Ce resolver existe uniquement comme couche intermédiaire pour
  /// conserver une API propre côté renderer.
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
    final List<Color> colors =
        GlassSurfaceGradient.resolve(
      style: style,
      useAquaStyle: useAquaStyle,
      baseAlpha: baseAlpha,
      palette: palette,
      theme: theme,
      customGradient: customGradient,
      loadedGradient: loadedGradient,
    );

    return GlassGradientResolution(
      colors: List<Color>.from(colors),
      stops: null,
    );
  }

  /// Résolution du gradient original du renderer.
  ///
  /// Conservée uniquement pour les cas de compatibilité où le renderer
  /// possède encore une résolution spécifique.
  static GlassGradientResolution resolveOriginal({
    required List<Color> Function() originalResolver,
  }) {
    final List<Color> colors =
        originalResolver();

    return GlassGradientResolution(
      colors: List<Color>.from(colors),
      stops: null,
    );
  }
}
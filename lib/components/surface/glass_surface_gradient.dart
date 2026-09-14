import 'package:flutter/material.dart';

import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/provider/glass_theme_state.dart';
import 'package:universal_glass/theme/glass_color_palette.dart';

/// Résout les couleurs d'un gradient Glass.
///
/// Cette classe ne dessine aucun widget.
///
/// Elle est uniquement responsable de déterminer les couleurs finales
/// utilisées par [GlassSurfaceRenderer].
///
/// Ordre de priorité :
///
/// 1. [customGradient]
/// 2. [loadedGradient]
/// 3. gradient personnalisé du thème
/// 4. gradient associé au [GlassStyle]
class GlassSurfaceGradient {
  const GlassSurfaceGradient._();

  // ===========================================================================
  // RESOLUTION PRINCIPALE
  // ===========================================================================

  /// Résout le gradient final d'une surface Glass.
  ///
  /// [baseAlpha] représente l'opacité globale appliquée par la surface.
  ///
  /// Pour les gradients ayant déjà un alpha intrinsèque, celui-ci est
  /// conservé puis multiplié par [baseAlpha].
  static List<Color> resolve({
    required GlassStyle style,
    required bool useAquaStyle,
    required double baseAlpha,
    required GlassColorPalette palette,
    required GlassThemeState theme,
    List<Color>? customGradient,
    List<Color>? loadedGradient,
  }) {
    final double alpha = _clampAlpha(baseAlpha);

    // -------------------------------------------------------------------------
    // 1. GRADIENT FOURNI DIRECTEMENT
    // -------------------------------------------------------------------------

    if (customGradient != null &&
        customGradient.isNotEmpty) {
      return _applyAlpha(
        customGradient,
        alpha,
      );
    }

    // -------------------------------------------------------------------------
    // 2. GRADIENT CHARGÉ DEPUIS LE STOCKAGE
    // -------------------------------------------------------------------------

    if (loadedGradient != null &&
        loadedGradient.isNotEmpty) {
      return _applyAlpha(
        loadedGradient,
        alpha,
      );
    }

    // -------------------------------------------------------------------------
    // 3. GRADIENT PERSONNALISÉ DU THÈME
    // -------------------------------------------------------------------------

    final List<Color>? themeGradient =
        theme.customGradientColors;

    if (themeGradient != null &&
        themeGradient.isNotEmpty) {
      final double themeOpacity =
          _clampAlpha(theme.gradientOpacity);

      return _applyAlpha(
        themeGradient,
        alpha * themeOpacity,
      );
    }

    // -------------------------------------------------------------------------
    // 4. GRADIENT ASSOCIÉ AU STYLE
    // -------------------------------------------------------------------------

    switch (style) {
      case GlassStyle.classicSb:
        return _resolveClassicSbGradient(
          useAquaStyle: useAquaStyle,
          baseAlpha: alpha,
        );

      case GlassStyle.transparentAqua:
        return _resolveTransparentAquaGradient(
          useAquaStyle: useAquaStyle,
          baseAlpha: alpha,
        );

      case GlassStyle.transparentRed:
        return _resolveTransparentRedGradient(
          baseAlpha: alpha,
        );

      case GlassStyle.transparentGreen:
        return _resolveTransparentGreenGradient(
          baseAlpha: alpha,
        );

      case GlassStyle.gradientOpaque:
        return _resolveDynamicGradient(
          useAquaStyle: useAquaStyle,
          baseAlpha: alpha,
          palette: palette,
          theme: theme,
        );

      case GlassStyle.customGradient:
      case GlassStyle.custom:
        return _resolveDynamicGradient(
          useAquaStyle: useAquaStyle,
          baseAlpha: alpha,
          palette: palette,
          theme: theme,
        );

      case GlassStyle.opaqueHeavy:
      case GlassStyle.opaqueMat:
        return _resolveOpaqueGradient(
          useAquaStyle: useAquaStyle,
          baseAlpha: alpha,
        );

      case GlassStyle.solidAqua:
        return _resolveSolidGradient(
          color: palette.primaryForStyle(true),
          alpha: alpha,
        );

      case GlassStyle.solidClassic:
        return _resolveSolidGradient(
          color: palette.primaryForStyle(false),
          alpha: alpha,
        );
    }
  }

  // ===========================================================================
  // HELPERS ALPHA
  // ===========================================================================

  static double _clampAlpha(double value) {
    return value
        .clamp(0.0, 1.0)
        .toDouble();
  }

  /// Applique une opacité globale aux couleurs.
  ///
  /// IMPORTANT :
  /// l'alpha intrinsèque de chaque couleur est conservé.
  ///
  /// Exemple :
  ///
  /// couleur alpha = 0.15
  /// baseAlpha      = 0.80
  ///
  /// résultat :
  ///
  /// 0.15 × 0.80 = 0.12
  static List<Color> _applyAlpha(
    List<Color> colors,
    double alpha,
  ) {
    final double effectiveAlpha =
        _clampAlpha(alpha);

    return colors
        .map(
          (Color color) => color.withValues(
            alpha: _clampAlpha(
              color.a * effectiveAlpha,
            ),
          ),
        )
        .toList();
  }

  /// Crée une couleur avec une opacité calculée.
  ///
  /// Contrairement à [Color.withValues], cette méthode permet de conserver
  /// explicitement l'alpha de base lorsqu'il existe.
  static Color _withAlpha(
    Color color,
    double alpha,
  ) {
    return color.withValues(
      alpha: _clampAlpha(alpha),
    );
  }

  // ===========================================================================
  // CLASSIC SB
  // ===========================================================================

  static List<Color> _resolveClassicSbGradient({
    required bool useAquaStyle,
    required double baseAlpha,
  }) {
    if (useAquaStyle) {
      return _applyAlpha(
        [
          Colors.white.withValues(alpha: 0.15),
          Colors.cyanAccent.withValues(alpha: 0.055),
          Colors.white.withValues(alpha: 0.035),
        ],
        baseAlpha,
      );
    }

    return _applyAlpha(
      [
        Colors.white.withValues(alpha: 0.10),
        Colors.white.withValues(alpha: 0.035),
      ],
      baseAlpha,
    );
  }

  // ===========================================================================
  // TRANSPARENT AQUA
  // ===========================================================================

  static List<Color> _resolveTransparentAquaGradient({
    required bool useAquaStyle,
    required double baseAlpha,
  }) {
    if (useAquaStyle) {
      return _applyAlpha(
        [
          Colors.white.withValues(alpha: 0.15),
          Colors.cyanAccent.withValues(alpha: 0.055),
          Colors.white.withValues(alpha: 0.035),
        ],
        baseAlpha,
      );
    }

    return _applyAlpha(
      [
        Colors.white.withValues(alpha: 0.10),
        Colors.white.withValues(alpha: 0.035),
      ],
      baseAlpha,
    );
  }

  // ===========================================================================
  // TRANSPARENT RED
  // ===========================================================================

  static List<Color> _resolveTransparentRedGradient({
    required double baseAlpha,
  }) {
    return _applyAlpha(
      [
        Colors.white.withValues(alpha: 0.10),
        Colors.redAccent.withValues(alpha: 0.055),
        Colors.white.withValues(alpha: 0.035),
      ],
      baseAlpha,
    );
  }

  // ===========================================================================
  // TRANSPARENT GREEN
  // ===========================================================================

  static List<Color> _resolveTransparentGreenGradient({
    required double baseAlpha,
  }) {
    return _applyAlpha(
      [
        Colors.white.withValues(alpha: 0.10),
        Colors.greenAccent.withValues(alpha: 0.055),
        Colors.white.withValues(alpha: 0.035),
      ],
      baseAlpha,
    );
  }

  // ===========================================================================
  // OPAQUE
  // ===========================================================================

  static List<Color> _resolveOpaqueGradient({
    required bool useAquaStyle,
    required double baseAlpha,
  }) {
    final double alpha =
        _clampAlpha(baseAlpha);

    if (!useAquaStyle) {
      return [
        _withAlpha(
          const Color(0xFF121212),
          alpha,
        ),
        _withAlpha(
          const Color(0xFF1E1E1E),
          alpha * 0.95,
        ),
      ];
    }

    return [
      _withAlpha(
        const Color(0xFF0D151C),
        alpha,
      ),
      _withAlpha(
        const Color(0xFF131D26),
        alpha * 0.95,
      ),
    ];
  }

  // ===========================================================================
  // SOLID
  // ===========================================================================

  static List<Color> _resolveSolidGradient({
    required Color color,
    required double alpha,
  }) {
    final double effectiveAlpha =
        _clampAlpha(alpha);

    return [
      _withAlpha(
        color,
        effectiveAlpha,
      ),
      _withAlpha(
        color,
        effectiveAlpha * 0.95,
      ),
    ];
  }

  // ===========================================================================
  // DYNAMIC
  // ===========================================================================

  static List<Color> _resolveDynamicGradient({
    required bool useAquaStyle,
    required double baseAlpha,
    required GlassColorPalette palette,
    required GlassThemeState theme,
  }) {
    final double alpha =
        _clampAlpha(baseAlpha);

    // -------------------------------------------------------------------------
    // CLASSIC
    // -------------------------------------------------------------------------

    if (!useAquaStyle) {
      return [
        _withAlpha(
          const Color(0xFF121212),
          alpha,
        ),
        _withAlpha(
          const Color(0xFF1A1A1A),
          alpha * 0.90,
        ),
      ];
    }

    // -------------------------------------------------------------------------
    // AQUA
    // -------------------------------------------------------------------------

    final Color primary =
        palette.primaryForStyle(true);

    final int density =
        theme.gradientDensity
            .clamp(1, 10)
            .toInt();

    // -------------------------------------------------------------------------
    // DENSITY 1–2
    // -------------------------------------------------------------------------

    if (density <= 2) {
      return [
        _withAlpha(
          primary,
          alpha,
        ),
        _withAlpha(
          primary,
          alpha * 0.60,
        ),
      ];
    }

    // -------------------------------------------------------------------------
    // DENSITY 3
    // -------------------------------------------------------------------------

    if (density == 3) {
      return [
        _withAlpha(
          primary,
          alpha,
        ),
        _withAlpha(
          primary,
          alpha * 0.70,
        ),
        _withAlpha(
          primary,
          alpha * 0.40,
        ),
      ];
    }

    // -------------------------------------------------------------------------
    // DENSITY 4–10
    // -------------------------------------------------------------------------

    return [
      _withAlpha(
        primary,
        alpha,
      ),
      _withAlpha(
        primary,
        alpha * 0.80,
      ),
      _withAlpha(
        primary,
        alpha * 0.60,
      ),
      _withAlpha(
        primary,
        alpha * 0.30,
      ),
    ];
  }
}

import 'package:flutter/material.dart';

/// Décoration spécifique au style [GlassStyle.classicSb].
///
/// `classicSb` est volontairement traité comme un rendu spécial :
/// - pas de BackdropFilter ;
/// - pas de blur ;
/// - pas de noise ;
/// - surface visuellement dense ;
/// - gradient très léger ;
/// - ombre plus marquée ;
/// - aspect proche de la "Welcome Card".
///
/// Cette classe ne dépend pas du thème Riverpod.
/// Elle ne fait que construire la [BoxDecoration].
class GlassClassicSbDecoration {
  const GlassClassicSbDecoration._();

  /// Génère la décoration `classicSb`.
  ///
  /// [useAquaStyle] permet de conserver les deux variantes visuelles :
  /// Aqua et Classic.
  ///
  /// [borderRadius] contrôle uniquement le rayon de la surface.
  ///
  /// [border] permet au renderer de fournir une bordure calculée
  /// dynamiquement.
  ///
  /// [boxShadow] permet au renderer de fournir une ombre calculée
  /// dynamiquement.
  static BoxDecoration resolve({
    required bool useAquaStyle,
    double borderRadius = 26.0,
    Border? border,
    List<BoxShadow>? boxShadow,
  }) {
    final BorderRadius radius =
        BorderRadius.circular(
      borderRadius.clamp(0.0, 200.0),
    );

    final List<Color> gradientColors =
        _resolveGradientColors(
      useAquaStyle: useAquaStyle,
    );

    final Border effectiveBorder =
        border ??
        Border.all(
          color: Colors.white.withValues(
            alpha: 0.14,
          ),
          width: 1.0,
        );

    final List<BoxShadow> effectiveShadow =
        boxShadow ??
        _defaultShadow();

    return BoxDecoration(
      borderRadius: radius,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: gradientColors,
      ),
      border: effectiveBorder,
      boxShadow: effectiveShadow,
    );
  }

  // ===========================================================================
  // GRADIENT
  // ===========================================================================

  static List<Color> _resolveGradientColors({
    required bool useAquaStyle,
  }) {
    if (useAquaStyle) {
      return [
        Colors.white.withValues(
          alpha: 0.15,
        ),
        Colors.cyanAccent.withValues(
          alpha: 0.055,
        ),
        Colors.white.withValues(
          alpha: 0.035,
        ),
      ];
    }

    return [
      Colors.white.withValues(
        alpha: 0.10,
      ),
      Colors.white.withValues(
        alpha: 0.035,
      ),
    ];
  }

  // ===========================================================================
  // OMBRE PAR DÉFAUT
  // ===========================================================================

  static List<BoxShadow> _defaultShadow() {
    return [
      BoxShadow(
        color: Colors.black.withValues(
          alpha: 0.20,
        ),
        blurRadius: 24.0,
        offset: const Offset(
          0.0,
          10.0,
        ),
      ),
    ];
  }
}

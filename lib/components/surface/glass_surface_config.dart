import 'package:flutter/material.dart';

import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/provider/glass_theme_state.dart';
import 'package:universal_glass/theme/glass_effects.dart';

/// Configuration complète d'une surface Glass.
///
/// [GlassSurfaceConfig] représente l'état résolu d'une surface avant son
/// rendu.
///
/// Cette classe ne dessine rien.
///
/// Architecture :
///
/// GlassSurfaceContainer
///         ↓
/// GlassSurfaceConfig
///         ↓
/// GlassSurfaceRenderer
///
/// Responsabilités :
///
/// - [GlassSurfaceContainer] orchestre ;
/// - [GlassSurfaceConfig] transporte l'état ;
/// - [GlassSurfaceRenderer] dessine ;
/// - [GlassSurfaceStyle] interprète le style et le rôle.
class GlassSurfaceConfig {
  // ===========================================================================
  // IDENTITÉ
  // ===========================================================================

  /// Style visuel effectif de la surface.
  final GlassStyle style;

  /// Forme géométrique demandée.
  final GlassShapeType shape;

  /// Effets résolus pour cette surface.
  final GlassEffects? effects;

  /// Rôle fonctionnel de la surface.
  ///
  /// Le rôle permet d'adapter :
  ///
  /// - l'opacité ;
  /// - le blur ;
  /// - le noise ;
  /// - la profondeur ;
  /// - le contraste.
  final GlassSurfaceRole role;

  /// État global du thème Glass.
  final GlassThemeState theme;

  // ===========================================================================
  // ÉTAT INTERACTIF
  // ===========================================================================

  /// Surface actuellement focalisée.
  final bool isFocused;

  /// Surface actuellement en erreur.
  final bool hasError;

  /// Surface activée.
  final bool enabled;

  /// Pointeur actuellement au-dessus de la surface.
  final bool isHovered;

  /// Autorise le déplacement visuel au survol.
  final bool liftOnHover;

  // ===========================================================================
  // BORDURE
  // ===========================================================================

  /// Couleur de bordure personnalisée.
  final Color? borderColor;

  /// Couleur de bordure en état focus.
  final Color? focusBorderColor;

  /// Épaisseur normale de la bordure.
  final double? borderWidth;

  /// Épaisseur de bordure en état focus.
  final double? focusBorderWidth;

  /// Épaisseur de bordure en état erreur.
  final double? errorBorderWidth;

  // ===========================================================================
  // COULEURS PERSONNALISÉES
  // ===========================================================================

  /// Couleurs personnalisées Aqua.
  final List<Color>? customColorsAqua;

  /// Couleurs personnalisées Classic.
  final List<Color>? customColorsClassic;

  /// Gradient fourni directement par l'appelant.
  final List<Color>? customGradient;

  /// Gradient récupéré depuis le stockage.
  final List<Color>? loadedGradient;

  /// Identifiant du gradient utilisateur.
  final String? customKey;

  // ===========================================================================
  // FOND
  // ===========================================================================

  /// Couleur de fond locale éventuelle.
  ///
  /// Si aucune couleur n'est fournie, la palette du thème est utilisée.
  final Color? backgroundColor;

  // ===========================================================================
  // CONSTRUCTEUR
  // ===========================================================================

  const GlassSurfaceConfig({
    required this.style,
    required this.shape,
    required this.effects,
    required this.theme,
    required this.isFocused,
    required this.hasError,
    required this.enabled,
    required this.isHovered,
    required this.liftOnHover,
    this.role = GlassSurfaceRole.card,
    this.borderColor,
    this.focusBorderColor,
    this.borderWidth,
    this.focusBorderWidth,
    this.errorBorderWidth,
    this.customColorsAqua,
    this.customColorsClassic,
    this.customGradient,
    this.loadedGradient,
    this.customKey,
    this.backgroundColor,
  });

  // ===========================================================================
  // COULEUR DE FOND EFFECTIVE
  // ===========================================================================

  /// Retourne la couleur de fond effective.
  ///
  /// Une couleur locale est prioritaire.
  /// Sinon, la couleur de surface du thème est utilisée.
  Color get effectiveBackgroundColor {
    return backgroundColor ?? theme.palette.surface;
  }

  // ===========================================================================
  // GRADIENT EFFECTIF
  // ===========================================================================

  /// Retourne le gradient explicitement fourni à la surface.
  ///
  /// Priorité :
  ///
  /// 1. [customGradient]
  /// 2. [loadedGradient]
  /// 3. `null`
  ///
  /// Les gradients prédéfinis sont résolus par
  /// [GlassSurfaceGradientResolver].
  List<Color>? get effectiveGradient {
    if (customGradient != null &&
        customGradient!.isNotEmpty) {
      return customGradient;
    }

    if (loadedGradient != null &&
        loadedGradient!.isNotEmpty) {
      return loadedGradient;
    }

    return null;
  }

  // ===========================================================================
  // MODE AQUA
  // ===========================================================================

  /// Indique si le thème Aqua est actif.
  bool get useAqua {
    return theme.useAquaStyle;
  }

  // ===========================================================================
  // ÉTAT DU STYLE
  // ===========================================================================

  /// Indique si la surface est interactive.
  bool get isInteractive {
    return enabled &&
        (
          isFocused ||
          isHovered ||
          liftOnHover
        );
  }

  /// Indique si la surface est désactivée.
  bool get isDisabled {
    return !enabled;
  }

  /// Indique si un gradient local existe.
  bool get hasCustomGradient {
    return effectiveGradient != null;
  }

  /// Indique si une couleur de fond locale existe.
  bool get hasCustomBackground {
    return backgroundColor != null;
  }

  // ===========================================================================
  // COPY WITH
  // ===========================================================================

  /// Crée une nouvelle configuration.
  ///
  /// Les valeurs non spécifiées sont conservées.
  GlassSurfaceConfig copyWith({
    GlassStyle? style,
    GlassShapeType? shape,
    GlassEffects? effects,
    GlassSurfaceRole? role,
    GlassThemeState? theme,
    bool? isFocused,
    bool? hasError,
    bool? enabled,
    bool? isHovered,
    bool? liftOnHover,
    Color? borderColor,
    Color? focusBorderColor,
    double? borderWidth,
    double? focusBorderWidth,
    double? errorBorderWidth,
    List<Color>? customColorsAqua,
    List<Color>? customColorsClassic,
    List<Color>? customGradient,
    List<Color>? loadedGradient,
    String? customKey,
    Color? backgroundColor,
  }) {
    return GlassSurfaceConfig(
      style: style ?? this.style,
      shape: shape ?? this.shape,
      effects: effects ?? this.effects,
      role: role ?? this.role,
      theme: theme ?? this.theme,
      isFocused: isFocused ?? this.isFocused,
      hasError: hasError ?? this.hasError,
      enabled: enabled ?? this.enabled,
      isHovered: isHovered ?? this.isHovered,
      liftOnHover: liftOnHover ?? this.liftOnHover,
      borderColor: borderColor ?? this.borderColor,
      focusBorderColor:
          focusBorderColor ?? this.focusBorderColor,
      borderWidth:
          borderWidth ?? this.borderWidth,
      focusBorderWidth:
          focusBorderWidth ?? this.focusBorderWidth,
      errorBorderWidth:
          errorBorderWidth ?? this.errorBorderWidth,
      customColorsAqua:
          customColorsAqua ?? this.customColorsAqua,
      customColorsClassic:
          customColorsClassic ?? this.customColorsClassic,
      customGradient:
          customGradient ?? this.customGradient,
      loadedGradient:
          loadedGradient ?? this.loadedGradient,
      customKey:
          customKey ?? this.customKey,
      backgroundColor:
          backgroundColor ?? this.backgroundColor,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:universal_glass/theme/glass_color_palette.dart';

/// ============================================================================
/// GLASS INPUT DECORATION
///
/// Configuration visuelle commune aux composants de saisie Glass.
///
/// Utilisé par :
///
/// • UniversalGlassTextBox
/// • UniversalGlassTextField
/// • UniversalGlassPhoneInput
///
/// ---------------------------------------------------------------------------
/// RESPONSABILITÉ
/// ---------------------------------------------------------------------------
///
/// Cette classe décrit uniquement l'apparence d'un Input.
///
/// Elle ne connaît pas :
///
/// • Riverpod
/// • Settings
/// • SharedPreferences
/// • persistance
/// • logique métier
/// • logique de validation
///
/// ---------------------------------------------------------------------------
/// PALETTE
/// ---------------------------------------------------------------------------
///
/// Les couleurs par défaut proviennent de `GlassColorPalette`.
///
/// Une couleur peut toutefois toujours être remplacée directement :
///
///     GlassInputDecoration(
///       textColor: Colors.white,
///     );
///
/// ou construite depuis une palette :
///
///     GlassInputDecoration.fromPalette(
///       palette: GlassColorPalette.aquaPreset(),
///     );
///
/// ============================================================================

class GlassInputDecoration {
  // ==========================================================================
  // COULEURS
  // ==========================================================================

  /// Couleur principale du Glass.
  final Color color;

  /// Couleur utilisée lorsque le champ possède le focus.
  final Color? focusColor;

  /// Couleur utilisée lorsqu'une erreur est présente.
  final Color errorColor;

  /// Couleur du texte principal.
  final Color textColor;

  /// Couleur du texte indicatif.
  final Color hintColor;

  /// Couleur des icônes.
  final Color iconColor;

  // ==========================================================================
  // TYPOGRAPHIE
  // ==========================================================================

  /// Taille du texte.
  final double fontSize;

  /// Épaisseur du texte.
  final FontWeight fontWeight;

  /// Espacement entre les caractères.
  final double letterSpacing;

  // ==========================================================================
  // OPACITÉS
  // ==========================================================================

  /// Opacité normale du fond.
  final double backgroundOpacity;

  /// Opacité du fond lorsque le champ possède le focus.
  final double focusOpacity;

  /// Opacité du fond au survol.
  final double hoverOpacity;

  // ==========================================================================
  // BORDURE
  // ==========================================================================

  /// Épaisseur normale de la bordure.
  final double borderWidth;

  /// Épaisseur de la bordure lorsque le champ possède le focus.
  final double focusBorderWidth;

  /// Épaisseur de la bordure lorsqu'une erreur est présente.
  final double errorBorderWidth;

  /// Rayon des coins.
  final double borderRadius;

  /// Couleur normale de la bordure.
  final Color borderColor;

  /// Couleur de la bordure lorsque le champ possède le focus.
  final Color? focusBorderColor;

  /// Couleur de la bordure en cas d'erreur.
  final Color? errorBorderColor;

  // ==========================================================================
  // GLASS
  // ==========================================================================

  /// Intensité du flou du BackdropFilter.
  final double blur;

  /// Active le reflet supérieur.
  final bool showReflection;

  /// Intensité du reflet supérieur.
  final double reflectionOpacity;

  // ==========================================================================
  // ESPACEMENT
  // ==========================================================================

  /// Padding horizontal interne.
  final double horizontalPadding;

  /// Padding vertical interne.
  final double verticalPadding;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const GlassInputDecoration({
    // ------------------------------------------------------------------------
    // COULEURS
    // ------------------------------------------------------------------------
    this.color = GlassColorPalette.blue,
    this.focusColor,
    this.errorColor = GlassColorPalette.red,
    this.textColor = Colors.white,
    this.hintColor = const Color(0xB3FFFFFF),
    this.iconColor = Colors.white,

    // ------------------------------------------------------------------------
    // TYPOGRAPHIE
    // ------------------------------------------------------------------------
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.w500,
    this.letterSpacing = 0.2,

    // ------------------------------------------------------------------------
    // OPACITÉS
    // ------------------------------------------------------------------------
    this.backgroundOpacity = 0.18,
    this.focusOpacity = 0.28,
    this.hoverOpacity = 0.22,

    // ------------------------------------------------------------------------
    // BORDURE
    // ------------------------------------------------------------------------
    this.borderWidth = 1.2,
    this.focusBorderWidth = 1.6,
    this.errorBorderWidth = 1.6,
    this.borderRadius = 18.0,
    this.borderColor = const Color(0x66FFFFFF),
    this.focusBorderColor,
    this.errorBorderColor,

    // ------------------------------------------------------------------------
    // GLASS
    // ------------------------------------------------------------------------
    this.blur = 5.0,
    this.showReflection = true,
    this.reflectionOpacity = 0.32,

    // ------------------------------------------------------------------------
    // ESPACEMENT
    // ------------------------------------------------------------------------
    this.horizontalPadding = 16.0,
    this.verticalPadding = 12.0,
  });

  // ==========================================================================
  // CONSTRUCTEUR DEPUIS UNE PALETTE
  // ==========================================================================
  //
  // Permet à un composant ou à un preset de construire une décoration
  // cohérente avec GlassColorPalette.
  //
  // Exemple :
  //
  // GlassInputDecoration.fromPalette(
  //   palette: GlassColorPalette.aquaPreset(),
  // );
  //
  // ==========================================================================

  factory GlassInputDecoration.fromPalette({
    required GlassColorPalette palette,
    Color? color,
    Color? focusColor,
    Color? errorColor,
    Color? textColor,
    Color? hintColor,
    Color? iconColor,
    double fontSize = 16.0,
    FontWeight fontWeight = FontWeight.w500,
    double letterSpacing = 0.2,
    double backgroundOpacity = 0.18,
    double focusOpacity = 0.28,
    double hoverOpacity = 0.22,
    double borderWidth = 1.2,
    double focusBorderWidth = 1.6,
    double errorBorderWidth = 1.6,
    double borderRadius = 18.0,
    Color? borderColor,
    Color? focusBorderColor,
    Color? errorBorderColor,
    double blur = 5.0,
    bool showReflection = true,
    double reflectionOpacity = 0.32,
    double horizontalPadding = 16.0,
    double verticalPadding = 12.0,
  }) {
    return GlassInputDecoration(
      color: color ?? palette.aqua,
      focusColor: focusColor ?? palette.aquaLight,
      errorColor: errorColor ?? palette.error,
      textColor: textColor ?? palette.textPrimary,
      hintColor: hintColor ?? palette.textSecondary,
      iconColor: iconColor ?? palette.textPrimary,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      backgroundOpacity: backgroundOpacity,
      focusOpacity: focusOpacity,
      hoverOpacity: hoverOpacity,
      borderWidth: borderWidth,
      focusBorderWidth: focusBorderWidth,
      errorBorderWidth: errorBorderWidth,
      borderRadius: borderRadius,
      borderColor: borderColor ?? palette.border.withValues(alpha: 0.40),
      focusBorderColor: focusBorderColor ?? palette.aquaLight.withValues(alpha: 0.75),
      errorBorderColor: errorBorderColor ?? palette.error,
      blur: blur,
      showReflection: showReflection,
      reflectionOpacity: reflectionOpacity,
      horizontalPadding: horizontalPadding,
      verticalPadding: verticalPadding,
    );
  }

  // ==========================================================================
  // PRESET AQUA
  // ==========================================================================
  //
  // Décoration directement basée sur la palette Aqua.
  //
  // ==========================================================================

  factory GlassInputDecoration.aqua({
    double fontSize = 16.0,
    FontWeight fontWeight = FontWeight.w500,
    double letterSpacing = 0.2,
    double backgroundOpacity = 0.18,
    double focusOpacity = 0.28,
    double hoverOpacity = 0.22,
    double borderWidth = 1.2,
    double focusBorderWidth = 1.6,
    double errorBorderWidth = 1.6,
    double borderRadius = 18.0,
    double blur = 5.0,
    bool showReflection = true,
    double reflectionOpacity = 0.32,
    double horizontalPadding = 16.0,
    double verticalPadding = 12.0,
  }) {
    return GlassInputDecoration.fromPalette(
      palette: GlassColorPalette.aquaPreset(),
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      backgroundOpacity: backgroundOpacity,
      focusOpacity: focusOpacity,
      hoverOpacity: hoverOpacity,
      borderWidth: borderWidth,
      focusBorderWidth: focusBorderWidth,
      errorBorderWidth: errorBorderWidth,
      borderRadius: borderRadius,
      blur: blur,
      showReflection: showReflection,
      reflectionOpacity: reflectionOpacity,
      horizontalPadding: horizontalPadding,
      verticalPadding: verticalPadding,
    );
  }

  // ==========================================================================
  // PRESET CLASSIC
  // ==========================================================================
  //
  // Décoration directement basée sur la palette Classic.
  //
  // ==========================================================================

  factory GlassInputDecoration.classic({
    double fontSize = 16.0,
    FontWeight fontWeight = FontWeight.w500,
    double letterSpacing = 0.2,
    double backgroundOpacity = 0.18,
    double focusOpacity = 0.28,
    double hoverOpacity = 0.22,
    double borderWidth = 1.2,
    double focusBorderWidth = 1.6,
    double errorBorderWidth = 1.6,
    double borderRadius = 18.0,
    double blur = 5.0,
    bool showReflection = true,
    double reflectionOpacity = 0.32,
    double horizontalPadding = 16.0,
    double verticalPadding = 12.0,
  }) {
    return GlassInputDecoration.fromPalette(
      palette: GlassColorPalette.classicPreset(),
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      backgroundOpacity: backgroundOpacity,
      focusOpacity: focusOpacity,
      hoverOpacity: hoverOpacity,
      borderWidth: borderWidth,
      focusBorderWidth: focusBorderWidth,
      errorBorderWidth: errorBorderWidth,
      borderRadius: borderRadius,
      blur: blur,
      showReflection: showReflection,
      reflectionOpacity: reflectionOpacity,
      horizontalPadding: horizontalPadding,
      verticalPadding: verticalPadding,
    );
  }

  // ==========================================================================
  // COPIE
  // ==========================================================================

  GlassInputDecoration copyWith({
    // ------------------------------------------------------------------------
    // COULEURS
    // ------------------------------------------------------------------------
    Color? color,
    Color? focusColor,
    Color? errorColor,
    Color? textColor,
    Color? hintColor,
    Color? iconColor,

    // ------------------------------------------------------------------------
    // TYPOGRAPHIE
    // ------------------------------------------------------------------------
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,

    // ------------------------------------------------------------------------
    // OPACITÉS
    // ------------------------------------------------------------------------
    double? backgroundOpacity,
    double? focusOpacity,
    double? hoverOpacity,

    // ------------------------------------------------------------------------
    // BORDURE
    // ------------------------------------------------------------------------
    double? borderWidth,
    double? focusBorderWidth,
    double? errorBorderWidth,
    double? borderRadius,
    Color? borderColor,
    Color? focusBorderColor,
    Color? errorBorderColor,

    // ------------------------------------------------------------------------
    // GLASS
    // ------------------------------------------------------------------------
    double? blur,
    bool? showReflection,
    double? reflectionOpacity,

    // ------------------------------------------------------------------------
    // ESPACEMENT
    // ------------------------------------------------------------------------
    double? horizontalPadding,
    double? verticalPadding,
  }) {
    return GlassInputDecoration(
      // ======================================================================
      // COULEURS
      // ======================================================================
      color: color ?? this.color,
      focusColor: focusColor ?? this.focusColor,
      errorColor: errorColor ?? this.errorColor,
      textColor: textColor ?? this.textColor,
      hintColor: hintColor ?? this.hintColor,
      iconColor: iconColor ?? this.iconColor,

      // ======================================================================
      // TYPOGRAPHIE
      // ======================================================================
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
      letterSpacing: letterSpacing ?? this.letterSpacing,

      // ======================================================================
      // OPACITÉS
      // ======================================================================
      backgroundOpacity: backgroundOpacity ?? this.backgroundOpacity,
      focusOpacity: focusOpacity ?? this.focusOpacity,
      hoverOpacity: hoverOpacity ?? this.hoverOpacity,

      // ======================================================================
      // BORDURE
      // ======================================================================
      borderWidth: borderWidth ?? this.borderWidth,
      focusBorderWidth: focusBorderWidth ?? this.focusBorderWidth,
      errorBorderWidth: errorBorderWidth ?? this.errorBorderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      borderColor: borderColor ?? this.borderColor,
      focusBorderColor: focusBorderColor ?? this.focusBorderColor,
      errorBorderColor: errorBorderColor ?? this.errorBorderColor,

      // ======================================================================
      // GLASS
      // ======================================================================
      blur: blur ?? this.blur,
      showReflection: showReflection ?? this.showReflection,
      reflectionOpacity: reflectionOpacity ?? this.reflectionOpacity,

      // ======================================================================
      // ESPACEMENT
      // ======================================================================
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      verticalPadding: verticalPadding ?? this.verticalPadding,
    );
  }

  // ==========================================================================
  // COULEUR FOCUS
  // ==========================================================================

  Color get effectiveFocusColor => focusColor ?? color;

  // ==========================================================================
  // BORDURE FOCUS
  // ==========================================================================

  Color get effectiveFocusBorderColor => focusBorderColor ?? effectiveFocusColor.withValues(alpha: 0.75);

  // ==========================================================================
  // BORDURE ERREUR
  // ==========================================================================

  Color get effectiveErrorBorderColor => errorBorderColor ?? errorColor;

  // ==========================================================================
  // TEXTE
  // ==========================================================================

  Color get effectiveTextColor => textColor;

  // ==========================================================================
  // HINT
  // ==========================================================================

  Color get effectiveHintColor => hintColor;

  // ==========================================================================
  // ICÔNE
  // ==========================================================================

  Color get effectiveIconColor => iconColor;

  // ==========================================================================
  // OPACITÉS SÉCURISÉES
  // ==========================================================================

  double get safeBackgroundOpacity => backgroundOpacity.clamp(0.0, 1.0);
  double get safeFocusOpacity => focusOpacity.clamp(0.0, 1.0);
  double get safeHoverOpacity => hoverOpacity.clamp(0.0, 1.0);
  double get safeReflectionOpacity => reflectionOpacity.clamp(0.0, 1.0);

  // ==========================================================================
  // DIMENSIONS SÉCURISÉES
  // ==========================================================================

  double get safeBorderWidth => borderWidth.clamp(0.0, 10.0);
  double get safeFocusBorderWidth => focusBorderWidth.clamp(0.0, 10.0);
  double get safeErrorBorderWidth => errorBorderWidth.clamp(0.0, 10.0);
  double get safeBorderRadius => borderRadius.clamp(0.0, 100.0);
  double get safeBlur => blur.clamp(0.0, 50.0);
  double get safeFontSize => fontSize.clamp(1.0, 100.0);
  double get safeHorizontalPadding => horizontalPadding.clamp(0.0, 100.0);
  double get safeVerticalPadding => verticalPadding.clamp(0.0, 100.0);
}
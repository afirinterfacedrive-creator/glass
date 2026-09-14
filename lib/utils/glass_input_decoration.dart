
import 'package:flutter/material.dart';

import 'package:universal_glass/theme/glass_color_palette.dart';

/// ============================================================================
/// GLASS INPUT DECORATION
/// ============================================================================
///
/// Configuration visuelle de base des composants de saisie Universal Glass.
///
/// Cette classe décrit uniquement l'apparence de base d'un champ.
///
/// Elle ne gère PAS les états :
/// - focus ;
/// - hover ;
/// - erreur ;
/// - succès ;
/// - disabled.
///
/// La résolution des états est assurée par [GlassInputStateStyle].
///
/// RESPONSABILITÉS
///
/// - couleurs de base ;
/// - couleurs de focus et d'erreur ;
/// - couleurs du label flottant ;
/// - typographie ;
/// - opacités ;
/// - bordures ;
/// - paramètres glass ;
/// - espacements ;
/// - valeurs sécurisées.
///
/// ============================================================================
@immutable
class GlassInputDecoration {
  // ==========================================================================
  // COULEURS
  // ==========================================================================

  /// Couleur principale du fond de l'input.
  final Color color;

  /// Couleur du fond lorsque le champ est en focus.
  ///
  /// Si null, [color] est utilisé.
  final Color? focusColor;

  /// Couleur utilisée pour l'état erreur.
  final Color errorColor;

  /// Couleur du texte.
  final Color textColor;

  /// Couleur du hint.
  final Color hintColor;

  /// Couleur des icônes.
  final Color iconColor;

  // ==========================================================================
  // FOND DU LABEL
  // ==========================================================================

  /// Fond normal du label flottant.
  ///
  /// Cette couleur doit idéalement être suffisamment opaque pour masquer
  /// visuellement la bordure située sous le label.
  ///
  /// Si null, [color] est utilisé.
  final Color? labelBackgroundColor;

  /// Fond du label flottant lorsqu'une erreur est présente.
  ///
  /// Si null, [labelBackgroundColor] est utilisé.
  final Color? errorLabelBackgroundColor;

  // ==========================================================================
  // TYPOGRAPHIE
  // ==========================================================================

  final double fontSize;
  final FontWeight fontWeight;
  final double letterSpacing;

  // ==========================================================================
  // OPACITÉS
  // ==========================================================================

  /// Opacité de fond en état normal.
  final double backgroundOpacity;

  /// Opacité de fond en état focus.
  final double focusOpacity;

  /// Opacité de fond en état hover.
  final double hoverOpacity;

  // ==========================================================================
  // BORDURES
  // ==========================================================================

  /// Épaisseur de bordure normale.
  final double borderWidth;

  /// Épaisseur de bordure en focus.
  final double focusBorderWidth;

  /// Épaisseur de bordure en erreur.
  final double errorBorderWidth;

  /// Rayon de la surface.
  final double borderRadius;

  /// Couleur de bordure normale.
  final Color borderColor;

  /// Couleur de bordure en focus.
  ///
  /// Si null, une couleur dérivée de [effectiveFocusColor] est utilisée.
  final Color? focusBorderColor;

  /// Couleur de bordure en erreur.
  ///
  /// Si null, [errorColor] est utilisé.
  final Color? errorBorderColor;

  // ==========================================================================
  // GLASS
  // ==========================================================================

  /// Niveau de blur local historique du champ.
  ///
  /// La surface globale peut également être contrôlée par le thème
  /// Universal Glass.
  final double blur;

  /// Active la réflexion visuelle du champ.
  final bool showReflection;

  /// Opacité de la réflexion.
  final double reflectionOpacity;

  // ==========================================================================
  // ESPACEMENT
  // ==========================================================================

  final double horizontalPadding;
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
    // LABEL
    // ------------------------------------------------------------------------

    this.labelBackgroundColor,
    this.errorLabelBackgroundColor,

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
    // BORDURES
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
  // PALETTE
  // ==========================================================================

  /// Crée une décoration à partir d'une [GlassColorPalette].
  factory GlassInputDecoration.fromPalette({
    required GlassColorPalette palette,
    Color? color,
    Color? focusColor,
    Color? errorColor,
    Color? textColor,
    Color? hintColor,
    Color? iconColor,
    Color? labelBackgroundColor,
    Color? errorLabelBackgroundColor,
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

      // ----------------------------------------------------------------------
      // LABEL
      // ----------------------------------------------------------------------
      //
      // Le fond du label est volontairement suffisamment dense pour
      // masquer proprement la bordure située sous le texte flottant.
      //
      labelBackgroundColor:
          labelBackgroundColor ?? palette.aquaDark,

      errorLabelBackgroundColor:
          errorLabelBackgroundColor ?? palette.aquaDark,

      // ----------------------------------------------------------------------
      // TYPOGRAPHIE
      // ----------------------------------------------------------------------

      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,

      // ----------------------------------------------------------------------
      // OPACITÉS
      // ----------------------------------------------------------------------

      backgroundOpacity: backgroundOpacity,
      focusOpacity: focusOpacity,
      hoverOpacity: hoverOpacity,

      // ----------------------------------------------------------------------
      // BORDURES
      // ----------------------------------------------------------------------

      borderWidth: borderWidth,
      focusBorderWidth: focusBorderWidth,
      errorBorderWidth: errorBorderWidth,
      borderRadius: borderRadius,

      borderColor:
          borderColor ??
          palette.border.withValues(alpha: 0.40),

      focusBorderColor:
          focusBorderColor ??
          palette.aquaLight.withValues(alpha: 0.75),

      errorBorderColor:
          errorBorderColor ?? palette.error,

      // ----------------------------------------------------------------------
      // GLASS
      // ----------------------------------------------------------------------

      blur: blur,
      showReflection: showReflection,
      reflectionOpacity: reflectionOpacity,

      // ----------------------------------------------------------------------
      // ESPACEMENT
      // ----------------------------------------------------------------------

      horizontalPadding: horizontalPadding,
      verticalPadding: verticalPadding,
    );
  }

  // ==========================================================================
  // PRESET AQUA
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
    final GlassColorPalette palette =
        GlassColorPalette.classicPreset();

    return GlassInputDecoration.fromPalette(
      palette: palette,

      color: palette.classic,
      focusColor: palette.classicLight,

      labelBackgroundColor:
          palette.classicDark,

      errorLabelBackgroundColor:
          palette.classicDark,

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
  // COPY WITH
  // ==========================================================================

  GlassInputDecoration copyWith({
    Color? color,
    Color? focusColor,
    Color? errorColor,
    Color? textColor,
    Color? hintColor,
    Color? iconColor,
    Color? labelBackgroundColor,
    Color? errorLabelBackgroundColor,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    double? backgroundOpacity,
    double? focusOpacity,
    double? hoverOpacity,
    double? borderWidth,
    double? focusBorderWidth,
    double? errorBorderWidth,
    double? borderRadius,
    Color? borderColor,
    Color? focusBorderColor,
    Color? errorBorderColor,
    double? blur,
    bool? showReflection,
    double? reflectionOpacity,
    double? horizontalPadding,
    double? verticalPadding,
  }) {
    return GlassInputDecoration(
      color: color ?? this.color,
      focusColor: focusColor ?? this.focusColor,
      errorColor: errorColor ?? this.errorColor,
      textColor: textColor ?? this.textColor,
      hintColor: hintColor ?? this.hintColor,
      iconColor: iconColor ?? this.iconColor,

      labelBackgroundColor:
          labelBackgroundColor ?? this.labelBackgroundColor,

      errorLabelBackgroundColor:
          errorLabelBackgroundColor ??
          this.errorLabelBackgroundColor,

      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
      letterSpacing: letterSpacing ?? this.letterSpacing,

      backgroundOpacity:
          backgroundOpacity ?? this.backgroundOpacity,

      focusOpacity:
          focusOpacity ?? this.focusOpacity,

      hoverOpacity:
          hoverOpacity ?? this.hoverOpacity,

      borderWidth:
          borderWidth ?? this.borderWidth,

      focusBorderWidth:
          focusBorderWidth ?? this.focusBorderWidth,

      errorBorderWidth:
          errorBorderWidth ?? this.errorBorderWidth,

      borderRadius:
          borderRadius ?? this.borderRadius,

      borderColor:
          borderColor ?? this.borderColor,

      focusBorderColor:
          focusBorderColor ?? this.focusBorderColor,

      errorBorderColor:
          errorBorderColor ?? this.errorBorderColor,

      blur:
          blur ?? this.blur,

      showReflection:
          showReflection ?? this.showReflection,

      reflectionOpacity:
          reflectionOpacity ?? this.reflectionOpacity,

      horizontalPadding:
          horizontalPadding ?? this.horizontalPadding,

      verticalPadding:
          verticalPadding ?? this.verticalPadding,
    );
  }

  // ==========================================================================
  // COULEURS EFFECTIVES
  // ==========================================================================

  /// Couleur effective du fond en focus.
  ///
  /// Si aucune couleur spécifique n'est fournie, le fond normal est conservé.
  Color get effectiveFocusColor {
    return focusColor ?? color;
  }

  /// Couleur effective de la bordure en focus.
  ///
  /// Si aucune couleur spécifique n'est fournie, elle est dérivée du fond
  /// de focus avec une opacité de 75 %.
  Color get effectiveFocusBorderColor {
    return focusBorderColor ??
        effectiveFocusColor.withValues(alpha: 0.75);
  }

  /// Couleur effective de la bordure en erreur.
  Color get effectiveErrorBorderColor {
    return errorBorderColor ?? errorColor;
  }

  /// Couleur effective de la bordure normale.
  Color get effectiveBorderColor {
    return borderColor;
  }

  /// Alias de compatibilité pour la bordure normale.
  Color get effectiveDefaultBorderColor {
    return effectiveBorderColor;
  }

  /// Couleur effective du fond du label flottant.
  Color get effectiveLabelBackgroundColor {
    return labelBackgroundColor ?? color;
  }

  /// Couleur effective du fond du label flottant en erreur.
  Color get effectiveErrorLabelBackgroundColor {
    return errorLabelBackgroundColor ??
        effectiveLabelBackgroundColor;
  }

  /// Couleur effective du texte.
  Color get effectiveTextColor {
    return textColor;
  }

  /// Couleur effective du hint.
  Color get effectiveHintColor {
    return hintColor;
  }

  /// Couleur effective des icônes.
  Color get effectiveIconColor {
    return iconColor;
  }

  // ==========================================================================
  // VALEURS SÉCURISÉES
  // ==========================================================================

  /// Opacité de fond normal limitée à [0, 1].
  double get safeBackgroundOpacity {
    return backgroundOpacity.clamp(0.0, 1.0);
  }

  /// Opacité de focus limitée à [0, 1].
  double get safeFocusOpacity {
    return focusOpacity.clamp(0.0, 1.0);
  }

  /// Opacité de hover limitée à [0, 1].
  double get safeHoverOpacity {
    return hoverOpacity.clamp(0.0, 1.0);
  }

  /// Opacité de réflexion limitée à [0, 1].
  double get safeReflectionOpacity {
    return reflectionOpacity.clamp(0.0, 1.0);
  }

  /// Épaisseur de bordure normale.
  double get safeBorderWidth {
    return borderWidth.clamp(0.0, 10.0);
  }

  /// Épaisseur de bordure en focus.
  double get safeFocusBorderWidth {
    return focusBorderWidth.clamp(0.0, 10.0);
  }

  /// Épaisseur de bordure en erreur.
  double get safeErrorBorderWidth {
    return errorBorderWidth.clamp(0.0, 10.0);
  }

  /// Rayon sécurisé.
  double get safeBorderRadius {
    return borderRadius.clamp(0.0, 100.0);
  }

  /// Blur local sécurisé.
  double get safeBlur {
    return blur.clamp(0.0, 50.0);
  }

  /// Taille de texte sécurisée.
  double get safeFontSize {
    return fontSize.clamp(1.0, 100.0);
  }

  /// Padding horizontal sécurisé.
  double get safeHorizontalPadding {
    return horizontalPadding.clamp(0.0, 100.0);
  }

  /// Padding vertical sécurisé.
  double get safeVerticalPadding {
    return verticalPadding.clamp(0.0, 100.0);
  }
}

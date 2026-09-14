
import 'package:flutter/material.dart';

import 'package:universal_glass/utils/glass_input_decoration.dart';

/// ============================================================================
/// GLASS INPUT STATE STYLE
/// ============================================================================
///
/// Résout l'apparence visuelle effective d'un champ selon son état.
///
/// PRIORITÉ DES ÉTATS
///
/// 1. Error
/// 2. Success
/// 3. Focus
/// 4. Hover
/// 5. Normal
/// 6. Disabled
///
/// RESPONSABILITÉS
///
/// - déterminer la couleur de fond ;
/// - déterminer la bordure ;
/// - déterminer les couleurs du texte et du hint ;
/// - déterminer les couleurs des icônes ;
/// - déterminer le fond du label flottant ;
/// - déterminer l'opacité du champ ;
/// - déterminer l'épaisseur de bordure ;
/// - exposer les états effectifs utilisés par les composants.
///
/// IMPORTANT
///
/// Cette classe ne dessine rien.
/// Elle ne dépend pas de Riverpod.
/// Elle ne gère pas directement le glow, le blur ou l'ombre.
///
/// Elle fournit uniquement les paramètres nécessaires aux composants
/// qui réalisent réellement le rendu.
///
@immutable
class GlassInputStateStyle {
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color hintColor;
  final Color iconColor;
  final Color iconColorInBubble;
  final Color labelBackgroundColor;

  final double backgroundOpacity;
  final double borderWidth;

  final bool hasError;
  final bool hasSuccess;
  final bool isFocused;
  final bool isHovered;
  final bool enabled;

  const GlassInputStateStyle({
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.hintColor,
    required this.iconColor,
    required this.iconColorInBubble,
    required this.labelBackgroundColor,
    required this.backgroundOpacity,
    required this.borderWidth,
    required this.hasError,
    required this.hasSuccess,
    required this.isFocused,
    required this.isHovered,
    required this.enabled,
  });

  // ==========================================================================
  // CONTRASTE
  // ==========================================================================

  /// Retourne une couleur de contenu lisible sur [backgroundColor].
  static Color _getContrastColor(Color backgroundColor) {
    final double luminance = backgroundColor.computeLuminance();

    return luminance > 0.5
        ? Colors.black87
        : Colors.white;
  }

  // ==========================================================================
  // RÉSOLUTION DE L'ÉTAT
  // ==========================================================================

  /// Résout le style visuel complet du champ.
  ///
  /// La priorité est volontairement :
  ///
  /// Error
  ///   ↓
  /// Success
  ///   ↓
  /// Focus
  ///   ↓
  /// Hover
  ///   ↓
  /// Normal
  ///   ↓
  /// Disabled
  factory GlassInputStateStyle.resolve({
    required GlassInputDecoration decoration,
    bool hasError = false,
    bool hasSuccess = false,
    bool isFocused = false,
    bool isHovered = false,
    bool enabled = true,
  }) {
    // ========================================================================
    // ERROR
    // ========================================================================

    if (hasError && enabled) {
      final Color bgColor = decoration.color;

      return GlassInputStateStyle(
        backgroundColor: bgColor,
        borderColor: decoration.effectiveErrorBorderColor,
        textColor: decoration.effectiveTextColor,
        hintColor: decoration.effectiveHintColor,
        iconColor: decoration.errorColor,
        iconColorInBubble: _getContrastColor(bgColor),
        labelBackgroundColor:
            decoration.effectiveErrorLabelBackgroundColor,
        backgroundOpacity: decoration.safeBackgroundOpacity,
        borderWidth: decoration.safeErrorBorderWidth,
        hasError: true,
        hasSuccess: false,
        isFocused: isFocused,
        isHovered: isHovered,
        enabled: true,
      );
    }

    // ========================================================================
    // SUCCESS
    // ========================================================================

    if (hasSuccess && enabled) {
      final Color surfaceColor =
          Colors.greenAccent.withValues(alpha: 0.12);

      return GlassInputStateStyle(
        backgroundColor: decoration.color,
        borderColor: Colors.greenAccent,
        textColor: decoration.effectiveTextColor,
        hintColor: decoration.effectiveHintColor,
        iconColor: Colors.greenAccent,
        iconColorInBubble: _getContrastColor(surfaceColor),
        labelBackgroundColor:
            decoration.effectiveLabelBackgroundColor,
        backgroundOpacity: decoration.safeBackgroundOpacity,

        // Le succès reprend volontairement l'épaisseur du focus.
        borderWidth: decoration.safeFocusBorderWidth,

        hasError: false,
        hasSuccess: true,
        isFocused: isFocused,
        isHovered: isHovered,
        enabled: true,
      );
    }

    // ========================================================================
    // FOCUS
    // ========================================================================

    if (isFocused && enabled) {
      final Color surfaceColor =
          decoration.effectiveFocusColor;

      return GlassInputStateStyle(
        backgroundColor: surfaceColor,
        borderColor: decoration.effectiveFocusBorderColor,
        textColor: decoration.effectiveTextColor,
        hintColor: decoration.effectiveHintColor,
        iconColor: decoration.effectiveFocusBorderColor,
        iconColorInBubble: _getContrastColor(surfaceColor),
        labelBackgroundColor:
            decoration.effectiveLabelBackgroundColor,
        backgroundOpacity: decoration.safeFocusOpacity,
        borderWidth: decoration.safeFocusBorderWidth,
        hasError: false,
        hasSuccess: false,
        isFocused: true,
        isHovered: isHovered,
        enabled: true,
      );
    }

    // ========================================================================
    // HOVER
    // ========================================================================

    if (isHovered && enabled) {
      final Color bgColor = decoration.color;

      return GlassInputStateStyle(
        backgroundColor: bgColor,
        borderColor: decoration.borderColor,
        textColor: decoration.effectiveTextColor,
        hintColor: decoration.effectiveHintColor,
        iconColor: decoration.effectiveIconColor,
        iconColorInBubble: _getContrastColor(bgColor),
        labelBackgroundColor:
            decoration.effectiveLabelBackgroundColor,
        backgroundOpacity: decoration.safeHoverOpacity,
        borderWidth: decoration.safeBorderWidth,
        hasError: false,
        hasSuccess: false,
        isFocused: false,
        isHovered: true,
        enabled: true,
      );
    }

    // ========================================================================
    // NORMAL
    // ========================================================================

    if (enabled) {
      final Color bgColor = decoration.color;

      return GlassInputStateStyle(
        backgroundColor: bgColor,
        borderColor: decoration.borderColor,
        textColor: decoration.effectiveTextColor,
        hintColor: decoration.effectiveHintColor,
        iconColor: decoration.effectiveIconColor,
        iconColorInBubble: _getContrastColor(bgColor),
        labelBackgroundColor:
            decoration.effectiveLabelBackgroundColor,
        backgroundOpacity: decoration.safeBackgroundOpacity,
        borderWidth: decoration.safeBorderWidth,
        hasError: false,
        hasSuccess: false,
        isFocused: false,
        isHovered: false,
        enabled: true,
      );
    }

    // ========================================================================
    // DISABLED
    // ========================================================================

    final Color bgColor = decoration.color;

    return GlassInputStateStyle(
      backgroundColor: bgColor,
      borderColor: decoration.borderColor.withValues(
        alpha: 0.35,
      ),
      textColor: decoration.textColor.withValues(
        alpha: 0.35,
      ),
      hintColor: decoration.hintColor.withValues(
        alpha: 0.35,
      ),
      iconColor: decoration.iconColor.withValues(
        alpha: 0.35,
      ),
      iconColorInBubble: _getContrastColor(bgColor).withValues(
        alpha: 0.5,
      ),
      labelBackgroundColor:
          decoration.effectiveLabelBackgroundColor,
      backgroundOpacity: decoration.safeBackgroundOpacity,
      borderWidth: decoration.safeBorderWidth,
      hasError: false,
      hasSuccess: false,
      isFocused: false,
      isHovered: false,
      enabled: false,
    );
  }

  // ==========================================================================
  // ÉTATS EFFECTIFS
  // ==========================================================================

  /// Indique si l'état erreur doit réellement être affiché.
  bool get showError {
    return hasError && enabled;
  }

  /// Indique si l'état succès doit réellement être affiché.
  ///
  /// Une erreur reste prioritaire sur le succès.
  bool get showSuccess {
    return hasSuccess && enabled && !hasError;
  }

  /// Indique si le focus doit réellement être affiché.
  ///
  /// Le focus est masqué lorsqu'un état erreur ou succès est présent.
  bool get showFocus {
    return isFocused &&
        enabled &&
        !hasError &&
        !hasSuccess;
  }

  /// Indique si le hover doit réellement être affiché.
  ///
  /// Le hover est masqué pendant le focus, le succès et l'erreur.
  bool get showHover {
    return isHovered &&
        enabled &&
        !hasError &&
        !hasSuccess &&
        !isFocused;
  }

  // ==========================================================================
  // LABEL
  // ==========================================================================

  /// Couleur effective du label flottant.
  ///
  /// Priorité :
  ///
  /// Error
  /// Success
  /// Focus
  /// Normal
  Color get effectiveLabelColor {
    if (showError) {
      return borderColor;
    }

    if (showSuccess) {
      return borderColor;
    }

    if (showFocus) {
      return borderColor;
    }

    return textColor.withValues(alpha: 0.60);
  }

  // ==========================================================================
  // BORDURE
  // ==========================================================================

  /// Indique si une bordure correspondant à un état particulier est active.
  bool get hasStateBorder {
    return showError ||
        showSuccess ||
        showFocus ||
        showHover;
  }

  // ==========================================================================
  // ACTIVATION VISUELLE
  // ==========================================================================

  /// Indique si le champ doit être considéré comme visuellement actif.
  ///
  /// IMPORTANT :
  ///
  /// Le succès n'est volontairement PAS considéré comme un état actif.
  ///
  /// Cela évite notamment de déclencher :
  /// - l'ombre active ;
  /// - les animations d'élévation ;
  /// - certains effets hover/focus ;
  /// - des traitements visuels réservés aux états interactifs.
  bool get isActive {
    return enabled &&
        (hasError || isFocused || isHovered);
  }

  // ==========================================================================
  // GLOW
  // ==========================================================================

  /// Indique si le glow doit être affiché.
  ///
  /// Le glow est réservé à :
  ///
  /// - l'erreur ;
  /// - le focus.
  ///
  /// Le succès ne déclenche JAMAIS le glow.
  bool get shouldShowGlow {
    return enabled &&
        (hasError || isFocused);
  }

  // ==========================================================================
  // ÉGALITÉ
  // ==========================================================================

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is GlassInputStateStyle &&
        other.backgroundColor == backgroundColor &&
        other.borderColor == borderColor &&
        other.textColor == textColor &&
        other.hintColor == hintColor &&
        other.iconColor == iconColor &&
        other.iconColorInBubble == iconColorInBubble &&
        other.labelBackgroundColor == labelBackgroundColor &&
        other.backgroundOpacity == backgroundOpacity &&
        other.borderWidth == borderWidth &&
        other.hasError == hasError &&
        other.hasSuccess == hasSuccess &&
        other.isFocused == isFocused &&
        other.isHovered == isHovered &&
        other.enabled == enabled;
  }

  @override
  int get hashCode {
    return Object.hash(
      backgroundColor,
      borderColor,
      textColor,
      hintColor,
      iconColor,
      iconColorInBubble,
      labelBackgroundColor,
      backgroundOpacity,
      borderWidth,
      hasError,
      hasSuccess,
      isFocused,
      isHovered,
      enabled,
    );
  }
}

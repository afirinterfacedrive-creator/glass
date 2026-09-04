import 'package:flutter/material.dart';

/// ============================================================================
/// GLASS COLOR THEME
/// ============================================================================
///
/// Palette complète utilisée par l'interface Glass.
///
/// Cette classe ne contient aucune logique Riverpod.
/// Elle représente uniquement une palette de couleurs.
///
/// Une palette peut être :
///
/// • Aqua
/// • Classic
/// • personnalisée
///
/// Toutes les couleurs des composants Glass doivent idéalement partir d'ici.
///
/// ============================================================================

@immutable
class GlassColorTheme {
  // ==========================================================================
  // IDENTITE
  // ==========================================================================

  final String name;

  // ==========================================================================
  // COULEUR PRINCIPALE
  // ==========================================================================

  /// Couleur d'accent principale.
  final Color accent;

  /// Variante plus lumineuse de l'accent.
  final Color accentBright;

  /// Variante plus sombre de l'accent.
  final Color accentDark;

  // ==========================================================================
  // TEXTE
  // ==========================================================================

  final Color textPrimary;

  final Color textSecondary;

  final Color textMuted;

  final Color textDisabled;

  // ==========================================================================
  // GLASS
  // ==========================================================================

  /// Couche claire principale du verre.
  final Color glassLight;

  /// Couche sombre du verre.
  final Color glassDark;

  /// Couleur de bordure normale.
  final Color glassBorder;

  /// Couleur de bordure active.
  final Color glassBorderActive;

  /// Couleur de bordure au survol.
  final Color glassBorderHover;

  // ==========================================================================
  // INPUT
  // ==========================================================================

  final Color inputBackground;

  final Color inputBackgroundFocus;

  final Color inputBorder;

  final Color inputBorderFocus;

  final Color inputHint;

  final Color inputIcon;

  // ==========================================================================
  // CARD
  // ==========================================================================

  final Color cardBackground;

  final Color cardBackgroundSecondary;

  final Color cardBorder;

  // ==========================================================================
  // ETATS
  // ==========================================================================

  final Color success;

  final Color warning;

  final Color error;

  final Color info;

  // ==========================================================================
  // OMBRES
  // ==========================================================================

  final Color shadow;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const GlassColorTheme({
    required this.name,

    required this.accent,
    required this.accentBright,
    required this.accentDark,

    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textDisabled,

    required this.glassLight,
    required this.glassDark,
    required this.glassBorder,
    required this.glassBorderActive,
    required this.glassBorderHover,

    required this.inputBackground,
    required this.inputBackgroundFocus,
    required this.inputBorder,
    required this.inputBorderFocus,
    required this.inputHint,
    required this.inputIcon,

    required this.cardBackground,
    required this.cardBackgroundSecondary,
    required this.cardBorder,

    required this.success,
    required this.warning,
    required this.error,
    required this.info,

    required this.shadow,
  });

  // ==========================================================================
  // COPY WITH
  // ==========================================================================

  GlassColorTheme copyWith({
    String? name,

    Color? accent,
    Color? accentBright,
    Color? accentDark,

    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? textDisabled,

    Color? glassLight,
    Color? glassDark,
    Color? glassBorder,
    Color? glassBorderActive,
    Color? glassBorderHover,

    Color? inputBackground,
    Color? inputBackgroundFocus,
    Color? inputBorder,
    Color? inputBorderFocus,
    Color? inputHint,
    Color? inputIcon,

    Color? cardBackground,
    Color? cardBackgroundSecondary,
    Color? cardBorder,

    Color? success,
    Color? warning,
    Color? error,
    Color? info,

    Color? shadow,
  }) {
    return GlassColorTheme(
      name: name ?? this.name,

      accent: accent ?? this.accent,
      accentBright: accentBright ?? this.accentBright,
      accentDark: accentDark ?? this.accentDark,

      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      textDisabled: textDisabled ?? this.textDisabled,

      glassLight: glassLight ?? this.glassLight,
      glassDark: glassDark ?? this.glassDark,
      glassBorder: glassBorder ?? this.glassBorder,
      glassBorderActive:
          glassBorderActive ?? this.glassBorderActive,
      glassBorderHover:
          glassBorderHover ?? this.glassBorderHover,

      inputBackground:
          inputBackground ?? this.inputBackground,
      inputBackgroundFocus:
          inputBackgroundFocus ?? this.inputBackgroundFocus,
      inputBorder:
          inputBorder ?? this.inputBorder,
      inputBorderFocus:
          inputBorderFocus ?? this.inputBorderFocus,
      inputHint:
          inputHint ?? this.inputHint,
      inputIcon:
          inputIcon ?? this.inputIcon,

      cardBackground:
          cardBackground ?? this.cardBackground,
      cardBackgroundSecondary:
          cardBackgroundSecondary ??
              this.cardBackgroundSecondary,
      cardBorder:
          cardBorder ?? this.cardBorder,

      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      info: info ?? this.info,

      shadow: shadow ?? this.shadow,
    );
  }
}
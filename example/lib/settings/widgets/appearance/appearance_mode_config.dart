
import 'package:flutter/material.dart';

import 'package:universal_glass/glass.dart';

/// ============================================================================
/// APPEARANCE MODE CONFIG
/// ============================================================================
///
/// Configuration descriptive de chaque mode d'apparence.
///
/// Cette classe ne contient :
/// - aucune logique Riverpod
/// - aucune sauvegarde
/// - aucun état mutable
///
/// Elle décrit uniquement les caractéristiques visuelles d'un mode.
///
/// Flux :
///
/// AppThemeMode
///      ↓
/// AppearanceModeConfig
///      ↓
/// AppearanceSettings
///      ↓
/// AppearanceSection
///
/// ============================================================================
@immutable
class AppearanceModeConfig {
  // ==========================================================================
  // IDENTITÉ
  // ==========================================================================

  final AppThemeMode mode;

  final String label;

  final IconData icon;

  // ==========================================================================
  // STYLE GLASS
  // ==========================================================================

  final GlassStyle glassStyle;

  // ==========================================================================
  // FOND PAR DÉFAUT
  // ==========================================================================

  final List<Color> defaultBackground;

  // ==========================================================================
  // CAPACITÉS DU MODE
  // ==========================================================================

  /// Le mode peut-il utiliser un gradient ?
  final bool supportsGradient;

  /// Le mode peut-il utiliser le blur ?
  final bool supportsBlur;

  /// Le mode peut-il utiliser le noise ?
  final bool supportsNoise;

  // ==========================================================================
  // VALEURS PAR DÉFAUT
  // ==========================================================================

  final double defaultBlur;

  final double defaultNoise;

  final double defaultOpacity;

  final double defaultBorderOpacity;

  final double defaultGlowOpacity;

  final bool enableHover;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const AppearanceModeConfig({
    required this.mode,
    required this.label,
    required this.icon,
    required this.glassStyle,
    required this.defaultBackground,
    required this.supportsGradient,
    required this.supportsBlur,
    required this.supportsNoise,
    required this.defaultBlur,
    required this.defaultNoise,
    required this.defaultOpacity,
    required this.defaultBorderOpacity,
    required this.defaultGlowOpacity,
    required this.enableHover,
  });

  // ==========================================================================
  // UTILITAIRES
  // ==========================================================================

  /// Indique si le mode est Aqua.
  bool get isAqua => mode == AppThemeMode.aqua;

  /// Indique si le mode est Classic.
  bool get isClassic => mode == AppThemeMode.classic;

  /// Indique si le mode utilise une apparence sombre.
  bool get isDark {
    switch (mode) {
      case AppThemeMode.dark:
      case AppThemeMode.classic:
        return true;

      case AppThemeMode.system:
      case AppThemeMode.light:
      case AppThemeMode.aqua:
        return false;
    }
  }

  /// Indique si le mode peut afficher des contrôles de gradient.
  bool get canEditGradient => supportsGradient;

  /// Indique si les contrôles blur doivent être affichés.
  bool get canEditBlur => supportsBlur;

  /// Indique si les contrôles noise doivent être affichés.
  bool get canEditNoise => supportsNoise;

  // ==========================================================================
  // FACTORY PRINCIPALE
  // ==========================================================================

  static AppearanceModeConfig fromMode(
    AppThemeMode mode,
  ) {
    switch (mode) {
      // ======================================================================
      // SYSTEM
      // ======================================================================

      case AppThemeMode.system:
        return const AppearanceModeConfig(
          mode: AppThemeMode.system,
          label: 'Système',
          icon: Icons.brightness_auto,
          glassStyle: GlassStyle.transparentAqua,
          defaultBackground: [
            Color(0xFF121212),
            Color(0xFF1A1A1A),
          ],
          supportsGradient: true,
          supportsBlur: true,
          supportsNoise: true,
          defaultBlur: 12.0,
          defaultNoise: 0.03,
          defaultOpacity: 0.08,
          defaultBorderOpacity: 0.18,
          defaultGlowOpacity: 0.14,
          enableHover: true,
        );

      // ======================================================================
      // DARK
      // ======================================================================

      case AppThemeMode.dark:
        return const AppearanceModeConfig(
          mode: AppThemeMode.dark,
          label: 'Sombre',
          icon: Icons.dark_mode,
          glassStyle: GlassStyle.opaqueMat,
          defaultBackground: [
            Color(0xFF121212),
            Color(0xFF1A1A1A),
          ],
          supportsGradient: true,
          supportsBlur: true,
          supportsNoise: true,
          defaultBlur: 12.0,
          defaultNoise: 0.03,
          defaultOpacity: 0.95,
          defaultBorderOpacity: 0.28,
          defaultGlowOpacity: 0.22,
          enableHover: true,
        );

      // ======================================================================
      // LIGHT
      // ======================================================================

      case AppThemeMode.light:
        return const AppearanceModeConfig(
          mode: AppThemeMode.light,
          label: 'Clair',
          icon: Icons.light_mode,
          glassStyle: GlassStyle.transparentAqua,
          defaultBackground: [
            Color(0xFFF5F5F5),
            Color(0xFFE0E0E0),
          ],
          supportsGradient: true,
          supportsBlur: true,
          supportsNoise: true,
          defaultBlur: 12.0,
          defaultNoise: 0.02,
          defaultOpacity: 0.15,
          defaultBorderOpacity: 0.18,
          defaultGlowOpacity: 0.10,
          enableHover: true,
        );

      // ======================================================================
      // AQUA
      // ======================================================================

      case AppThemeMode.aqua:
        return const AppearanceModeConfig(
          mode: AppThemeMode.aqua,
          label: 'Aqua',
          icon: Icons.water_drop,
          glassStyle: GlassStyle.customGradient,
          defaultBackground: [
            Color(0xFF4DD0E1),
            Color(0xFF00BCD4),
          ],
          supportsGradient: true,
          supportsBlur: true,
          supportsNoise: true,
          defaultBlur: 12.0,
          defaultNoise: 0.04,
          defaultOpacity: 0.08,
          defaultBorderOpacity: 0.18,
          defaultGlowOpacity: 0.14,
          enableHover: true,
        );

      // ======================================================================
      // CLASSIC
      // ======================================================================

      case AppThemeMode.classic:
        return const AppearanceModeConfig(
          mode: AppThemeMode.classic,
          label: 'Classic',
          icon: Icons.dark_mode,
          glassStyle: GlassStyle.opaqueMat,
          defaultBackground: [
            Color(0xFF121212),
            Color(0xFF1A1A1A),
          ],
          supportsGradient: true,
          supportsBlur: true,
          supportsNoise: true,
          defaultBlur: 12.0,
          defaultNoise: 0.03,
          defaultOpacity: 0.95,
          defaultBorderOpacity: 0.28,
          defaultGlowOpacity: 0.22,
          enableHover: true,
        );
    }
  }

  // ==========================================================================
  // MODES UTILISÉS PAR L'INTERFACE APPEARANCE
  // ==========================================================================

  /// Liste officielle des modes proposés dans l'interface Appearance.
  ///
  /// L'interface utilisateur expose uniquement les deux styles principaux :
  /// Aqua et Classic.
  static List<AppearanceModeConfig> get selectableModes => [
        fromMode(AppThemeMode.aqua),
        fromMode(AppThemeMode.classic),
      ];

  // ==========================================================================
  // TOUS LES MODES
  // ==========================================================================

  /// Tous les modes actuellement disponibles dans AppThemeMode.
  ///
  /// Utile pour les tests, le debug ou les futures interfaces.
  static List<AppearanceModeConfig> get allModes => [
        fromMode(AppThemeMode.system),
        fromMode(AppThemeMode.light),
        fromMode(AppThemeMode.dark),
        fromMode(AppThemeMode.aqua),
        fromMode(AppThemeMode.classic),
      ];

  // ==========================================================================
  // ALIAS
  // ==========================================================================

  /// Alias pratique pour obtenir toutes les configurations.
  static List<AppearanceModeConfig> get all => allModes;
}


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

  /// Indique si ce mode appartient à la famille SAGE.
  bool get isSage {
    switch (mode) {
      case AppThemeMode.sage:
      case AppThemeMode.sagePro:
      case AppThemeMode.sageOled:
      case AppThemeMode.sageGlass:
        return true;

      case AppThemeMode.system:
      case AppThemeMode.dark:
      case AppThemeMode.light:
      case AppThemeMode.aqua:
      case AppThemeMode.classic:
        return false;
    }
  }

  /// Indique si le mode est Aqua.
  bool get isAqua => mode == AppThemeMode.aqua;

  /// Indique si le mode est Classic.
  bool get isClassic => mode == AppThemeMode.classic;

  /// Indique si le mode utilise une apparence sombre.
  bool get isDark {
    switch (mode) {
      case AppThemeMode.dark:
      case AppThemeMode.classic:
      case AppThemeMode.sage:
      case AppThemeMode.sagePro:
      case AppThemeMode.sageOled:
      case AppThemeMode.sageGlass:
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

      // ======================================================================
      // SAGE
      // ======================================================================

      case AppThemeMode.sage:
        return const AppearanceModeConfig(
          mode: AppThemeMode.sage,
          label: 'Sage',
          icon: Icons.local_florist,
          glassStyle: GlassStyle.sage,
          defaultBackground: [
            Color(0xFF121212),
            Color(0xFF1E1E1E),
          ],
          supportsGradient: false,
          supportsBlur: false,
          supportsNoise: false,
          defaultBlur: 0.0,
          defaultNoise: 0.0,
          defaultOpacity: 0.20,
          defaultBorderOpacity: 0.35,
          defaultGlowOpacity: 0.35,
          enableHover: false,
        );

      // ======================================================================
      // SAGE PRO
      // ======================================================================

      case AppThemeMode.sagePro:
        return const AppearanceModeConfig(
          mode: AppThemeMode.sagePro,
          label: 'Sage Pro',
          icon: Icons.workspace_premium,
          glassStyle: GlassStyle.sagePro,
          defaultBackground: [
            Color(0xFF0A0A0A),
            Color(0xFF151515),
          ],
          supportsGradient: false,
          supportsBlur: false,
          supportsNoise: false,
          defaultBlur: 0.0,
          defaultNoise: 0.0,
          defaultOpacity: 0.30,
          defaultBorderOpacity: 0.40,
          defaultGlowOpacity: 0.40,
          enableHover: false,
        );

      // ======================================================================
      // SAGE OLED
      // ======================================================================

      case AppThemeMode.sageOled:
        return const AppearanceModeConfig(
          mode: AppThemeMode.sageOled,
          label: 'Sage OLED',
          icon: Icons.brightness_1,
          glassStyle: GlassStyle.sageOled,
          defaultBackground: [
            Colors.black,
            Colors.black,
          ],
          supportsGradient: false,
          supportsBlur: false,
          supportsNoise: false,
          defaultBlur: 0.0,
          defaultNoise: 0.0,
          defaultOpacity: 1.0,
          defaultBorderOpacity: 0.45,
          defaultGlowOpacity: 0.45,
          enableHover: false,
        );

      // ======================================================================
      // SAGE GLASS
      // ======================================================================

      case AppThemeMode.sageGlass:
        return const AppearanceModeConfig(
          mode: AppThemeMode.sageGlass,
          label: 'Sage Glass',
          icon: Icons.blur_on,
          glassStyle: GlassStyle.sageGlass,
          defaultBackground: [
            Color(0xFF0F0F0F),
            Color(0xFF1A1A1A),
          ],
          supportsGradient: false,
          supportsBlur: false,
          supportsNoise: false,
          defaultBlur: 0.0,
          defaultNoise: 0.0,
          defaultOpacity: 0.15,
          defaultBorderOpacity: 0.35,
          defaultGlowOpacity: 0.35,
          enableHover: false,
        );
    }
  }

  // ==========================================================================
  // LISTE DES MODES UTILISÉS PAR L'INTERFACE
  // ==========================================================================

  static List<AppearanceModeConfig> get all => const [
        // Les objets sont générés par fromMode.
      ];

  /// Liste dynamique officielle des modes disponibles.
  ///
  /// Cette liste est volontairement limitée aux modes proposés
  /// dans AppearanceSection.
  static List<AppearanceModeConfig> get selectableModes => [
        fromMode(AppThemeMode.aqua),
        fromMode(AppThemeMode.classic),
        fromMode(AppThemeMode.sage),
        fromMode(AppThemeMode.sagePro),
        fromMode(AppThemeMode.sageOled),
        fromMode(AppThemeMode.sageGlass),
      ];

  /// Tous les modes de AppThemeMode.
  ///
  /// Utile pour les tests, debug ou futures interfaces.
  static List<AppearanceModeConfig> get allModes => [
        fromMode(AppThemeMode.system),
        fromMode(AppThemeMode.light),
        fromMode(AppThemeMode.dark),
        fromMode(AppThemeMode.aqua),
        fromMode(AppThemeMode.classic),
        fromMode(AppThemeMode.sage),
        fromMode(AppThemeMode.sagePro),
        fromMode(AppThemeMode.sageOled),
        fromMode(AppThemeMode.sageGlass),
      ];
}


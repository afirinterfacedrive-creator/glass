
import 'package:flutter/material.dart';
import 'package:universal_glass/enums/glass_enums.dart';

/// ============================================================================
/// GLASS COLOR PALETTE
/// Palette centrale IMMUTABLE du système Universal Glass
/// ============================================================================

class GlassColorPalette {
  // ==========================================================================
  // IDENTITÉ
  // ==========================================================================

  final Color aqua;
  final Color aquaLight;
  final Color aquaDark;

  final Color classic;
  final Color classicLight;
  final Color classicDark;

  // ==========================================================================
  // SURFACES & NEUTRES
  // ==========================================================================

  final Color surface;
  final Color surfaceSecondary;

  final Color white;
  final Color black;

  // ==========================================================================
  // TEXTE
  // ==========================================================================

  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textDisabled;

  // ==========================================================================
  // BORDURES & ÉTATS
  // ==========================================================================

  final Color border;

  final Color success;
  final Color warning;
  final Color error;
  final Color info;

  // ==========================================================================
  // ACCENT DYNAMIQUE
  // ==========================================================================

  final Color accent;

  /// Accent principal utilisé par les renderers pour le glow,
  /// les bordures et autres effets par défaut.
  Color get primary => accent;

  // ==========================================================================
  // UTILITAIRES
  // ==========================================================================

  static const Color blue = Color(0xFF2196F3);
  static const Color red = Color(0xFFF44336);
  static const Color green = Color(0xFF4CAF50);

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const GlassColorPalette({
    required this.aqua,
    required this.aquaLight,
    required this.aquaDark,
    required this.classic,
    required this.classicLight,
    required this.classicDark,
    required this.surface,
    required this.surfaceSecondary,
    required this.white,
    required this.black,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textDisabled,
    required this.border,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.accent,
  });

  // ==========================================================================
  // CONSTANTES
  // ==========================================================================

  static const _aqua = Color(0xFF4DD0E1);
  static const _aquaL = Color(0xFF80DEEA);
  static const _aquaD = Color(0xFF0097A7);

  static const _classic = Color(0xFFFFA726);
  static const _classicL = Color(0xFFFFCC80);
  static const _classicD = Color(0xFFEF6C00);

  static const _success = Color(0xFF69F0AE);
  static const _warning = Color(0xFFFFD740);
  static const _error = Color(0xFFFF5252);
  static const _info = Color(0xFF40C4FF);

  static const _textS = Color(0xB3FFFFFF);
  static const _textT = Color(0x80FFFFFF);
  static const _textD = Color(0x4DFFFFFF);

  static const _textSBlack = Color(0xB3000000);
  static const _textTBlack = Color(0x80000000);
  static const _textDBlack = Color(0x4D000000);

  // ==========================================================================
  // PRESET PAR DÉFAUT
  // ==========================================================================

  factory GlassColorPalette.defaults() {
    return GlassColorPalette.aquaPreset();
  }

  // ==========================================================================
  // PRESET AQUA
  // ==========================================================================

  factory GlassColorPalette.aquaPreset() {
    return GlassColorPalette(
      aqua: _aqua,
      aquaLight: _aquaL,
      aquaDark: _aquaD,

      classic: _classic,
      classicLight: _classicL,
      classicDark: _classicD,

      surface: const Color(0xFF172027),
      surfaceSecondary: const Color(0xFF10161C),

      white: Colors.white,
      black: Colors.black,

      textPrimary: Colors.white,
      textSecondary: _textS,
      textTertiary: _textT,
      textDisabled: _textD,

      border: Colors.white.withValues(alpha: 0.18),

      success: _success,
      warning: _warning,
      error: _error,
      info: _info,

      accent: _aqua,
    );
  }

  // ==========================================================================
  // PRESET CLASSIC
  // ==========================================================================

  factory GlassColorPalette.classicPreset() {
    return GlassColorPalette(
      aqua: _aqua,
      aquaLight: _aquaL,
      aquaDark: _aquaD,

      classic: _classic,
      classicLight: _classicL,
      classicDark: _classicD,

      surface: const Color(0xFF1A1A1A),
      surfaceSecondary: const Color(0xFF101010),

      white: Colors.white,
      black: Colors.black,

      textPrimary: Colors.white,
      textSecondary: _textS,
      textTertiary: _textT,
      textDisabled: _textD,

      border: Colors.white.withValues(alpha: 0.18),

      success: _success,
      warning: _warning,
      error: _error,
      info: _info,

      accent: _classic,
    );
  }

  // ==========================================================================
  // PRESET LIGHT
  // ==========================================================================

  factory GlassColorPalette.lightPreset() {
    return GlassColorPalette(
      aqua: _aqua,
      aquaLight: _aquaL,
      aquaDark: _aquaD,

      classic: _classic,
      classicLight: _classicL,
      classicDark: _classicD,

      surface: const Color(0xFFF5F5F5),
      surfaceSecondary: const Color(0xFFE8E8E8),

      white: Colors.white,
      black: Colors.black,

      textPrimary: const Color(0xFF121212),
      textSecondary: _textSBlack,
      textTertiary: _textTBlack,
      textDisabled: _textDBlack,

      border: Colors.black.withValues(alpha: 0.12),

      success: _success,
      warning: _warning,
      error: _error,
      info: _info,

      accent: _aqua,
    );
  }

  // ==========================================================================
  // PRESET DARK
  // ==========================================================================

  factory GlassColorPalette.darkPreset() {
    return GlassColorPalette(
      aqua: _aqua,
      aquaLight: _aquaL,
      aquaDark: _aquaD,

      classic: _classic,
      classicLight: _classicL,
      classicDark: _classicD,

      surface: const Color(0xFF121212),
      surfaceSecondary: const Color(0xFF1E1E1E),

      white: Colors.white,
      black: Colors.black,

      textPrimary: Colors.white,
      textSecondary: _textS,
      textTertiary: _textT,
      textDisabled: _textD,

      border: Colors.white.withValues(alpha: 0.18),

      success: _success,
      warning: _warning,
      error: _error,
      info: _info,

      accent: _classic,
    );
  }

  // ==========================================================================
  // COPY WITH
  // ==========================================================================

  GlassColorPalette copyWith({
    Color? aqua,
    Color? aquaLight,
    Color? aquaDark,

    Color? classic,
    Color? classicLight,
    Color? classicDark,

    Color? surface,
    Color? surfaceSecondary,

    Color? white,
    Color? black,

    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textDisabled,

    Color? border,

    Color? success,
    Color? warning,
    Color? error,
    Color? info,

    Color? accent,
  }) {
    return GlassColorPalette(
      aqua: aqua ?? this.aqua,
      aquaLight: aquaLight ?? this.aquaLight,
      aquaDark: aquaDark ?? this.aquaDark,

      classic: classic ?? this.classic,
      classicLight: classicLight ?? this.classicLight,
      classicDark: classicDark ?? this.classicDark,

      surface: surface ?? this.surface,
      surfaceSecondary: surfaceSecondary ?? this.surfaceSecondary,

      white: white ?? this.white,
      black: black ?? this.black,

      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textDisabled: textDisabled ?? this.textDisabled,

      border: border ?? this.border,

      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      info: info ?? this.info,

      accent: accent ?? this.accent,
    );
  }

  // ==========================================================================
  // UTILITAIRES DE STYLE
  // ==========================================================================

  Color primaryForStyle(bool useAqua) {
    return useAqua ? aqua : classic;
  }

  Color lightForStyle(bool useAqua) {
    return useAqua ? aquaLight : classicLight;
  }

  Color darkForStyle(bool useAqua) {
    return useAqua ? aquaDark : classicDark;
  }

  // ==========================================================================
  // COULEUR PRINCIPALE SELON LE MODE
  // ==========================================================================

  Color primaryForMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.aqua:
        return aqua;

      case AppThemeMode.classic:
        return classic;

      case AppThemeMode.dark:
        return classic;

      case AppThemeMode.light:
        return aqua;

      case AppThemeMode.system:
        return aqua;
    }
  }

  // ==========================================================================
  // COULEUR CLAIRE SELON LE MODE
  // ==========================================================================

  Color lightForMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.aqua:
        return aquaLight;

      case AppThemeMode.classic:
        return classicLight;

      case AppThemeMode.dark:
        return classicLight;

      case AppThemeMode.light:
        return aquaLight;

      case AppThemeMode.system:
        return aquaLight;
    }
  }

  // ==========================================================================
  // COULEUR SOMBRE SELON LE MODE
  // ==========================================================================

  Color darkForMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.aqua:
        return aquaDark;

      case AppThemeMode.classic:
        return classicDark;

      case AppThemeMode.dark:
        return classicDark;

      case AppThemeMode.light:
        return aquaDark;

      case AppThemeMode.system:
        return aquaDark;
    }
  }

  // ==========================================================================
  // PRESET COMPLET SELON LE MODE
  // ==========================================================================

  static GlassColorPalette fromMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.aqua:
        return GlassColorPalette.aquaPreset();

      case AppThemeMode.classic:
        return GlassColorPalette.classicPreset();

      case AppThemeMode.dark:
        return GlassColorPalette.darkPreset();

      case AppThemeMode.light:
        return GlassColorPalette.lightPreset();

      case AppThemeMode.system:
        return GlassColorPalette.aquaPreset();
    }
  }

  // ==========================================================================
  // GRADIENT SELON LE MODE
  // ==========================================================================

  List<Color> gradientForMode(AppThemeMode mode) {
    final Color primary = primaryForMode(mode);
    final Color dark = darkForMode(mode);

    return [
      primary,
      dark,
    ];
  }

  // ==========================================================================
  // DÉTECTION DU MODE SOMBRE
  // ==========================================================================

  bool get isDarkMode {
    return surface.computeLuminance() < 0.5;
  }
}

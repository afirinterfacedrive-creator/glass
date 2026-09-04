
import 'package:flutter/material.dart';
import 'package:universal_glass/enums/glass_enums.dart';

/// ============================================================================
/// GLASS COLOR PALETTE
/// Palette centrale IMMUTABLE du système Universal Glass
/// ============================================================================
class GlassColorPalette {
  // IDENTITÉ
  final Color aqua, aquaLight, aquaDark;
  final Color classic, classicLight, classicDark;
  final Color sage, sageLight, sageDark; // <-- KDTV Rouge
  
  // SURFACES & NEUTRES
  final Color surface, surfaceSecondary;
  final Color white, black;
  
  // TEXTE
  final Color textPrimary, textSecondary, textTertiary, textDisabled;
  
  // BORDURES & ÉTATS
  final Color border;
  final Color success, warning, error, info;

  // ACCENT DYNAMIQUE
  final Color accent;

  // UTILITAIRES
  static const Color blue = Color(0xFF2196F3);
  static const Color red = Color(0xFFF44336);
  static const Color green = Color(0xFF4CAF50);

  const GlassColorPalette({
    required this.aqua, required this.aquaLight, required this.aquaDark,
    required this.classic, required this.classicLight, required this.classicDark,
    required this.sage, required this.sageLight, required this.sageDark,
    required this.surface, required this.surfaceSecondary,
    required this.white, required this.black,
    required this.textPrimary, required this.textSecondary, required this.textTertiary, required this.textDisabled,
    required this.border,
    required this.success, required this.warning, required this.error, required this.info,
    required this.accent,
  });

  // ==========================================================================
  // CONSTANTES
  // ==========================================================================
  static const _aqua = Color(0xFF4DD0E1), _aquaL = Color(0xFF80DEEA), _aquaD = Color(0xFF0097A7);
  static const _classic = Color(0xFFFFA726), _classicL = Color(0xFFFFCC80), _classicD = Color(0xFFEF6C00);
  
  // SAGE = KDTV THEME : Noir + Rouge Accent #E50914
  static const _sage = Color(0xFFE50914), _sageL = Color(0xFFFF1F2F), _sageD = Color(0xFFB00610); 
  
  static const _success = Color(0xFF69F0AE), _warning = Color(0xFFFFD740), _error = Color(0xFFFF5252), _info = Color(0xFF40C4FF);
  static const _textS = Color(0xB3FFFFFF), _textT = Color(0x80FFFFFF), _textD = Color(0x4DFFFFFF);
  static const _textSBlack = Color(0xB3000000), _textTBlack = Color(0x80000000), _textDBlack = Color(0x4D000000);

  // ==========================================================================
  // PRESETS
  // ==========================================================================
  factory GlassColorPalette.defaults() => GlassColorPalette.aquaPreset();

  factory GlassColorPalette.aquaPreset() => GlassColorPalette(
    aqua: _aqua, aquaLight: _aquaL, aquaDark: _aquaD,
    classic: _classic, classicLight: _classicL, classicDark: _classicD,
    sage: _sage, sageLight: _sageL, sageDark: _sageD,
    surface: const Color(0xFF172027), surfaceSecondary: const Color(0xFF10161C),
    white: Colors.white, black: Colors.black,
    textPrimary: Colors.white, textSecondary: _textS, textTertiary: _textT, textDisabled: _textD,
    border: Colors.white.withValues(alpha: 0.18),
    success: _success, warning: _warning, error: _error, info: _info,
    accent: _aqua,
  );

  factory GlassColorPalette.classicPreset() => GlassColorPalette(
    aqua: _aqua, aquaLight: _aquaL, aquaDark: _aquaD,
    classic: _classic, classicLight: _classicL, classicDark: _classicD,
    sage: _sage, sageLight: _sageL, sageDark: _sageD,
    surface: const Color(0xFF1A1A1A), surfaceSecondary: const Color(0xFF101010),
    white: Colors.white, black: Colors.black,
    textPrimary: Colors.white, textSecondary: _textS, textTertiary: _textT, textDisabled: _textD,
    border: Colors.white.withValues(alpha: 0.18),
    success: _success, warning: _warning, error: _error, info: _info,
    accent: _classic,
  );

  factory GlassColorPalette.sagePreset() => GlassColorPalette(
    aqua: _aqua, aquaLight: _aquaL, aquaDark: _aquaD,
    classic: _classic, classicLight: _classicL, classicDark: _classicD,
    sage: _sage, sageLight: _sageL, sageDark: _sageD,
    surface: const Color(0x00000000),
    surfaceSecondary: const Color(0x0A000000),
    white: Colors.white, black: Colors.black,
    textPrimary: Colors.white, textSecondary: _textS, textTertiary: _textT, textDisabled: _textD,
    border: Colors.white.withValues(alpha: 0.12),
    success: _success, warning: _warning, error: _error, info: _info,
    accent: _sage,
  );

  factory GlassColorPalette.sageProPreset() => GlassColorPalette(
    aqua: _aqua, aquaLight: _aquaL, aquaDark: _aquaD,
    classic: _classic, classicLight: _classicL, classicDark: _classicD,
    sage: _sage, sageLight: _sageL, sageDark: _sageD,
    surface: const Color(0x0A000000),
    surfaceSecondary: const Color(0x14000000),
    white: Colors.white, black: Colors.black,
    textPrimary: Colors.white, textSecondary: _textS, textTertiary: _textT, textDisabled: _textD,
    border: _sage.withValues(alpha: 0.4),
    success: _success, warning: _warning, error: _error, info: _info,
    accent: _sage,
  );

  factory GlassColorPalette.sageOledPreset() => GlassColorPalette(
    aqua: _aqua, aquaLight: _aquaL, aquaDark: _aquaD,
    classic: _classic, classicLight: _classicL, classicDark: _classicD,
    sage: _sage, sageLight: _sageL, sageDark: _sageD,
    surface: Colors.black,
    surfaceSecondary: const Color(0xFF0A0A0A),
    white: Colors.white, black: Colors.black,
    textPrimary: Colors.white, textSecondary: _textS, textTertiary: _textT, textDisabled: _textD,
    border: Colors.white.withValues(alpha: 0.08),
    success: _success, warning: _warning, error: _error, info: _info,
    accent: _sage,
  );

  factory GlassColorPalette.sageGlassPreset() => GlassColorPalette(
    aqua: _aqua, aquaLight: _aquaL, aquaDark: _aquaD,
    classic: _classic, classicLight: _classicL, classicDark: _classicD,
    sage: _sage, sageLight: _sageL, sageDark: _sageD,
    surface: const Color(0x05000000),
    surfaceSecondary: const Color(0x0A000000),
    white: Colors.white, black: Colors.black,
    textPrimary: Colors.white, textSecondary: _textS, textTertiary: _textT, textDisabled: _textD,
    border: Colors.white.withValues(alpha: 0.10),
    success: _success, warning: _warning, error: _error, info: _info,
    accent: _sage,
  );

  // MANQUANT 1: LIGHT
  factory GlassColorPalette.lightPreset() => GlassColorPalette(
    aqua: _aqua, aquaLight: _aquaL, aquaDark: _aquaD,
    classic: _classic, classicLight: _classicL, classicDark: _classicD,
    sage: _sage, sageLight: _sageL, sageDark: _sageD,
    surface: const Color(0xFFF5F5F5), surfaceSecondary: const Color(0xFFE8E8E8),
    white: Colors.white, black: Colors.black,
    textPrimary: const Color(0xFF121212), textSecondary: _textSBlack, 
    textTertiary: _textTBlack, textDisabled: _textDBlack,
    border: Colors.black.withValues(alpha: 0.12),
    success: _success, warning: _warning, error: _error, info: _info,
    accent: _aqua,
  );

  // MANQUANT 2: DARK
  factory GlassColorPalette.darkPreset() => GlassColorPalette(
    aqua: _aqua, aquaLight: _aquaL, aquaDark: _aquaD,
    classic: _classic, classicLight: _classicL, classicDark: _classicD,
    sage: _sage, sageLight: _sageL, sageDark: _sageD,
    surface: const Color(0xFF121212), surfaceSecondary: const Color(0xFF1E1E1E),
    white: Colors.white, black: Colors.black,
    textPrimary: Colors.white, textSecondary: _textS, textTertiary: _textT, textDisabled: _textD,
    border: Colors.white.withValues(alpha: 0.18),
    success: _success, warning: _warning, error: _error, info: _info,
    accent: _classic,
  );

  // ==========================================================================
  // COPY WITH
  // ==========================================================================
  GlassColorPalette copyWith({
    Color? aqua, Color? aquaLight, Color? aquaDark,
    Color? classic, Color? classicLight, Color? classicDark,
    Color? sage, Color? sageLight, Color? sageDark,
    Color? surface, Color? surfaceSecondary,
    Color? white, Color? black,
    Color? textPrimary, Color? textSecondary, Color? textTertiary, Color? textDisabled,
    Color? border,
    Color? success, Color? warning, Color? error, Color? info,
    Color? accent,
  }) => GlassColorPalette(
    aqua: aqua ?? this.aqua, aquaLight: aquaLight ?? this.aquaLight, aquaDark: aquaDark ?? this.aquaDark,
    classic: classic ?? this.classic, classicLight: classicLight ?? this.classicLight, classicDark: classicDark ?? this.classicDark,
    sage: sage ?? this.sage, sageLight: sageLight ?? this.sageLight, sageDark: sageDark ?? this.sageDark,
    surface: surface ?? this.surface, surfaceSecondary: surfaceSecondary ?? this.surfaceSecondary,
    white: white ?? this.white, black: black ?? this.black,
    textPrimary: textPrimary ?? this.textPrimary, textSecondary: textSecondary ?? this.textSecondary, 
    textTertiary: textTertiary ?? this.textTertiary, textDisabled: textDisabled ?? this.textDisabled,
    border: border ?? this.border,
    success: success ?? this.success, warning: warning ?? this.warning, error: error ?? this.error, info: info ?? this.info,
    accent: accent ?? this.accent,
  );

  // ==========================================================================
  // UTILITAIRES
  // ==========================================================================
  Color primaryForStyle(bool useAqua) => useAqua ? aqua : classic;
  Color lightForStyle(bool useAqua) => useAqua ? aquaLight : classicLight;
  Color darkForStyle(bool useAqua) => useAqua ? aquaDark : classicDark;
  
  Color primaryForMode(AppThemeMode mode) {
    switch(mode) {
      case AppThemeMode.aqua: return aqua;
      case AppThemeMode.classic: return classic;
      case AppThemeMode.sage:
      case AppThemeMode.sagePro:
      case AppThemeMode.sageOled:
      case AppThemeMode.sageGlass: return sage;
      case AppThemeMode.dark: return classic;
      case AppThemeMode.light: return aqua;
      case AppThemeMode.system: return aqua;
    }
  }
  
  Color lightForMode(AppThemeMode mode) {
    switch(mode) {
      case AppThemeMode.aqua: return aquaLight;
      case AppThemeMode.classic: return classicLight;
      case AppThemeMode.sage:
      case AppThemeMode.sagePro:
      case AppThemeMode.sageOled:
      case AppThemeMode.sageGlass: return sageLight;
      case AppThemeMode.dark: return classicLight;
      case AppThemeMode.light: return aquaLight;
      case AppThemeMode.system: return aquaLight;
    }
  }
  
  Color darkForMode(AppThemeMode mode) {
    switch(mode) {
      case AppThemeMode.aqua: return aquaDark;
      case AppThemeMode.classic: return classicDark;
      case AppThemeMode.sage:
      case AppThemeMode.sagePro:
      case AppThemeMode.sageOled:
      case AppThemeMode.sageGlass: return sageDark;
      case AppThemeMode.dark: return classicDark;
      case AppThemeMode.light: return aquaDark;
      case AppThemeMode.system: return aquaDark;
    }
  }
  
  // Helper pour récupérer le preset complet selon le mode
  static GlassColorPalette fromMode(AppThemeMode mode) {
    switch(mode) {
      case AppThemeMode.aqua: return GlassColorPalette.aquaPreset();
      case AppThemeMode.classic: return GlassColorPalette.classicPreset();
      case AppThemeMode.sage: return GlassColorPalette.sagePreset();
      case AppThemeMode.sagePro: return GlassColorPalette.sageProPreset();
      case AppThemeMode.sageOled: return GlassColorPalette.sageOledPreset();
      case AppThemeMode.sageGlass: return GlassColorPalette.sageGlassPreset();
      case AppThemeMode.dark: return GlassColorPalette.darkPreset();
      case AppThemeMode.light: return GlassColorPalette.lightPreset();
      case AppThemeMode.system: return GlassColorPalette.aquaPreset();
    }
  }

  // Gradient pour AppBar selon le mode
  List<Color> gradientForMode(AppThemeMode mode) {
    final p = primaryForMode(mode);
    final d = darkForMode(mode);
    return [p, d];
  }

  // Est-ce mode sombre
  bool get isDarkMode {
    return surface.computeLuminance() < 0.5;
  }
}
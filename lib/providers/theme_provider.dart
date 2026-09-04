// ============================================================================
// GLASS — THEME PROVIDER
// ============================================================================
//
// Gestion globale du thème de l'application.
//
// Ce fichier est la source unique de vérité pour :
//
// - AppThemeMode
// - ThemeState
// - ThemeNotifier
// - themeProvider
// - materialThemeModeProvider
// - glassThemeProvider
//
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/enums/glass_enums.dart';

import 'shared_preferences_provider.dart';

// ============================================================================
// ÉTAT DU THÈME
// ============================================================================

class ThemeState {
  final AppThemeMode mode;
  final bool enableGradient;
  final bool enableBlur;
  final bool enableNoise;

  const ThemeState(
    this.mode, {
    this.enableGradient = true,
    this.enableBlur = true,
    this.enableNoise = true,
  });

  // ==========================================================================
  // COPY WITH
  // ==========================================================================

  ThemeState copyWith({
    AppThemeMode? mode,
    bool? enableGradient,
    bool? enableBlur,
    bool? enableNoise,
  }) {
    return ThemeState(
      mode?? this.mode,
      enableGradient: enableGradient?? this.enableGradient,
      enableBlur: enableBlur?? this.enableBlur,
      enableNoise: enableNoise?? this.enableNoise,
    );
  }

  // ==========================================================================
  // CONVERSION VERS THEMEMODE
  // ==========================================================================

  ThemeMode get materialThemeMode {
    switch (mode) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.dark:
      case AppThemeMode.classic:
      case AppThemeMode.sage:
      case AppThemeMode.sagePro:
      case AppThemeMode.sageOled:
      case AppThemeMode.sageGlass:
        return ThemeMode.dark;
      case AppThemeMode.light:
      case AppThemeMode.aqua:
        return ThemeMode.light;
    }
  }

  // ==========================================================================
  // HELPERS GLASS
  // ==========================================================================

  bool get isAqua => mode == AppThemeMode.aqua;
  bool get isClassic => mode == AppThemeMode.classic;
  bool get isSage => mode == AppThemeMode.sage;
  bool get isSagePro => mode == AppThemeMode.sagePro;
  bool get isSageOled => mode == AppThemeMode.sageOled;
  bool get isSageGlass => mode == AppThemeMode.sageGlass;
  bool get isAnySage => mode.name.startsWith('sage'); // <-- Helper pour les 4
  bool get isDarkMode => mode == AppThemeMode.dark || mode == AppThemeMode.classic || isAnySage;
  bool get isLightMode => mode == AppThemeMode.light || mode == AppThemeMode.aqua;
  bool get isSystem => mode == AppThemeMode.system;

  // ==========================================================================
  // DEBUG
  // ==========================================================================

  @override
  String toString() {
    return 'ThemeState(mode: $mode, gradient: $enableGradient, blur: $enableBlur, noise: $enableNoise)';
  }
}

// ============================================================================
// NOTIFIER DU THÈME
// ============================================================================

class ThemeNotifier extends Notifier<ThemeState> {
  // ==========================================================================
  // CLÉS DE PERSISTANCE
  // ==========================================================================

  static const String themeKey = 'app_theme_mode';
  static const String enableGradientKey = 'app_enable_gradient';
  static const String enableBlurKey = 'app_enable_blur';
  static const String enableNoiseKey = 'app_enable_noise';

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  ThemeState build() {
    final prefs = ref.read(sharedPreferencesProvider);

    final int savedIndex = prefs.getInt(themeKey)?? AppThemeMode.system.index;
    final bool savedGradient = prefs.getBool(enableGradientKey)?? true;
    final bool savedBlur = prefs.getBool(enableBlurKey)?? true;
    final bool savedNoise = prefs.getBool(enableNoiseKey)?? true;

    if (savedIndex < 0 || savedIndex >= AppThemeMode.values.length) {
      return const ThemeState(AppThemeMode.system);
    }

    return ThemeState(
      AppThemeMode.values[savedIndex],
      enableGradient: savedGradient,
      enableBlur: savedBlur,
      enableNoise: savedNoise,
    );
  }

  // ==========================================================================
  // CHANGER LE THÈME
  // ==========================================================================

  Future<void> setTheme(AppThemeMode mode) async {
    if (state.mode == mode) return;

    state = state.copyWith(mode: mode);

    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setInt(themeKey, mode.index);
  }

  // ==========================================================================
  // TOGGLES GLASS
  // ==========================================================================

  Future<void> setEnableGradient(bool value) async {
    state = state.copyWith(enableGradient: value);
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(enableGradientKey, value);
  }

  Future<void> setEnableBlur(bool value) async {
    state = state.copyWith(enableBlur: value);
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(enableBlurKey, value);
  }

  Future<void> setEnableNoise(bool value) async {
    state = state.copyWith(enableNoise: value);
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(enableNoiseKey, value);
  }

  // ==========================================================================
  // PRESETS RAPIDES
  // ==========================================================================

  Future<void> setSystemTheme() async => await setTheme(AppThemeMode.system);
  Future<void> setDarkTheme() async => await setTheme(AppThemeMode.dark);
  Future<void> setLightTheme() async => await setTheme(AppThemeMode.light);
  Future<void> setAquaTheme() async => await setTheme(AppThemeMode.aqua);
  Future<void> setClassicTheme() async => await setTheme(AppThemeMode.classic);
  Future<void> setSageTheme() async => await setTheme(AppThemeMode.sage);
  Future<void> setSageProTheme() async => await setTheme(AppThemeMode.sagePro); // <-- AJOUTE
  Future<void> setSageOledTheme() async => await setTheme(AppThemeMode.sageOled); // <-- AJOUTE
  Future<void> setSageGlassTheme() async => await setTheme(AppThemeMode.sageGlass); // <-- AJOUTE

  // ==========================================================================
  // BASCULER ENTRE SOMBRE ET CLAIR
  // ==========================================================================

  Future<void> toggleDarkLight() async {
    if (state.isDarkMode) {
      await setAquaTheme(); // Aqua = light par défaut
    } else {
      await setClassicTheme(); // Classic = dark par défaut
    }
  }

  // ==========================================================================
  // RÉINITIALISATION
  // ==========================================================================

  Future<void> reset() async {
    await setSystemTheme();
    await setEnableGradient(true);
    await setEnableBlur(true);
    await setEnableNoise(true);
  }
}

// ============================================================================
// PROVIDER GLOBAL DU THÈME
// ============================================================================

final themeProvider = NotifierProvider<ThemeNotifier, ThemeState>(
  ThemeNotifier.new,
);

// ============================================================================
// PROVIDER MATERIAL THEME MODE
// ============================================================================

final materialThemeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(themeProvider.select((state) => state.materialThemeMode));
});

// ============================================================================
// PROVIDER GLASS HELPERS
// ============================================================================

final isAquaModeProvider = Provider<bool>((ref) => ref.watch(themeProvider.select((s) => s.isAqua)));
final isClassicModeProvider = Provider<bool>((ref) => ref.watch(themeProvider.select((s) => s.isClassic)));
final isSageModeProvider = Provider<bool>((ref) => ref.watch(themeProvider.select((s) => s.isSage)));
final isAnySageModeProvider = Provider<bool>((ref) => ref.watch(themeProvider.select((s) => s.isAnySage))); // <-- AJOUTE

// ============================================================================
// FIN
// ============================================================================
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
//
// IMPORTANT :
//
// Le provider utilise l'instance SharedPreferences injectée par
// sharedPreferencesProvider.
//
// L'application cliente doit donc override sharedPreferencesProvider
// dans son ProviderScope.
//
// Compatible Riverpod 3.x.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shared_preferences_provider.dart';

// ============================================================================
// MODES DE THÈME DE L'APPLICATION
// ============================================================================

enum AppThemeMode { system, dark, light }

// ============================================================================
// ÉTAT DU THÈME
// ============================================================================

class ThemeState {
  final AppThemeMode mode;

  const ThemeState(this.mode);

  // ==========================================================================
  // COPY WITH
  // ==========================================================================

  ThemeState copyWith({AppThemeMode? mode}) {
    return ThemeState(mode ?? this.mode);
  }

  // ==========================================================================
  // CONVERSION VERS THEMEMODE
  // ==========================================================================

  ThemeMode get materialThemeMode {
    switch (mode) {
      case AppThemeMode.system:
        return ThemeMode.system;

      case AppThemeMode.dark:
        return ThemeMode.dark;

      case AppThemeMode.light:
        return ThemeMode.light;
    }
  }

  // ==========================================================================
  // HELPERS
  // ==========================================================================

  bool get isSystem {
    return mode == AppThemeMode.system;
  }

  bool get isDark {
    return mode == AppThemeMode.dark;
  }

  bool get isLight {
    return mode == AppThemeMode.light;
  }

  // ==========================================================================
  // DEBUG
  // ==========================================================================

  @override
  String toString() {
    return 'ThemeState(mode: $mode)';
  }
}

// ============================================================================
// NOTIFIER DU THÈME
// ============================================================================
//
// Riverpod 3.x
//
// Ancien :
//   extends StateNotifier<ThemeState>
//
// Nouveau :
//   extends Notifier<ThemeState>
//
// ============================================================================

class ThemeNotifier extends Notifier<ThemeState> {
  // ==========================================================================
  // CLÉ DE PERSISTANCE
  // ==========================================================================

  static const String themeKey = 'app_theme_mode';

  // ==========================================================================
  // BUILD
  // ==========================================================================
  //
  // Dans Riverpod 3, l'état initial est créé dans build().
  //
  // On récupère ici SharedPreferences via ref.
  //
  // ==========================================================================

  @override
  ThemeState build() {
    final prefs = ref.read(sharedPreferencesProvider);

    final int savedIndex = prefs.getInt(themeKey) ?? AppThemeMode.system.index;

    // ------------------------------------------------------------------------
    // SÉCURITÉ
    // ------------------------------------------------------------------------
    //
    // Si une ancienne valeur invalide est trouvée dans SharedPreferences,
    // on revient automatiquement au mode système.
    //
    // ------------------------------------------------------------------------

    if (savedIndex < 0 || savedIndex >= AppThemeMode.values.length) {
      return const ThemeState(AppThemeMode.system);
    }

    // ------------------------------------------------------------------------
    // RESTAURATION
    // ------------------------------------------------------------------------

    return ThemeState(AppThemeMode.values[savedIndex]);
  }

  // ==========================================================================
  // CHANGER LE THÈME
  // ==========================================================================

  Future<void> setTheme(AppThemeMode mode) async {
    // ------------------------------------------------------------------------
    // AUCUN CHANGEMENT
    // ------------------------------------------------------------------------

    if (state.mode == mode) {
      return;
    }

    // ------------------------------------------------------------------------
    // MISE À JOUR IMMÉDIATE
    // ------------------------------------------------------------------------

    state = ThemeState(mode);

    // ------------------------------------------------------------------------
    // PERSISTANCE
    // ------------------------------------------------------------------------

    final prefs = ref.read(sharedPreferencesProvider);

    await prefs.setInt(themeKey, mode.index);
  }

  // ==========================================================================
  // THÈME SYSTÈME
  // ==========================================================================

  Future<void> setSystemTheme() async {
    await setTheme(AppThemeMode.system);
  }

  // ==========================================================================
  // THÈME SOMBRE
  // ==========================================================================

  Future<void> setDarkTheme() async {
    await setTheme(AppThemeMode.dark);
  }

  // ==========================================================================
  // THÈME CLAIR
  // ==========================================================================

  Future<void> setLightTheme() async {
    await setTheme(AppThemeMode.light);
  }

  // ==========================================================================
  // BASCULER ENTRE SOMBRE ET CLAIR
  // ==========================================================================

  Future<void> toggleDarkLight() async {
    if (state.mode == AppThemeMode.dark) {
      await setLightTheme();
    } else {
      await setDarkTheme();
    }
  }

  // ==========================================================================
  // RÉINITIALISATION
  // ==========================================================================

  Future<void> reset() async {
    await setSystemTheme();
  }
}

// ============================================================================
// PROVIDER GLOBAL DU THÈME
// ============================================================================
//
// Riverpod 3.x :
//   NotifierProvider
//
// Utilisation :
//
// final state = ref.watch(themeProvider);
//
// ou :
//
// final mode = ref.watch(
//   themeProvider.select(
//     (state) => state.materialThemeMode,
//   ),
// );
//
// ============================================================================

final themeProvider = NotifierProvider<ThemeNotifier, ThemeState>(
  ThemeNotifier.new,
);

// ============================================================================
// PROVIDER MATERIAL THEME MODE
// ============================================================================
//
// Compatibilité avec l'ancien code.
//
// Permet d'utiliser directement :
//
// final ThemeMode themeMode = ref.watch(
//   materialThemeModeProvider,
// );
//
// ============================================================================

final materialThemeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(themeProvider.select((state) => state.materialThemeMode));
});

// ============================================================================
// FIN
// ============================================================================

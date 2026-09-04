import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_glass/settings/widgets/glass_color_storage.dart';
import 'package:universal_glass/theme/glass_color_theme.dart';
import 'package:universal_glass/theme/glass_colors.dart';



/// ============================================================================
/// GLASS COLOR NOTIFIER
/// ============================================================================
///
/// Etat global des couleurs Glass.
///
/// Permet :
///
/// • changement en live
/// • restauration
/// • persistance
/// • changement de palette
///
/// ============================================================================

class GlassColorNotifier extends ChangeNotifier {
  // ==========================================================================
  // ETAT
  // ==========================================================================

  GlassColorTheme _theme =
      GlassColors.aqua;

  GlassColorTheme get theme =>
      _theme;

  // ==========================================================================
  // INIT
  // ==========================================================================

  Future<void> load() async {
    final String? savedTheme =
        await _loadThemeName();

    if (savedTheme == 'classic') {
      _theme =
          GlassColors.classic;
    } else if (savedTheme == 'dark') {
      _theme =
          GlassColors.dark;
    } else {
      _theme =
          GlassColors.aqua;
    }

    // ------------------------------------------------------------------------
    // COULEURS PERSONNALISEES
    // ------------------------------------------------------------------------

    final Color? accent =
        await GlassColorStorage.loadColor(
      'accent',
    );

    if (accent != null) {
      _theme =
          _theme.copyWith(
        accent: accent,
      );
    }

    notifyListeners();
  }

  // ==========================================================================
  // THEME
  // ==========================================================================

  Future<void> setTheme(
    GlassColorTheme theme, {
    bool persist = true,
  }) async {
    _theme =
        theme;

    notifyListeners();

    if (persist) {
      await _saveThemeName(
        theme.name,
      );
    }
  }

  // ==========================================================================
  // ACCENT
  // ==========================================================================

  Future<void> setAccent(
    Color color, {
    bool persist = true,
  }) async {
    _theme =
        _theme.copyWith(
      accent: color,
    );

    notifyListeners();

    if (persist) {
      await GlassColorStorage.saveColor(
        'accent',
        color,
      );
    }
  }

  // ==========================================================================
  // ACCENT BRIGHT
  // ==========================================================================

  Future<void> setAccentBright(
    Color color, {
    bool persist = true,
  }) async {
    _theme =
        _theme.copyWith(
      accentBright: color,
    );

    notifyListeners();

    if (persist) {
      await GlassColorStorage.saveColor(
        'accentBright',
        color,
      );
    }
  }

  // ==========================================================================
  // ACCENT DARK
  // ==========================================================================

  Future<void> setAccentDark(
    Color color, {
    bool persist = true,
  }) async {
    _theme =
        _theme.copyWith(
      accentDark: color,
    );

    notifyListeners();

    if (persist) {
      await GlassColorStorage.saveColor(
        'accentDark',
        color,
      );
    }
  }

  // ==========================================================================
  // INPUT BACKGROUND
  // ==========================================================================

  Future<void> setInputBackground(
    Color color, {
    bool persist = true,
  }) async {
    _theme =
        _theme.copyWith(
      inputBackground: color,
    );

    notifyListeners();

    if (persist) {
      await GlassColorStorage.saveColor(
        'inputBackground',
        color,
      );
    }
  }

  // ==========================================================================
  // CARD BACKGROUND
  // ==========================================================================

  Future<void> setCardBackground(
    Color color, {
    bool persist = true,
  }) async {
    _theme =
        _theme.copyWith(
      cardBackground: color,
    );

    notifyListeners();

    if (persist) {
      await GlassColorStorage.saveColor(
        'cardBackground',
        color,
      );
    }
  }

  // ==========================================================================
  // RESET
  // ==========================================================================

  Future<void> reset() async {
    _theme =
        GlassColors.aqua;

    await GlassColorStorage.clear();

    notifyListeners();
  }

  // ==========================================================================
  // THEME NAME STORAGE
  // ==========================================================================

  Future<void> _saveThemeName(
    String name,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      'glass_color_theme',
      name.toLowerCase(),
    );
  }

  Future<String?> _loadThemeName() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
      'glass_color_theme',
    );
  }
}
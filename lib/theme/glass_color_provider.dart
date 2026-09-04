
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'glass_color_palette.dart';

/// ============================================================================
/// GLASS COLOR PROVIDER
/// ============================================================================
///
/// Gestionnaire central des couleurs Universal Glass.
///
/// RESPONSABILITÉS
/// ---------------
///
/// • conserver la palette actuelle
/// • modifier les couleurs en live
/// • sauvegarder les couleurs
/// • restaurer les couleurs
/// • appliquer les presets
/// • notifier automatiquement l'interface
///
/// IMPORTANT
/// ---------
///
/// Cette classe ne contient aucune logique visuelle.
///
/// Les composants utilisent simplement :
///
///     ref.watch(glassColorProvider)
///
/// puis :
///
///     final colors = ref.watch(glassColorProvider);
///
/// ============================================================================

class GlassColorProvider extends ChangeNotifier {
  // ==========================================================================
  // CLÉS DE STOCKAGE
  // ==========================================================================

  static const String _prefix =
      'universal_glass_color_';

  // ==========================================================================
  // PALETTE
  // ==========================================================================

  GlassColorPalette _palette;

  GlassColorPalette get palette => _palette;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  GlassColorProvider({
    GlassColorPalette? initialPalette,
  }) : _palette =
            initialPalette ??
            GlassColorPalette.defaults();

  // ==========================================================================
  // INITIALISATION
  // ==========================================================================

  Future<void> load() async {
    final SharedPreferences prefs =
        await SharedPreferences.getInstance();

    _palette = _readPalette(prefs);

    notifyListeners();
  }

  // ==========================================================================
  // CHANGER TOUTE LA PALETTE
  // ==========================================================================

  Future<void> setPalette(
    GlassColorPalette palette,
  ) async {
    _palette = palette;

    notifyListeners();

    await _savePalette();
  }

  // ==========================================================================
  // AQUA
  // ==========================================================================

  Future<void> setAqua(
    Color color,
  ) async {
    _palette = _palette.copyWith(
      aqua: color,
    );

    notifyListeners();

    await _savePalette();
  }

  Future<void> setAquaLight(
    Color color,
  ) async {
    _palette = _palette.copyWith(
      aquaLight: color,
    );

    notifyListeners();

    await _savePalette();
  }

  Future<void> setAquaDark(
    Color color,
  ) async {
    _palette = _palette.copyWith(
      aquaDark: color,
    );

    notifyListeners();

    await _savePalette();
  }

  // ==========================================================================
  // CLASSIC
  // ==========================================================================

  Future<void> setClassic(
    Color color,
  ) async {
    _palette = _palette.copyWith(
      classic: color,
    );

    notifyListeners();

    await _savePalette();
  }

  Future<void> setClassicLight(
    Color color,
  ) async {
    _palette = _palette.copyWith(
      classicLight: color,
    );

    notifyListeners();

    await _savePalette();
  }

  Future<void> setClassicDark(
    Color color,
  ) async {
    _palette = _palette.copyWith(
      classicDark: color,
    );

    notifyListeners();

    await _savePalette();
  }

  // ==========================================================================
  // SURFACES
  // ==========================================================================

  Future<void> setSurface(
    Color color,
  ) async {
    _palette = _palette.copyWith(
      surface: color,
    );

    notifyListeners();

    await _savePalette();
  }

  Future<void> setSurfaceSecondary(
    Color color,
  ) async {
    _palette = _palette.copyWith(
      surfaceSecondary: color,
    );

    notifyListeners();

    await _savePalette();
  }

  // ==========================================================================
  // TEXTE
  // ==========================================================================

  Future<void> setTextPrimary(
    Color color,
  ) async {
    _palette = _palette.copyWith(
      textPrimary: color,
    );

    notifyListeners();

    await _savePalette();
  }

  Future<void> setTextSecondary(
    Color color,
  ) async {
    _palette = _palette.copyWith(
      textSecondary: color,
    );

    notifyListeners();

    await _savePalette();
  }

  Future<void> setTextTertiary(
    Color color,
  ) async {
    _palette = _palette.copyWith(
      textTertiary: color,
    );

    notifyListeners();

    await _savePalette();
  }

  Future<void> setTextDisabled(
    Color color,
  ) async {
    _palette = _palette.copyWith(
      textDisabled: color,
    );

    notifyListeners();

    await _savePalette();
  }

  // ==========================================================================
  // BORDER
  // ==========================================================================

  Future<void> setBorder(
    Color color,
  ) async {
    _palette = _palette.copyWith(
      border: color,
    );

    notifyListeners();

    await _savePalette();
  }

  // ==========================================================================
  // ÉTATS
  // ==========================================================================

  Future<void> setSuccess(
    Color color,
  ) async {
    _palette = _palette.copyWith(
      success: color,
    );

    notifyListeners();

    await _savePalette();
  }

  Future<void> setWarning(
    Color color,
  ) async {
    _palette = _palette.copyWith(
      warning: color,
    );

    notifyListeners();

    await _savePalette();
  }

  Future<void> setError(
    Color color,
  ) async {
    _palette = _palette.copyWith(
      error: color,
    );

    notifyListeners();

    await _savePalette();
  }

  Future<void> setInfo(
    Color color,
  ) async {
    _palette = _palette.copyWith(
      info: color,
    );

    notifyListeners();

    await _savePalette();
  }

  // ==========================================================================
  // PRESET AQUA
  // ==========================================================================

  Future<void> applyAquaPreset() async {
    _palette =
        GlassColorPalette.aquaPreset();

    notifyListeners();

    await _savePalette();
  }

  // ==========================================================================
  // PRESET CLASSIC
  // ==========================================================================

  Future<void> applyClassicPreset() async {
    _palette =
        GlassColorPalette.classicPreset();

    notifyListeners();

    await _savePalette();
  }

  // ==========================================================================
  // RESET
  // ==========================================================================

  Future<void> reset() async {
    _palette =
        GlassColorPalette.defaults();

    notifyListeners();

    final SharedPreferences prefs =
        await SharedPreferences.getInstance();

    final keys =
        prefs
            .getKeys()
            .where(
              (key) =>
                  key.startsWith(_prefix),
            )
            .toList();

    for (final key in keys) {
      await prefs.remove(key);
    }
  }

  // ==========================================================================
  // SAUVEGARDE
  // ==========================================================================

  Future<void> _savePalette() async {
    final SharedPreferences prefs =
        await SharedPreferences.getInstance();

    await prefs.setInt(
      '${_prefix}aqua',
      _palette.aqua.toARGB32(),
    );

    await prefs.setInt(
      '${_prefix}aquaLight',
      _palette.aquaLight.toARGB32(),
    );

    await prefs.setInt(
      '${_prefix}aquaDark',
      _palette.aquaDark.toARGB32(),
    );

    await prefs.setInt(
      '${_prefix}classic',
      _palette.classic.toARGB32(),
    );

    await prefs.setInt(
      '${_prefix}classicLight',
      _palette.classicLight.toARGB32(),
    );

    await prefs.setInt(
      '${_prefix}classicDark',
      _palette.classicDark.toARGB32(),
    );

    await prefs.setInt(
      '${_prefix}surface',
      _palette.surface.toARGB32(),
    );

    await prefs.setInt(
      '${_prefix}surfaceSecondary',
      _palette.surfaceSecondary.toARGB32(),
    );

    await prefs.setInt(
      '${_prefix}textPrimary',
      _palette.textPrimary.toARGB32(),
    );

    await prefs.setInt(
      '${_prefix}textSecondary',
      _palette.textSecondary.toARGB32(),
    );

    await prefs.setInt(
      '${_prefix}textTertiary',
      _palette.textTertiary.toARGB32(),
    );

    await prefs.setInt(
      '${_prefix}textDisabled',
      _palette.textDisabled.toARGB32(),
    );

    await prefs.setInt(
      '${_prefix}border',
      _palette.border.toARGB32(),
    );

    await prefs.setInt(
      '${_prefix}success',
      _palette.success.toARGB32(),
    );

    await prefs.setInt(
      '${_prefix}warning',
      _palette.warning.toARGB32(),
    );

    await prefs.setInt(
      '${_prefix}error',
      _palette.error.toARGB32(),
    );

    await prefs.setInt(
      '${_prefix}info',
      _palette.info.toARGB32(),
    );
  }

  // ==========================================================================
  // LECTURE
  // ==========================================================================

  GlassColorPalette _readPalette(
    SharedPreferences prefs,
  ) {
    final GlassColorPalette defaults =
        GlassColorPalette.defaults();

    return defaults.copyWith(
      aqua: _readColor(
        prefs,
        'aqua',
        defaults.aqua,
      ),

      aquaLight: _readColor(
        prefs,
        'aquaLight',
        defaults.aquaLight,
      ),

      aquaDark: _readColor(
        prefs,
        'aquaDark',
        defaults.aquaDark,
      ),

      classic: _readColor(
        prefs,
        'classic',
        defaults.classic,
      ),

      classicLight: _readColor(
        prefs,
        'classicLight',
        defaults.classicLight,
      ),

      classicDark: _readColor(
        prefs,
        'classicDark',
        defaults.classicDark,
      ),

      surface: _readColor(
        prefs,
        'surface',
        defaults.surface,
      ),

      surfaceSecondary: _readColor(
        prefs,
        'surfaceSecondary',
        defaults.surfaceSecondary,
      ),

      textPrimary: _readColor(
        prefs,
        'textPrimary',
        defaults.textPrimary,
      ),

      textSecondary: _readColor(
        prefs,
        'textSecondary',
        defaults.textSecondary,
      ),

      textTertiary: _readColor(
        prefs,
        'textTertiary',
        defaults.textTertiary,
      ),

      textDisabled: _readColor(
        prefs,
        'textDisabled',
        defaults.textDisabled,
      ),

      border: _readColor(
        prefs,
        'border',
        defaults.border,
      ),

      success: _readColor(
        prefs,
        'success',
        defaults.success,
      ),

      warning: _readColor(
        prefs,
        'warning',
        defaults.warning,
      ),

      error: _readColor(
        prefs,
        'error',
        defaults.error,
      ),

      info: _readColor(
        prefs,
        'info',
        defaults.info,
      ),
    );
  }

  // ==========================================================================
  // READ COLOR
  // ==========================================================================

  Color _readColor(
    SharedPreferences prefs,
    String name,
    Color fallback,
  ) {
    final int? value =
        prefs.getInt(
      '$_prefix$name',
    );

    if (value == null) {
      return fallback;
    }

    return Color(value);
  }
}
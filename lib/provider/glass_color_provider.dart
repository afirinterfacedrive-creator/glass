import 'package:flutter/material.dart';
import 'package:universal_glass/theme/glass_color_palette.dart';

import '../settings/widgets/glass_color_storage.dart';


/// ============================================================================
/// GLASS COLOR PROVIDER
/// ============================================================================
///
/// Gestionnaire central des couleurs Universal Glass.
///
/// RESPONSABILITÉS
///
/// • possède la palette actuelle
/// • permet de modifier les couleurs en live
/// • persiste les modifications
/// • restaure les couleurs au démarrage
/// • permet de restaurer la palette par défaut
/// • permet de changer de preset
///
/// IMPORTANT
///
/// Cette classe ne gère PAS :
///
/// • Aqua / Classic
/// • GlassStyle
/// • les gradients directement
/// • les Cards
/// • les Inputs
/// • les AppBars
///
/// Elle fournit uniquement la palette de couleurs.
///
/// ============================================================================

class GlassColorProvider extends ChangeNotifier {
  // ==========================================================================
  // PALETTE
  // ==========================================================================

  GlassColorPalette _palette;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  GlassColorProvider({
    required GlassColorPalette initialPalette,
  }) : _palette = initialPalette;

  // ==========================================================================
  // PALETTE ACTUELLE
  // ==========================================================================

  GlassColorPalette get palette => _palette;

  // ==========================================================================
  // COULEURS DIRECTES
  // ==========================================================================
  //
  // Ces getters évitent de devoir écrire :
  //
  // ref.watch(glassColorProvider).palette.aqua
  //
  // partout dans l'application.
  //
  // ==========================================================================

  Color get aqua => _palette.aqua;

  Color get aquaLight => _palette.aquaLight;

  Color get aquaDark => _palette.aquaDark;

  Color get classic => _palette.classic;

  Color get classicLight => _palette.classicLight;

  Color get classicDark => _palette.classicDark;

  Color get surface => _palette.surface;

  Color get surfaceSecondary =>
      _palette.surfaceSecondary;

  Color get white => _palette.white;

  Color get black => _palette.black;

  Color get textPrimary =>
      _palette.textPrimary;

  Color get textSecondary =>
      _palette.textSecondary;

  Color get textTertiary =>
      _palette.textTertiary;

  Color get textDisabled =>
      _palette.textDisabled;

  Color get border =>
      _palette.border;

  Color get success =>
      _palette.success;

  Color get warning =>
      _palette.warning;

  Color get error =>
      _palette.error;

  Color get info =>
      _palette.info;

  // ==========================================================================
  // CHARGEMENT
  // ==========================================================================
  ///
  /// Charge :
  ///
  /// 1. le preset sauvegardé
  /// 2. les couleurs personnalisées
  ///
  /// ==========================================================================

  Future<void> load() async {
    // ------------------------------------------------------------------------
    // PRESET
    // ------------------------------------------------------------------------

    final String? savedPreset =
        await GlassColorStorage.loadString(
      'palette',
    );

    switch (savedPreset) {
      case 'classic':
        _palette =
            GlassColorPalette.classicPreset();
        break;

      case 'aqua':
        _palette =
            GlassColorPalette.aquaPreset();
        break;

      default:
        _palette =
            GlassColorPalette.defaults();
    }

    // ------------------------------------------------------------------------
    // COULEURS PERSONNALISÉES
    // ------------------------------------------------------------------------

    _palette =
        await _loadCustomColors(
      _palette,
    );

    notifyListeners();
  }

  // ==========================================================================
  // CHARGEMENT DES COULEURS PERSONNALISÉES
  // ==========================================================================
Future<GlassColorPalette> _loadCustomColors(
  GlassColorPalette palette,
) async {
  final Map<String, Color?> colors = {};

  const List<String> keys = [
    'aqua',
    'aquaLight',
    'aquaDark',
    'classic',
    'classicLight',
    'classicDark',
    'surface',
    'surfaceSecondary',
    'white',
    'black',
    'textPrimary',
    'textSecondary',
    'textTertiary',
    'textDisabled',
    'border',
    'success',
    'warning',
    'error',
    'info',
  ];

  // --------------------------------------------------------------------------
  // CHARGEMENT DES COULEURS PERSONNALISÉES
  // --------------------------------------------------------------------------

  for (final String key in keys) {
    colors[key] = await GlassColorStorage.loadColor(key);
  }

  // --------------------------------------------------------------------------
  // RECONSTRUCTION DE LA PALETTE
  // --------------------------------------------------------------------------

  return palette.copyWith(
    aqua:
        colors['aqua'] ??
        palette.aqua,

    aquaLight:
        colors['aquaLight'] ??
        palette.aquaLight,

    aquaDark:
        colors['aquaDark'] ??
        palette.aquaDark,

    classic:
        colors['classic'] ??
        palette.classic,

    classicLight:
        colors['classicLight'] ??
        palette.classicLight,

    classicDark:
        colors['classicDark'] ??
        palette.classicDark,

    surface:
        colors['surface'] ??
        palette.surface,

    surfaceSecondary:
        colors['surfaceSecondary'] ??
        palette.surfaceSecondary,

    white:
        colors['white'] ??
        palette.white,

    black:
        colors['black'] ??
        palette.black,

    textPrimary:
        colors['textPrimary'] ??
        palette.textPrimary,

    textSecondary:
        colors['textSecondary'] ??
        palette.textSecondary,

    textTertiary:
        colors['textTertiary'] ??
        palette.textTertiary,

    textDisabled:
        colors['textDisabled'] ??
        palette.textDisabled,

    border:
        colors['border'] ??
        palette.border,

    success:
        colors['success'] ??
        palette.success,

    warning:
        colors['warning'] ??
        palette.warning,

    error:
        colors['error'] ??
        palette.error,

    info:
        colors['info'] ??
        palette.info,
  );
}
  
  // ==========================================================================
  // PRESET AQUA
  // ==========================================================================

  Future<void> setAquaPreset({
    bool persist = true,
  }) async {
    await setPalette(
      GlassColorPalette.aquaPreset(),
      presetName: 'aqua',
      persist: persist,
    );
  }

  // ==========================================================================
  // PRESET CLASSIC
  // ==========================================================================

  Future<void> setClassicPreset({
    bool persist = true,
  }) async {
    await setPalette(
      GlassColorPalette.classicPreset(),
      presetName: 'classic',
      persist: persist,
    );
  }

  // ==========================================================================
  // PALETTE COMPLÈTE
  // ==========================================================================

  Future<void> setPalette(
    GlassColorPalette palette, {
    String? presetName,
    bool persist = true,
  }) async {
    _palette = palette;

    notifyListeners();

    if (!persist) {
      return;
    }

    if (presetName != null) {
      await GlassColorStorage.saveString(
        'palette',
        presetName,
      );
    }

    await _saveAllColors();
  }

  // ==========================================================================
  // MISE À JOUR GÉNÉRIQUE
  // ==========================================================================

  Future<void> update(
    GlassColorPalette Function(
      GlassColorPalette current,
    ) builder, {
    bool persist = true,
  }) async {
    _palette =
        builder(_palette);

    notifyListeners();

    if (persist) {
      await _saveAllColors();
    }
  }

  // ==========================================================================
  // AQUA
  // ==========================================================================

  Future<void> setAqua(
    Color color, {
    bool persist = true,
  }) async {
    await update(
      (current) =>
          current.copyWith(
        aqua: color,
      ),
      persist: persist,
    );
  }

  // ==========================================================================
  // AQUA LIGHT
  // ==========================================================================

  Future<void> setAquaLight(
    Color color, {
    bool persist = true,
  }) async {
    await update(
      (current) =>
          current.copyWith(
        aquaLight: color,
      ),
      persist: persist,
    );
  }

  // ==========================================================================
  // AQUA DARK
  // ==========================================================================

  Future<void> setAquaDark(
    Color color, {
    bool persist = true,
  }) async {
    await update(
      (current) =>
          current.copyWith(
        aquaDark: color,
      ),
      persist: persist,
    );
  }

  // ==========================================================================
  // CLASSIC
  // ==========================================================================

  Future<void> setClassic(
    Color color, {
    bool persist = true,
  }) async {
    await update(
      (current) =>
          current.copyWith(
        classic: color,
      ),
      persist: persist,
    );
  }

  // ==========================================================================
  // CLASSIC LIGHT
  // ==========================================================================

  Future<void> setClassicLight(
    Color color, {
    bool persist = true,
  }) async {
    await update(
      (current) =>
          current.copyWith(
        classicLight: color,
      ),
      persist: persist,
    );
  }

  // ==========================================================================
  // CLASSIC DARK
  // ==========================================================================

  Future<void> setClassicDark(
    Color color, {
    bool persist = true,
  }) async {
    await update(
      (current) =>
          current.copyWith(
        classicDark: color,
      ),
      persist: persist,
    );
  }

  // ==========================================================================
  // SURFACE
  // ==========================================================================

  Future<void> setSurface(
    Color color, {
    bool persist = true,
  }) async {
    await update(
      (current) =>
          current.copyWith(
        surface: color,
      ),
      persist: persist,
    );
  }

  // ==========================================================================
  // SURFACE SECONDARY
  // ==========================================================================

  Future<void> setSurfaceSecondary(
    Color color, {
    bool persist = true,
  }) async {
    await update(
      (current) =>
          current.copyWith(
        surfaceSecondary: color,
      ),
      persist: persist,
    );
  }

  // ==========================================================================
  // TEXT PRIMARY
  // ==========================================================================

  Future<void> setTextPrimary(
    Color color, {
    bool persist = true,
  }) async {
    await update(
      (current) =>
          current.copyWith(
        textPrimary: color,
      ),
      persist: persist,
    );
  }

  // ==========================================================================
  // TEXT SECONDARY
  // ==========================================================================

  Future<void> setTextSecondary(
    Color color, {
    bool persist = true,
  }) async {
    await update(
      (current) =>
          current.copyWith(
        textSecondary: color,
      ),
      persist: persist,
    );
  }

  // ==========================================================================
  // TEXT TERTIARY
  // ==========================================================================

  Future<void> setTextTertiary(
    Color color, {
    bool persist = true,
  }) async {
    await update(
      (current) =>
          current.copyWith(
        textTertiary: color,
      ),
      persist: persist,
    );
  }

  // ==========================================================================
  // TEXT DISABLED
  // ==========================================================================

  Future<void> setTextDisabled(
    Color color, {
    bool persist = true,
  }) async {
    await update(
      (current) =>
          current.copyWith(
        textDisabled: color,
      ),
      persist: persist,
    );
  }

  // ==========================================================================
  // BORDER
  // ==========================================================================

  Future<void> setBorder(
    Color color, {
    bool persist = true,
  }) async {
    await update(
      (current) =>
          current.copyWith(
        border: color,
      ),
      persist: persist,
    );
  }

  // ==========================================================================
  // SUCCESS
  // ==========================================================================

  Future<void> setSuccess(
    Color color, {
    bool persist = true,
  }) async {
    await update(
      (current) =>
          current.copyWith(
        success: color,
      ),
      persist: persist,
    );
  }

  // ==========================================================================
  // WARNING
  // ==========================================================================

  Future<void> setWarning(
    Color color, {
    bool persist = true,
  }) async {
    await update(
      (current) =>
          current.copyWith(
        warning: color,
      ),
      persist: persist,
    );
  }

  // ==========================================================================
  // ERROR
  // ==========================================================================

  Future<void> setError(
    Color color, {
    bool persist = true,
  }) async {
    await update(
      (current) =>
          current.copyWith(
        error: color,
      ),
      persist: persist,
    );
  }

  // ==========================================================================
  // INFO
  // ==========================================================================

  Future<void> setInfo(
    Color color, {
    bool persist = true,
  }) async {
    await update(
      (current) =>
          current.copyWith(
        info: color,
      ),
      persist: persist,
    );
  }

  // ==========================================================================
  // SAUVEGARDE DE TOUTE LA PALETTE
  // ==========================================================================

  Future<void> _saveAllColors() async {
    final GlassColorPalette colors =
        _palette;

    await GlassColorStorage.saveColor(
      'aqua',
      colors.aqua,
    );

    await GlassColorStorage.saveColor(
      'aquaLight',
      colors.aquaLight,
    );

    await GlassColorStorage.saveColor(
      'aquaDark',
      colors.aquaDark,
    );

    await GlassColorStorage.saveColor(
      'classic',
      colors.classic,
    );

    await GlassColorStorage.saveColor(
      'classicLight',
      colors.classicLight,
    );

    await GlassColorStorage.saveColor(
      'classicDark',
      colors.classicDark,
    );

    await GlassColorStorage.saveColor(
      'surface',
      colors.surface,
    );

    await GlassColorStorage.saveColor(
      'surfaceSecondary',
      colors.surfaceSecondary,
    );

    await GlassColorStorage.saveColor(
      'textPrimary',
      colors.textPrimary,
    );

    await GlassColorStorage.saveColor(
      'textSecondary',
      colors.textSecondary,
    );

    await GlassColorStorage.saveColor(
      'textTertiary',
      colors.textTertiary,
    );

    await GlassColorStorage.saveColor(
      'textDisabled',
      colors.textDisabled,
    );

    await GlassColorStorage.saveColor(
      'border',
      colors.border,
    );

    await GlassColorStorage.saveColor(
      'success',
      colors.success,
    );

    await GlassColorStorage.saveColor(
      'warning',
      colors.warning,
    );

    await GlassColorStorage.saveColor(
      'error',
      colors.error,
    );

    await GlassColorStorage.saveColor(
      'info',
      colors.info,
    );
  }

  // ==========================================================================
  // RESET
  // ==========================================================================

  Future<void> reset() async {
    _palette =
        GlassColorPalette.defaults();

    await GlassColorStorage.clear();

    notifyListeners();
  }
}
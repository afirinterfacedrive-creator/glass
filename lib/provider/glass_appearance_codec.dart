
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/provider/glass_theme_state.dart';
import 'package:universal_glass/theme/glass_display_settings.dart';

/// ============================================================================
/// GLASS APPEARANCE CODEC
/// ============================================================================
///
/// Encode et décode l'apparence complète de Universal Glass.
///
/// Le JSON produit par cette classe constitue un preset portable.
///
/// Principes :
/// - aucun accès au stockage ;
/// - aucun accès à SharedPreferences ;
/// - aucun accès au système de fichiers ;
/// - aucune dépendance à l'UI ; 
/// - compatible avec l'import/export multiplateforme ;
/// - format versionné pour permettre les évolutions futures.
///
/// Le codec transforme uniquement :
///
///     GlassThemeState <-> JSON
///
/// Le stockage et les opérations de fichiers sont délégués au
/// GlassAppearanceService.
/// ============================================================================
class GlassAppearanceCodec {
  GlassAppearanceCodec._();

  // ==========================================================================
  // FORMAT
  // ==========================================================================

  /// Type permettant d'identifier un fichier d'apparence Universal Glass.
  static const String formatType = 'universal_glass_appearance';

  /// Version actuelle du format JSON.
  ///
  /// Incrémenter cette valeur uniquement lorsqu'une modification
  /// incompatible du format est introduite.
  static const int formatVersion = 1;

  // ==========================================================================
  // ENCODING
  // ==========================================================================

  /// Convertit un [GlassThemeState] en [Map].
  static Map<String, dynamic> toMap(GlassThemeState state) {
    return <String, dynamic>{
      'type': formatType,
      'version': formatVersion,

      // ----------------------------------------------------------------------
      // THEME
      // ----------------------------------------------------------------------

      'theme': <String, dynamic>{
        'themeMode': state.themeMode.name,
        'glassStyle': state.glassStyle.name,
        'useAquaStyle': state.useAquaStyle,
      },

      // ----------------------------------------------------------------------
      // GRADIENT
      // ----------------------------------------------------------------------

      'gradient': <String, dynamic>{
        'enableGradient': state.enableGradient,
        'aquaGradient': _colorsToInts(state.aquaGradient),
        'classicGradient': _colorsToInts(state.classicGradient),
        'customGradientColors': state.customGradientColors == null
            ? null
            : _colorsToInts(state.customGradientColors!),
        'gradientDensity': state.gradientDensity,
        'gradientOpacity': state.gradientOpacity,
      },

      // ----------------------------------------------------------------------
      // BLUR / NOISE
      // ----------------------------------------------------------------------

      'blurNoise': <String, dynamic>{
        'blur': state.blur,
        'noise': state.noise,
        'enableBlur': state.enableBlur,
        'enableNoise': state.enableNoise,
      },

      // ----------------------------------------------------------------------
      // SURFACE
      // ----------------------------------------------------------------------

      'surface': <String, dynamic>{
        'surfaceOpacity': state.surfaceOpacity,
        'borderRadius': state.borderRadius,
      },

      // ----------------------------------------------------------------------
      // BORDER
      // ----------------------------------------------------------------------

      'border': <String, dynamic>{
        'enableBorder': state.enableBorder,
        'borderOpacity': state.borderOpacity,
        'borderWidth': state.borderWidth,
      },

      // ----------------------------------------------------------------------
      // GLOW
      // ----------------------------------------------------------------------

      'glow': <String, dynamic>{
        'enableGlow': state.enableGlow,
        'glowOpacity': state.glowOpacity,
        'glowBlur': state.glowBlur,
      },

      // ----------------------------------------------------------------------
      // HOVER
      // ----------------------------------------------------------------------

      'hover': <String, dynamic>{
        'enableHover': state.enableHover,
        'hoverLift': state.hoverLift,
      },

      // ----------------------------------------------------------------------
      // SHADOW
      // ----------------------------------------------------------------------

      'shadow': <String, dynamic>{
        'enableShadow': state.enableShadow,
        'shadowOpacity': state.shadowOpacity,
        'shadowBlur': state.shadowBlur,
        'shadowOffsetY': state.shadowOffsetY,
      },

      // ----------------------------------------------------------------------
      // BREAKER
      // ----------------------------------------------------------------------

      'breaker': <String, dynamic>{
        'breakerOn': state.breakerOn,
      },

      // ----------------------------------------------------------------------
      // DISPLAY
      // ----------------------------------------------------------------------

      'display': _displayToMap(state.display),
    };
  }

  /// Convertit un [GlassThemeState] en JSON.
  ///
  /// [pretty] permet d'obtenir un JSON lisible avec indentation.
  static String toJson(
    GlassThemeState state, {
    bool pretty = true,
  }) {
    final Map<String, dynamic> data = toMap(state);

    if (!pretty) {
      return jsonEncode(data);
    }

    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(data);
  }

  // ==========================================================================
  // DECODING
  // ==========================================================================

  /// Convertit une [Map] JSON en [GlassThemeState].
  ///
  /// Les propriétés absentes utilisent les valeurs par défaut du
  /// [GlassThemeState].
  ///
  /// Les propriétés inconnues sont ignorées afin de conserver une
  /// compatibilité avec les évolutions futures.
  static GlassThemeState fromMap(Map<String, dynamic> map) {
    _validateFormat(map);

    final Map<String, dynamic> theme = _mapOrEmpty(map['theme']);
    final Map<String, dynamic> gradient = _mapOrEmpty(map['gradient']);
    final Map<String, dynamic> blurNoise = _mapOrEmpty(map['blurNoise']);
    final Map<String, dynamic> surface = _mapOrEmpty(map['surface']);
    final Map<String, dynamic> border = _mapOrEmpty(map['border']);
    final Map<String, dynamic> glow = _mapOrEmpty(map['glow']);
    final Map<String, dynamic> hover = _mapOrEmpty(map['hover']);
    final Map<String, dynamic> shadow = _mapOrEmpty(map['shadow']);
    final Map<String, dynamic> breaker = _mapOrEmpty(map['breaker']);
    final Map<String, dynamic> display = _mapOrEmpty(map['display']);

    // ------------------------------------------------------------------------
    // DEFAULT STATE
    // ------------------------------------------------------------------------

    const GlassThemeState defaults = GlassThemeState();

    // ------------------------------------------------------------------------
    // COLORS
    // ------------------------------------------------------------------------

    final List<Color> aquaGradient = _intsToColors(
      gradient['aquaGradient'],
      fallback: defaults.aquaGradient,
    );

    final List<Color> classicGradient = _intsToColors(
      gradient['classicGradient'],
      fallback: defaults.classicGradient,
    );

    final List<Color>? customGradientColors =
        _nullableIntsToColors(
      gradient['customGradientColors'],
    );

    // ------------------------------------------------------------------------
    // ENUMS
    // ------------------------------------------------------------------------

    final AppThemeMode themeMode = _enumFromName(
      AppThemeMode.values,
      theme['themeMode'],
      defaults.themeMode,
    );

    final GlassStyle glassStyle = _enumFromName(
      GlassStyle.values,
      theme['glassStyle'],
      defaults.glassStyle,
    );

    // ------------------------------------------------------------------------
    // DISPLAY
    // ------------------------------------------------------------------------

    final GlassDisplaySettings displaySettings = _displayFromMap(
      display,
      fallback: defaults.display,
    );

    // ------------------------------------------------------------------------
    // STATE
    // ------------------------------------------------------------------------

    return GlassThemeState(
      themeMode: themeMode,
      glassStyle: glassStyle,
      useAquaStyle: _boolValue(
        theme['useAquaStyle'],
        defaults.useAquaStyle,
      ),

      enableGradient: _boolValue(
        gradient['enableGradient'],
        defaults.enableGradient,
      ),
      aquaGradient: aquaGradient,
      classicGradient: classicGradient,
      customGradientColors: customGradientColors,
      gradientDensity: _doubleValue(
        gradient['gradientDensity'],
        defaults.gradientDensity,
      ),
      gradientOpacity: _doubleValue(
        gradient['gradientOpacity'],
        defaults.gradientOpacity,
      ),

      blur: _doubleValue(
        blurNoise['blur'],
        defaults.blur,
      ),
      noise: _doubleValue(
        blurNoise['noise'],
        defaults.noise,
      ),
      enableBlur: _boolValue(
        blurNoise['enableBlur'],
        defaults.enableBlur,
      ),
      enableNoise: _boolValue(
        blurNoise['enableNoise'],
        defaults.enableNoise,
      ),

      surfaceOpacity: _doubleValue(
        surface['surfaceOpacity'],
        defaults.surfaceOpacity,
      ),
      borderRadius: _doubleValue(
        surface['borderRadius'],
        defaults.borderRadius,
      ),

      enableBorder: _boolValue(
        border['enableBorder'],
        defaults.enableBorder,
      ),
      borderOpacity: _doubleValue(
        border['borderOpacity'],
        defaults.borderOpacity,
      ),
      borderWidth: _doubleValue(
        border['borderWidth'],
        defaults.borderWidth,
      ),

      enableGlow: _boolValue(
        glow['enableGlow'],
        defaults.enableGlow,
      ),
      glowOpacity: _doubleValue(
        glow['glowOpacity'],
        defaults.glowOpacity,
      ),
      glowBlur: _doubleValue(
        glow['glowBlur'],
        defaults.glowBlur,
      ),

      enableHover: _boolValue(
        hover['enableHover'],
        defaults.enableHover,
      ),
      hoverLift: _doubleValue(
        hover['hoverLift'],
        defaults.hoverLift,
      ),

      enableShadow: _boolValue(
        shadow['enableShadow'],
        defaults.enableShadow,
      ),
      shadowOpacity: _doubleValue(
        shadow['shadowOpacity'],
        defaults.shadowOpacity,
      ),
      shadowBlur: _doubleValue(
        shadow['shadowBlur'],
        defaults.shadowBlur,
      ),
      shadowOffsetY: _doubleValue(
        shadow['shadowOffsetY'],
        defaults.shadowOffsetY,
      ),

      breakerOn: _boolValue(
        breaker['breakerOn'],
        defaults.breakerOn,
      ),

      display: displaySettings,
    );
  }

  /// Convertit une chaîne JSON en [GlassThemeState].
  static GlassThemeState fromJson(String jsonString) {
    if (jsonString.trim().isEmpty) {
      throw const FormatException(
        'Le fichier Appearance est vide.',
      );
    }

    final dynamic decoded;

    try {
      decoded = jsonDecode(jsonString);
    } on FormatException catch (e) {
      throw FormatException(
        'JSON Appearance invalide : ${e.message}',
      );
    }

    if (decoded is! Map) {
      throw const FormatException(
        'Le fichier Appearance doit contenir un objet JSON.',
      );
    }

    return fromMap(
      Map<String, dynamic>.from(decoded),
    );
  }

  // ==========================================================================
  // FORMAT VALIDATION
  // ==========================================================================

  static void _validateFormat(
    Map<String, dynamic> map,
  ) {
    final dynamic type = map['type'];

    if (type != null && type != formatType) {
      throw FormatException(
        'Type de fichier invalide : "$type". '
        'Type attendu : "$formatType".',
      );
    }

    final dynamic version = map['version'];

    if (version == null) {
      // Ancien format éventuel : on accepte.
      return;
    }

    if (version is! num) {
      throw const FormatException(
        'La version du fichier Appearance est invalide.',
      );
    }

    // Une version doit toujours être entière.
    if (version.toDouble() != version.toInt().toDouble()) {
      throw FormatException(
        'Version Appearance invalide : $version.',
      );
    }

    final int versionNumber = version.toInt();

    if (versionNumber > formatVersion) {
      throw FormatException(
        'Version Appearance $versionNumber non supportée. '
        'Version maximale supportée : $formatVersion.',
      );
    }

    if (versionNumber < 1) {
      throw FormatException(
        'Version Appearance invalide : $versionNumber.',
      );
    }
  }

  // ==========================================================================
  // DISPLAY
  // ==========================================================================

  static Map<String, dynamic> _displayToMap(
    GlassDisplaySettings settings,
  ) {
    return <String, dynamic>{
      'maxWidth': settings.maxWidth,
      'zoom': settings.zoom,
      'desktopPadding': settings.desktopPadding,
      'tabletPadding': settings.tabletPadding,
      'mobilePadding': settings.mobilePadding,
      'smallMobilePadding': settings.smallMobilePadding,
      'tabletBreakpoint': settings.tabletBreakpoint,
      'desktopBreakpoint': settings.desktopBreakpoint,
      'density': settings.density.name,
    };
  }

  static GlassDisplaySettings _displayFromMap(
    Map<String, dynamic> map, {
    required GlassDisplaySettings fallback,
  }) {
    final GlassDensity density = _enumFromName(
      GlassDensity.values,
      map['density'],
      fallback.density,
    );

    final GlassDisplaySettings result = GlassDisplaySettings(
      maxWidth: _doubleValue(
        map['maxWidth'],
        fallback.maxWidth,
      ),
      zoom: _doubleValue(
        map['zoom'],
        fallback.zoom,
      ),
      desktopPadding: _doubleValue(
        map['desktopPadding'],
        fallback.desktopPadding,
      ),
      tabletPadding: _doubleValue(
        map['tabletPadding'],
        fallback.tabletPadding,
      ),
      mobilePadding: _doubleValue(
        map['mobilePadding'],
        fallback.mobilePadding,
      ),
      smallMobilePadding: _doubleValue(
        map['smallMobilePadding'],
        fallback.smallMobilePadding,
      ),
      tabletBreakpoint: _doubleValue(
        map['tabletBreakpoint'],
        fallback.tabletBreakpoint,
      ),
      desktopBreakpoint: _doubleValue(
        map['desktopBreakpoint'],
        fallback.desktopBreakpoint,
      ),
      density: density,
    );

    return result.normalized();
  }

  // ==========================================================================
  // COLORS
  // ==========================================================================

  static List<int> _colorsToInts(
    List<Color> colors,
  ) {
    return colors
        .map((Color color) => color.toARGB32())
        .toList(growable: false);
  }

  static List<Color> _intsToColors(
    dynamic value, {
    required List<Color> fallback,
  }) {
    if (value is! List) {
      return List<Color>.unmodifiable(fallback);
    }

    final List<Color> result = <Color>[];

    for (final dynamic item in value) {
      final int? argb = _intValue(item);

      if (argb == null) {
        continue;
      }

      result.add(Color(argb));
    }

    if (result.isEmpty) {
      return List<Color>.unmodifiable(fallback);
    }

    return List<Color>.unmodifiable(result);
  }

  static List<Color>? _nullableIntsToColors(
    dynamic value,
  ) {
    if (value == null || value is! List) {
      return null;
    }

    final List<Color> result = <Color>[];

    for (final dynamic item in value) {
      final int? argb = _intValue(item);

      if (argb == null) {
        continue;
      }

      result.add(Color(argb));
    }

    if (result.isEmpty) {
      return null;
    }

    return List<Color>.unmodifiable(result);
  }

  // ==========================================================================
  // GENERIC HELPERS
  // ==========================================================================

  static Map<String, dynamic> _mapOrEmpty(
    dynamic value,
  ) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return <String, dynamic>{};
  }

  static bool _boolValue(
    dynamic value,
    bool fallback,
  ) {
    if (value is bool) {
      return value;
    }

    return fallback;
  }

  static double _doubleValue(
    dynamic value,
    double fallback,
  ) {
    if (value is num) {
      final double result = value.toDouble();

      if (result.isFinite) {
        return result;
      }
    }

    return fallback;
  }

  static int? _intValue(
    dynamic value,
  ) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      final double number = value.toDouble();

      if (!number.isFinite) {
        return null;
      }

      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }

  static T _enumFromName<T extends Enum>(
    List<T> values,
    dynamic value,
    T fallback,
  ) {
    if (value is! String) {
      return fallback;
    }

    for (final T item in values) {
      if (item.name == value) {
        return item;
      }
    }

    return fallback;
  }
}

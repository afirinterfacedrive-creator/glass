import 'dart:convert';

import 'package:universal_glass/glass.dart';

import 'appearance_profiles.dart';
import 'appearance_settings.dart';

/// ============================================================================
/// APPEARANCE PROFILES DOCUMENT
/// ============================================================================
///
/// Représente le fichier d'import/export des quatre profils globaux.
///
/// Le mode actif est volontairement stocké dans le document mais reste
/// indépendant de [AppearanceProfiles].
class AppearanceProfilesDocument {
  final AppearanceProfiles profiles;
  final AppThemeMode activeMode;

  const AppearanceProfilesDocument({
    required this.profiles,
    required this.activeMode,
  });
}

/// ============================================================================
/// APPEARANCE PROFILES CODEC
/// ============================================================================
///
/// Codec dédié à l'import/export des profils d'apparence globaux.
///
/// IMPORTANT :
/// - Ne dépend que du dossier example.
/// - N'est jamais utilisé par le package Universal Glass.
/// - N'exporte PAS les réglages spécifiques aux composants.
///
class AppearanceProfilesCodec {
  AppearanceProfilesCodec._();

  static const String type =
      'universal_glass_appearance_profiles';

  static const int version = 1;

  // ==========================================================================
  // ENCODE
  // ==========================================================================

  static String encode({
    required AppearanceProfiles profiles,
    required AppThemeMode activeMode,
    bool pretty = true,
  }) {
    final Map<String, dynamic> document = toMap(
      profiles: profiles,
      activeMode: activeMode,
    );

    if (pretty) {
      const JsonEncoder encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(document);
    }

    return jsonEncode(document);
  }

  // ==========================================================================
  // TO MAP
  // ==========================================================================

  static Map<String, dynamic> toMap({
    required AppearanceProfiles profiles,
    required AppThemeMode activeMode,
  }) {
    return <String, dynamic>{
      'type': type,
      'version': version,
      'activeMode': activeMode.name,
      'profiles': <String, dynamic>{
        'aqua': _settingsToMap(profiles.aqua),
        'classic': _settingsToMap(profiles.classic),
        'light': _settingsToMap(profiles.light),
        'dark': _settingsToMap(profiles.dark),
      },
    };
  }

  // ==========================================================================
  // DECODE
  // ==========================================================================

  static AppearanceProfilesDocument decode({
    required String source,
    required AppearanceProfiles fallback,
    AppThemeMode fallbackActiveMode = AppThemeMode.aqua,
  }) {
    try {
      final dynamic decoded = jsonDecode(source);

      if (decoded is! Map) {
        return AppearanceProfilesDocument(
          profiles: fallback,
          activeMode: fallbackActiveMode,
        );
      }

      return fromMap(
        Map<String, dynamic>.from(decoded),
        fallback: fallback,
        fallbackActiveMode: fallbackActiveMode,
      );
    } catch (_) {
      return AppearanceProfilesDocument(
        profiles: fallback,
        activeMode: fallbackActiveMode,
      );
    }
  }

  // ==========================================================================
  // FROM MAP
  // ==========================================================================

  static AppearanceProfilesDocument fromMap(
    Map<String, dynamic> json, {
    required AppearanceProfiles fallback,
    AppThemeMode fallbackActiveMode = AppThemeMode.aqua,
  }) {
    final dynamic profilesValue = json['profiles'];

    if (profilesValue is! Map) {
      return AppearanceProfilesDocument(
        profiles: fallback,
        activeMode: fallbackActiveMode,
      );
    }

    final Map<String, dynamic> profilesJson =
        Map<String, dynamic>.from(profilesValue);

    final AppearanceProfiles profiles = AppearanceProfiles(
      aqua: _readProfile(
        profilesJson['aqua'],
        fallback.aqua,
        AppThemeMode.aqua,
      ),
      classic: _readProfile(
        profilesJson['classic'],
        fallback.classic,
        AppThemeMode.classic,
      ),
      light: _readProfile(
        profilesJson['light'],
        fallback.light,
        AppThemeMode.light,
      ),
      dark: _readProfile(
        profilesJson['dark'],
        fallback.dark,
        AppThemeMode.dark,
      ),
    );

    final AppThemeMode activeMode = _readActiveMode(
      json['activeMode'],
      fallbackActiveMode,
    );

    return AppearanceProfilesDocument(
      profiles: profiles,
      activeMode: activeMode,
    );
  }

  // ==========================================================================
  // PROFILE → MAP
  // ==========================================================================

  /// Sérialise uniquement les paramètres globaux.
  ///
  /// Les paramètres spécifiques :
  /// - appBar
  /// - component
  /// - input
  /// - form
  /// - toast
  /// - tooltip
  ///
  /// sont volontairement exclus.
  static Map<String, dynamic> _settingsToMap(
    AppearanceSettings settings,
  ) {
    return <String, dynamic>{
      'themeMode': settings.themeMode,
      'glassStyle': settings.glassStyle,

      // COLORS
      'aquaColors': List<int>.from(settings.aquaColors),
      'classicColors': List<int>.from(settings.classicColors),

      // BLUR
      'enableBlur': settings.enableBlur,
      'blur': settings.blur,

      // NOISE
      'enableNoise': settings.enableNoise,
      'noise': settings.noise,

      // GRADIENT
      'enableGradient': settings.enableGradient,
      'gradientOpacity': settings.gradientOpacity,
      'gradientDensity': settings.gradientDensity,

      // SURFACE
      'surfaceOpacity': settings.surfaceOpacity,
      'borderRadius': settings.borderRadius,

      // BORDER
      'enableBorder': settings.enableBorder,
      'borderOpacity': settings.borderOpacity,
      'borderWidth': settings.borderWidth,

      // GLOW
      'enableGlow': settings.enableGlow,
      'glowOpacity': settings.glowOpacity,
      'glowBlur': settings.glowBlur,

      // HOVER
      'enableHover': settings.enableHover,
      'hoverLift': settings.hoverLift,

      // SHADOW
      'enableShadow': settings.enableShadow,
      'shadowOpacity': settings.shadowOpacity,
      'shadowBlur': settings.shadowBlur,
      'shadowOffsetY': settings.shadowOffsetY,
    };
  }

  // ==========================================================================
  // MAP → PROFILE
  // ==========================================================================

  static AppearanceSettings _readProfile(
    dynamic value,
    AppearanceSettings fallback,
    AppThemeMode expectedMode,
  ) {
    if (value is! Map) {
      return fallback;
    }

    try {
      final Map<String, dynamic> json =
          Map<String, dynamic>.from(value);

      final AppearanceSettings decoded =
          AppearanceSettings.fromJson(json);

      // Le mode du profil est déterminé par sa position dans le document.
      //
      // Cela évite qu'un JSON mal formé puisse, par exemple, transformer
      // le profil "dark" en profil "aqua".
      return decoded.copyWith(
        themeMode: expectedMode.name,
      );
    } catch (_) {
      return fallback;
    }
  }

  // ==========================================================================
  // ACTIVE MODE
  // ==========================================================================

  static AppThemeMode _readActiveMode(
    dynamic value,
    AppThemeMode fallback,
  ) {
    if (value is! String) {
      return fallback;
    }

    switch (value.toLowerCase()) {
      case 'aqua':
        return AppThemeMode.aqua;

      case 'classic':
        return AppThemeMode.classic;

      case 'light':
        return AppThemeMode.light;

      case 'dark':
        return AppThemeMode.dark;

      // SYSTEM n'a pas de profil propre.
      case 'system':
      default:
        return fallback;
    }
  }
}
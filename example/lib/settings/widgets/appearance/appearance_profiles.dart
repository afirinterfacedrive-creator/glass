import 'dart:convert';

import 'package:universal_glass/glass.dart';

import 'appearance_settings.dart';

/// ============================================================================
/// APPEARANCE PROFILES
/// ============================================================================
///
/// Conteneur des quatre apparences personnalisables de Universal Glass.
///
/// Chaque apparence possède sa propre instance de [AppearanceSettings].
///
/// Profils disponibles :
/// - Aqua
/// - Classic
/// - Light
/// - Dark
///
/// [AppThemeMode.system] ne possède pas de profil propre.
/// Il utilise dynamiquement le profil correspondant au thème système.
///
/// Cette classe est volontairement immutable.
/// Toute modification retourne une nouvelle instance.
class AppearanceProfiles {
  // ==========================================================================
  // PROFILS
  // ==========================================================================

  final AppearanceSettings aqua;
  final AppearanceSettings classic;
  final AppearanceSettings light;
  final AppearanceSettings dark;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const AppearanceProfiles({
    required this.aqua,
    required this.classic,
    required this.light,
    required this.dark,
  });

  // ==========================================================================
  // PROFIL PAR MODE
  // ==========================================================================

  /// Retourne les réglages correspondant au [mode].
  ///
  /// [AppThemeMode.system] ne possède pas de profil propre.
  /// Aqua est utilisé comme profil de secours.
  AppearanceSettings forMode(
    AppThemeMode mode,
  ) {
    switch (mode) {
      case AppThemeMode.aqua:
        return aqua;

      case AppThemeMode.classic:
        return classic;

      case AppThemeMode.light:
        return light;

      case AppThemeMode.dark:
        return dark;

      case AppThemeMode.system:
        return aqua;
    }
  }

  // ==========================================================================
  // REMPLACER UN PROFIL
  // ==========================================================================

  /// Retourne une nouvelle instance avec le profil [mode] remplacé.
  ///
  /// Les trois autres profils restent inchangés.
  ///
  /// Le mode [AppThemeMode.system] ne possède pas de profil propre :
  /// aucune modification n'est donc effectuée dans ce cas.
  AppearanceProfiles updateMode(
    AppThemeMode mode,
    AppearanceSettings settings,
  ) {
    switch (mode) {
      case AppThemeMode.aqua:
        return copyWith(
          aqua: settings,
        );

      case AppThemeMode.classic:
        return copyWith(
          classic: settings,
        );

      case AppThemeMode.light:
        return copyWith(
          light: settings,
        );

      case AppThemeMode.dark:
        return copyWith(
          dark: settings,
        );

      case AppThemeMode.system:
        return this;
    }
  }

  // ==========================================================================
  // COPY WITH
  // ==========================================================================

  AppearanceProfiles copyWith({
    AppearanceSettings? aqua,
    AppearanceSettings? classic,
    AppearanceSettings? light,
    AppearanceSettings? dark,
  }) {
    return AppearanceProfiles(
      aqua: aqua ?? this.aqua,
      classic: classic ?? this.classic,
      light: light ?? this.light,
      dark: dark ?? this.dark,
    );
  }

  // ==========================================================================
  // JSON
  // ==========================================================================

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'aqua': aqua.toJson(),
      'classic': classic.toJson(),
      'light': light.toJson(),
      'dark': dark.toJson(),
    };
  }

  // ==========================================================================
  // ENCODE
  // ==========================================================================

  String encode() {
    return jsonEncode(
      toJson(),
    );
  }

  // ==========================================================================
  // DECODE
  // ==========================================================================

  static AppearanceProfiles decode(
    String source, {
    required AppearanceProfiles fallback,
  }) {
    try {
      final dynamic decoded = jsonDecode(
        source,
      );

      if (decoded is! Map) {
        return fallback;
      }

      return fromJson(
        Map<String, dynamic>.from(decoded),
        fallback: fallback,
      );
    } catch (_) {
      return fallback;
    }
  }

  // ==========================================================================
  // FROM JSON
  // ==========================================================================

  static AppearanceProfiles fromJson(
    Map<String, dynamic> json, {
    required AppearanceProfiles fallback,
  }) {
    return AppearanceProfiles(
      aqua: _readProfile(
        json['aqua'],
        fallback.aqua,
      ),
      classic: _readProfile(
        json['classic'],
        fallback.classic,
      ),
      light: _readProfile(
        json['light'],
        fallback.light,
      ),
      dark: _readProfile(
        json['dark'],
        fallback.dark,
      ),
    );
  }

  // ==========================================================================
  // PROFILE READER
  // ==========================================================================

  static AppearanceSettings _readProfile(
    dynamic value,
    AppearanceSettings fallback,
  ) {
    if (value is! Map) {
      return fallback;
    }

    try {
      return AppearanceSettings.fromJson(
        Map<String, dynamic>.from(value),
      );
    } catch (_) {
      return fallback;
    }
  }

  // ==========================================================================
  // DEBUG
  // ==========================================================================

  @override
  String toString() {
    return 'AppearanceProfiles('
        'aqua: $aqua, '
        'classic: $classic, '
        'light: $light, '
        'dark: $dark'
        ')';
  }
}
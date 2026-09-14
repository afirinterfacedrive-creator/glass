import 'package:flutter/foundation.dart';
import 'package:universal_glass/glass.dart';

/// Réglages visuels des Toast Glass.
/// Cette classe ne contient aucune logique d'application.
/// Elle représente uniquement la configuration visuelle et
/// comportementale d'un Toast.
@immutable
class AppearanceToastSettings {
  // ===========================================================================
  // ENABLED
  // ===========================================================================
  final bool enabled;
  // ===========================================================================
  // BLUR
  // ===========================================================================
  final bool enableBlur;
  final double blur;
  // ===========================================================================
  // BACKGROUND
  // ===========================================================================
  final double backgroundOpacity;
  // ===========================================================================
  // BORDER
  // ===========================================================================
  final bool enableBorder;
  final double borderOpacity;
  final double borderWidth;
  final double borderRadius;
  // ===========================================================================
  // SHADOW
  // ===========================================================================
  final bool enableShadow;
  final double shadowOpacity;
  final double shadowBlur;
  final double shadowOffsetY;
  // ===========================================================================
  // PADDING
  // ===========================================================================
  final double horizontalPadding;
  final double verticalPadding;
  // ===========================================================================
  // TOAST BEHAVIOR
  // ===========================================================================
  final double maxWidth;
  final double duration;
  // ===========================================================================
  // CONSTRUCTOR
  // ===========================================================================
  const AppearanceToastSettings({
    this.enabled = AppConstants.toastDefaultEnabled,
    this.enableBlur = AppConstants.toastDefaultEnableBlur,
    this.blur = AppConstants.toastDefaultBlur,
    this.backgroundOpacity = AppConstants.toastDefaultBackgroundOpacity,
    this.enableBorder = AppConstants.toastDefaultEnableBorder,
    this.borderOpacity = AppConstants.toastDefaultBorderOpacity,
    this.borderWidth = AppConstants.toastDefaultBorderWidth,
    this.borderRadius = AppConstants.toastDefaultBorderRadius,
    this.enableShadow = AppConstants.toastDefaultEnableShadow,
    this.shadowOpacity = AppConstants.toastDefaultShadowOpacity,
    this.shadowBlur = AppConstants.toastDefaultShadowBlur,
    this.shadowOffsetY = AppConstants.toastDefaultShadowOffsetY,
    this.horizontalPadding = AppConstants.toastDefaultHorizontalPadding,
    this.verticalPadding = AppConstants.toastDefaultVerticalPadding,
    this.maxWidth = AppConstants.toastDefaultMaxWidth,
    this.duration = AppConstants.toastDefaultDuration,
  });
  // ===========================================================================
  // COPY WITH
  // ===========================================================================
  AppearanceToastSettings copyWith({
    bool? enabled,
    bool? enableBlur,
    double? blur,
    double? backgroundOpacity,
    bool? enableBorder,
    double? borderOpacity,
    double? borderWidth,
    double? borderRadius,
    bool? enableShadow,
    double? shadowOpacity,
    double? shadowBlur,
    double? shadowOffsetY,
    double? horizontalPadding,
    double? verticalPadding,
    double? maxWidth,
    double? duration,
  }) {
    return AppearanceToastSettings(
      enabled: enabled ?? this.enabled,
      enableBlur: enableBlur ?? this.enableBlur,
      blur: blur ?? this.blur,
      backgroundOpacity: backgroundOpacity ?? this.backgroundOpacity,
      enableBorder: enableBorder ?? this.enableBorder,
      borderOpacity: borderOpacity ?? this.borderOpacity,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      enableShadow: enableShadow ?? this.enableShadow,
      shadowOpacity: shadowOpacity ?? this.shadowOpacity,
      shadowBlur: shadowBlur ?? this.shadowBlur,
      shadowOffsetY: shadowOffsetY ?? this.shadowOffsetY,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      verticalPadding: verticalPadding ?? this.verticalPadding,
      maxWidth: maxWidth ?? this.maxWidth,
      duration: duration ?? this.duration,
    );
  }

  // ===========================================================================
  // EFFECTIVE VALUES
  // ===========================================================================
  /// Blur effectivement appliqué au Toast.
  double get effectiveBlur => !enabled || !enableBlur ? 0.0 : blur;

  /// Opacité du background effectivement appliquée.
  double get effectiveBackgroundOpacity => !enabled ? 0.0 : backgroundOpacity;

  /// Opacité de la bordure effectivement appliquée.
  double get effectiveBorderOpacity =>
      !enabled || !enableBorder ? 0.0 : borderOpacity;

  /// Épaisseur de la bordure effectivement appliquée.
  double get effectiveBorderWidth =>
      !enabled || !enableBorder ? 0.0 : borderWidth;

  /// Rayon effectivement appliqué au Toast.
  double get effectiveBorderRadius => !enabled ? 0.0 : borderRadius;

  /// Opacité de l'ombre effectivement appliquée.
  double get effectiveShadowOpacity =>
      !enabled || !enableShadow ? 0.0 : shadowOpacity;

  /// Blur de l'ombre effectivement appliqué.
  double get effectiveShadowBlur =>
      !enabled || !enableShadow ? 0.0 : shadowBlur;

  /// Décalage vertical de l'ombre effectivement appliqué.
  double get effectiveShadowOffsetY =>
      !enabled || !enableShadow ? 0.0 : shadowOffsetY;

  /// Padding horizontal effectivement appliqué.
  double get effectiveHorizontalPadding => !enabled ? 0.0 : horizontalPadding;

  /// Padding vertical effectivement appliqué.
  double get effectiveVerticalPadding => !enabled ? 0.0 : verticalPadding;

  /// Largeur maximale effectivement utilisable par le Toast.
  /// Une largeur minimale est conservée lorsque le Toast est désactivé.
  double get effectiveMaxWidth =>
      !enabled ? AppConstants.minToastMaxWidth : maxWidth;

  /// Durée effectivement utilisée par le Toast.
  /// Une durée minimale est conservée lorsque le Toast est désactivé.
  double get effectiveDuration =>
      !enabled ? AppConstants.minToastDuration : duration;
  // ===========================================================================
  // JSON
  // ===========================================================================
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'enabled': enabled,
      'enableBlur': enableBlur,
      'blur': blur,
      'backgroundOpacity': backgroundOpacity,
      'enableBorder': enableBorder,
      'borderOpacity': borderOpacity,
      'borderWidth': borderWidth,
      'borderRadius': borderRadius,
      'enableShadow': enableShadow,
      'shadowOpacity': shadowOpacity,
      'shadowBlur': shadowBlur,
      'shadowOffsetY': shadowOffsetY,
      'horizontalPadding': horizontalPadding,
      'verticalPadding': verticalPadding,
      'maxWidth': maxWidth,
      'duration': duration,
    };
  }

  factory AppearanceToastSettings.fromJson(Map<String, dynamic> json) {
    return AppearanceToastSettings(
      enabled: _readBool(json, 'enabled', AppConstants.toastDefaultEnabled),
      enableBlur: _readBool(
        json,
        'enableBlur',
        AppConstants.toastDefaultEnableBlur,
      ),
      blur: _readDouble(json, 'blur', AppConstants.toastDefaultBlur),
      backgroundOpacity: _readDouble(
        json,
        'backgroundOpacity',
        AppConstants.toastDefaultBackgroundOpacity,
      ),
      enableBorder: _readBool(
        json,
        'enableBorder',
        AppConstants.toastDefaultEnableBorder,
      ),
      borderOpacity: _readDouble(
        json,
        'borderOpacity',
        AppConstants.toastDefaultBorderOpacity,
      ),
      borderWidth: _readDouble(
        json,
        'borderWidth',
        AppConstants.toastDefaultBorderWidth,
      ),
      borderRadius: _readDouble(
        json,
        'borderRadius',
        AppConstants.toastDefaultBorderRadius,
      ),
      enableShadow: _readBool(
        json,
        'enableShadow',
        AppConstants.toastDefaultEnableShadow,
      ),
      shadowOpacity: _readDouble(
        json,
        'shadowOpacity',
        AppConstants.toastDefaultShadowOpacity,
      ),
      shadowBlur: _readDouble(
        json,
        'shadowBlur',
        AppConstants.toastDefaultShadowBlur,
      ),
      shadowOffsetY: _readDouble(
        json,
        'shadowOffsetY',
        AppConstants.toastDefaultShadowOffsetY,
      ),
      horizontalPadding: _readDouble(
        json,
        'horizontalPadding',
        AppConstants.toastDefaultHorizontalPadding,
      ),
      verticalPadding: _readDouble(
        json,
        'verticalPadding',
        AppConstants.toastDefaultVerticalPadding,
      ),
      maxWidth: _readDouble(
        json,
        'maxWidth',
        AppConstants.toastDefaultMaxWidth,
      ),
      duration: _readDouble(
        json,
        'duration',
        AppConstants.toastDefaultDuration,
      ),
    );
  }
  // ===========================================================================
  // JSON HELPERS
  // ===========================================================================
  static bool _readBool(Map<String, dynamic> json, String key, bool fallback) {
    final dynamic value = json[key];
    return value is bool ? value : fallback;
  }

  static double _readDouble(
    Map<String, dynamic> json,
    String key,
    double fallback,
  ) {
    final dynamic value = json[key];
    return value is num ? value.toDouble() : fallback;
  }
}

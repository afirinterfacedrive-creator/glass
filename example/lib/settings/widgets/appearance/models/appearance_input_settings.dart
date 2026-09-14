import 'package:flutter/foundation.dart';
import 'package:universal_glass/glass.dart';

/// Réglages spécifiques aux champs de saisie Glass.
/// Utilisé notamment pour :
/// - UniversalGlassTextField
/// - UniversalGlassPhoneInput
/// - autres champs de formulaire
/// Cette classe ne contient aucune logique d'application.
/// Elle représente uniquement la configuration visuelle et spatiale
/// d'un champ de saisie.
@immutable
class AppearanceInputSettings {
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
  // HOVER
  // ===========================================================================
  final bool enableHover;
  final double hoverLift;
  // ===========================================================================
  // FIELD SIZE
  // ===========================================================================
  final double fieldHeight;
  final double horizontalPadding;
  final double verticalPadding;
  // ===========================================================================
  // CONSTRUCTOR
  // ===========================================================================
  const AppearanceInputSettings({
    this.enabled = AppConstants.inputDefaultEnabled,
    this.enableBlur = AppConstants.inputDefaultEnableBlur,
    this.blur = AppConstants.inputDefaultBlur,
    this.backgroundOpacity = AppConstants.inputDefaultBackgroundOpacity,
    this.enableBorder = AppConstants.inputDefaultEnableBorder,
    this.borderOpacity = AppConstants.inputDefaultBorderOpacity,
    this.borderWidth = AppConstants.inputDefaultBorderWidth,
    this.borderRadius = AppConstants.inputDefaultBorderRadius,
    this.enableShadow = AppConstants.inputDefaultEnableShadow,
    this.shadowOpacity = AppConstants.inputDefaultShadowOpacity,
    this.shadowBlur = AppConstants.inputDefaultShadowBlur,
    this.shadowOffsetY = AppConstants.inputDefaultShadowOffsetY,
    this.enableHover = AppConstants.inputDefaultEnableHover,
    this.hoverLift = AppConstants.inputDefaultHoverLift,
    this.fieldHeight = AppConstants.inputDefaultFieldHeight,
    this.horizontalPadding = AppConstants.inputDefaultHorizontalPadding,
    this.verticalPadding = AppConstants.inputDefaultVerticalPadding,
  });
  // ===========================================================================
  // COPY WITH
  // ===========================================================================
  AppearanceInputSettings copyWith({
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
    bool? enableHover,
    double? hoverLift,
    double? fieldHeight,
    double? horizontalPadding,
    double? verticalPadding,
  }) {
    return AppearanceInputSettings(
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
      enableHover: enableHover ?? this.enableHover,
      hoverLift: hoverLift ?? this.hoverLift,
      fieldHeight: fieldHeight ?? this.fieldHeight,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      verticalPadding: verticalPadding ?? this.verticalPadding,
    );
  }

  // ===========================================================================
  // EFFECTIVE VALUES
  // ===========================================================================
  /// Blur effectivement appliqué au champ.
  double get effectiveBlur => !enabled || !enableBlur ? 0.0 : blur;

  /// Opacité du background effectivement appliquée.
  double get effectiveBackgroundOpacity => !enabled ? 0.0 : backgroundOpacity;

  /// Opacité de la bordure effectivement appliquée.
  double get effectiveBorderOpacity =>
      !enabled || !enableBorder ? 0.0 : borderOpacity;

  /// Épaisseur de la bordure effectivement appliquée.
  double get effectiveBorderWidth =>
      !enabled || !enableBorder ? 0.0 : borderWidth;

  /// Rayon effectivement appliqué au champ.
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

  /// Élévation au survol effectivement appliquée.
  double get effectiveHoverLift => !enabled || !enableHover ? 0.0 : hoverLift;

  /// Hauteur effectivement appliquée au champ.
  /// Une hauteur minimale est conservée lorsque le champ est désactivé
  /// afin d'éviter de produire une hauteur nulle ou invalide.
  double get effectiveFieldHeight =>
      !enabled ? AppConstants.minFieldHeight : fieldHeight;

  /// Padding horizontal effectivement appliqué.
  double get effectiveHorizontalPadding => !enabled ? 0.0 : horizontalPadding;

  /// Padding vertical effectivement appliqué.
  double get effectiveVerticalPadding => !enabled ? 0.0 : verticalPadding;
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
      'enableHover': enableHover,
      'hoverLift': hoverLift,
      'fieldHeight': fieldHeight,
      'horizontalPadding': horizontalPadding,
      'verticalPadding': verticalPadding,
    };
  }

  factory AppearanceInputSettings.fromJson(Map<String, dynamic> json) {
    return AppearanceInputSettings(
      enabled: _readBool(json, 'enabled', AppConstants.inputDefaultEnabled),
      enableBlur: _readBool(
        json,
        'enableBlur',
        AppConstants.inputDefaultEnableBlur,
      ),
      blur: _readDouble(json, 'blur', AppConstants.inputDefaultBlur),
      backgroundOpacity: _readDouble(
        json,
        'backgroundOpacity',
        AppConstants.inputDefaultBackgroundOpacity,
      ),
      enableBorder: _readBool(
        json,
        'enableBorder',
        AppConstants.inputDefaultEnableBorder,
      ),
      borderOpacity: _readDouble(
        json,
        'borderOpacity',
        AppConstants.inputDefaultBorderOpacity,
      ),
      borderWidth: _readDouble(
        json,
        'borderWidth',
        AppConstants.inputDefaultBorderWidth,
      ),
      borderRadius: _readDouble(
        json,
        'borderRadius',
        AppConstants.inputDefaultBorderRadius,
      ),
      enableShadow: _readBool(
        json,
        'enableShadow',
        AppConstants.inputDefaultEnableShadow,
      ),
      shadowOpacity: _readDouble(
        json,
        'shadowOpacity',
        AppConstants.inputDefaultShadowOpacity,
      ),
      shadowBlur: _readDouble(
        json,
        'shadowBlur',
        AppConstants.inputDefaultShadowBlur,
      ),
      shadowOffsetY: _readDouble(
        json,
        'shadowOffsetY',
        AppConstants.inputDefaultShadowOffsetY,
      ),
      enableHover: _readBool(
        json,
        'enableHover',
        AppConstants.inputDefaultEnableHover,
      ),
      hoverLift: _readDouble(
        json,
        'hoverLift',
        AppConstants.inputDefaultHoverLift,
      ),
      fieldHeight: _readDouble(
        json,
        'fieldHeight',
        AppConstants.inputDefaultFieldHeight,
      ),
      horizontalPadding: _readDouble(
        json,
        'horizontalPadding',
        AppConstants.inputDefaultHorizontalPadding,
      ),
      verticalPadding: _readDouble(
        json,
        'verticalPadding',
        AppConstants.inputDefaultVerticalPadding,
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

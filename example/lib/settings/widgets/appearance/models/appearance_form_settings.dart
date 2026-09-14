import 'package:flutter/foundation.dart';
import 'package:universal_glass/glass.dart';

/// Réglages visuels et spatiaux d'un formulaire Glass.
/// Cette classe ne contient aucune logique d'application.
/// Elle représente uniquement la configuration visuelle et spatiale
/// d'un formulaire.
@immutable
class AppearanceFormSettings {
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
  // FORM SPACING
  // ===========================================================================
  final double fieldSpacing;
  final double sectionSpacing;
  final double actionsSpacing;
  // ===========================================================================
  // FORM PADDING
  // ===========================================================================
  final double horizontalPadding;
  final double verticalPadding;
  // ===========================================================================
  // CONSTRUCTOR
  // ===========================================================================
  const AppearanceFormSettings({
    this.enabled = AppConstants.formDefaultEnabled,
    this.enableBlur = AppConstants.formDefaultEnableBlur,
    this.blur = AppConstants.formDefaultBlur,
    this.backgroundOpacity = AppConstants.formDefaultBackgroundOpacity,
    this.enableBorder = AppConstants.formDefaultEnableBorder,
    this.borderOpacity = AppConstants.formDefaultBorderOpacity,
    this.borderWidth = AppConstants.formDefaultBorderWidth,
    this.borderRadius = AppConstants.formDefaultBorderRadius,
    this.enableShadow = AppConstants.formDefaultEnableShadow,
    this.shadowOpacity = AppConstants.formDefaultShadowOpacity,
    this.shadowBlur = AppConstants.formDefaultShadowBlur,
    this.shadowOffsetY = AppConstants.formDefaultShadowOffsetY,
    this.fieldSpacing = AppConstants.formDefaultFieldSpacing,
    this.sectionSpacing = AppConstants.formDefaultSectionSpacing,
    this.actionsSpacing = AppConstants.formDefaultActionsSpacing,
    this.horizontalPadding = AppConstants.formDefaultHorizontalPadding,
    this.verticalPadding = AppConstants.formDefaultVerticalPadding,
  });
  // ===========================================================================
  // COPY WITH
  // ===========================================================================
  AppearanceFormSettings copyWith({
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
    double? fieldSpacing,
    double? sectionSpacing,
    double? actionsSpacing,
    double? horizontalPadding,
    double? verticalPadding,
  }) {
    return AppearanceFormSettings(
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
      fieldSpacing: fieldSpacing ?? this.fieldSpacing,
      sectionSpacing: sectionSpacing ?? this.sectionSpacing,
      actionsSpacing: actionsSpacing ?? this.actionsSpacing,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      verticalPadding: verticalPadding ?? this.verticalPadding,
    );
  }

  // ===========================================================================
  // EFFECTIVE VALUES
  // ===========================================================================
  /// Blur effectivement appliqué au formulaire.
  double get effectiveBlur => !enabled || !enableBlur ? 0.0 : blur;

  /// Opacité du background effectivement appliquée.
  double get effectiveBackgroundOpacity => !enabled ? 0.0 : backgroundOpacity;

  /// Opacité de la bordure effectivement appliquée.
  double get effectiveBorderOpacity =>
      !enabled || !enableBorder ? 0.0 : borderOpacity;

  /// Épaisseur de la bordure effectivement appliquée.
  double get effectiveBorderWidth =>
      !enabled || !enableBorder ? 0.0 : borderWidth;

  /// Rayon effectivement appliqué au formulaire.
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

  /// Espacement entre les champs effectivement appliqué.
  double get effectiveFieldSpacing => !enabled ? 0.0 : fieldSpacing;

  /// Espacement entre les sections effectivement appliqué.
  double get effectiveSectionSpacing => !enabled ? 0.0 : sectionSpacing;

  /// Espacement entre les actions effectivement appliqué.
  double get effectiveActionsSpacing => !enabled ? 0.0 : actionsSpacing;

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
      'fieldSpacing': fieldSpacing,
      'sectionSpacing': sectionSpacing,
      'actionsSpacing': actionsSpacing,
      'horizontalPadding': horizontalPadding,
      'verticalPadding': verticalPadding,
    };
  }

  factory AppearanceFormSettings.fromJson(Map<String, dynamic> json) {
    return AppearanceFormSettings(
      enabled: _readBool(json, 'enabled', AppConstants.formDefaultEnabled),
      enableBlur: _readBool(
        json,
        'enableBlur',
        AppConstants.formDefaultEnableBlur,
      ),
      blur: _readDouble(json, 'blur', AppConstants.formDefaultBlur),
      backgroundOpacity: _readDouble(
        json,
        'backgroundOpacity',
        AppConstants.formDefaultBackgroundOpacity,
      ),
      enableBorder: _readBool(
        json,
        'enableBorder',
        AppConstants.formDefaultEnableBorder,
      ),
      borderOpacity: _readDouble(
        json,
        'borderOpacity',
        AppConstants.formDefaultBorderOpacity,
      ),
      borderWidth: _readDouble(
        json,
        'borderWidth',
        AppConstants.formDefaultBorderWidth,
      ),
      borderRadius: _readDouble(
        json,
        'borderRadius',
        AppConstants.formDefaultBorderRadius,
      ),
      enableShadow: _readBool(
        json,
        'enableShadow',
        AppConstants.formDefaultEnableShadow,
      ),
      shadowOpacity: _readDouble(
        json,
        'shadowOpacity',
        AppConstants.formDefaultShadowOpacity,
      ),
      shadowBlur: _readDouble(
        json,
        'shadowBlur',
        AppConstants.formDefaultShadowBlur,
      ),
      shadowOffsetY: _readDouble(
        json,
        'shadowOffsetY',
        AppConstants.formDefaultShadowOffsetY,
      ),
      fieldSpacing: _readDouble(
        json,
        'fieldSpacing',
        AppConstants.formDefaultFieldSpacing,
      ),
      sectionSpacing: _readDouble(
        json,
        'sectionSpacing',
        AppConstants.formDefaultSectionSpacing,
      ),
      actionsSpacing: _readDouble(
        json,
        'actionsSpacing',
        AppConstants.formDefaultActionsSpacing,
      ),
      horizontalPadding: _readDouble(
        json,
        'horizontalPadding',
        AppConstants.formDefaultHorizontalPadding,
      ),
      verticalPadding: _readDouble(
        json,
        'verticalPadding',
        AppConstants.formDefaultVerticalPadding,
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

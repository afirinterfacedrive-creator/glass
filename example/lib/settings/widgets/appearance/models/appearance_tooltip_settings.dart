import 'package:flutter/foundation.dart';
import 'package:universal_glass/glass.dart';

/// Réglages visuels et temporels des Tooltip Glass.
/// Cette classe contient uniquement les valeurs configurées.
/// La validation et les éventuelles contraintes min/max doivent être
/// appliquées au niveau du controller/provider lors de la modification
/// des réglages.
/// Les getters [effective...] ne modifient jamais une valeur configurée.
/// Lorsque le composant ou une fonctionnalité est désactivée, la valeur
/// effective correspondante est [0.0].
@immutable
class AppearanceTooltipSettings {
  // ===========================================================================
  // STATE
  // ===========================================================================
  final bool enabled;
  final bool enableBlur;
  final double blur;
  final double backgroundOpacity;
  final bool enableBorder;
  final double borderOpacity;
  final double borderWidth;
  final double borderRadius;
  final bool enableShadow;
  final double shadowOpacity;
  final double shadowBlur;
  final double shadowOffsetY;
  final double horizontalPadding;
  final double verticalPadding;
  final double maxWidth;
  final double waitDuration;
  final double showDuration;
  // ===========================================================================
  // CONSTRUCTOR
  // ===========================================================================
  const AppearanceTooltipSettings({
    this.enabled = AppConstants.tooltipDefaultEnabled,
    this.enableBlur = AppConstants.tooltipDefaultEnableBlur,
    this.blur = AppConstants.tooltipDefaultBlur,
    this.backgroundOpacity = AppConstants.tooltipDefaultBackgroundOpacity,
    this.enableBorder = AppConstants.tooltipDefaultEnableBorder,
    this.borderOpacity = AppConstants.tooltipDefaultBorderOpacity,
    this.borderWidth = AppConstants.tooltipDefaultBorderWidth,
    this.borderRadius = AppConstants.tooltipDefaultBorderRadius,
    this.enableShadow = AppConstants.tooltipDefaultEnableShadow,
    this.shadowOpacity = AppConstants.tooltipDefaultShadowOpacity,
    this.shadowBlur = AppConstants.tooltipDefaultShadowBlur,
    this.shadowOffsetY = AppConstants.tooltipDefaultShadowOffsetY,
    this.horizontalPadding = AppConstants.tooltipDefaultHorizontalPadding,
    this.verticalPadding = AppConstants.tooltipDefaultVerticalPadding,
    this.maxWidth = AppConstants.tooltipDefaultMaxWidth,
    this.waitDuration = AppConstants.tooltipDefaultWaitDuration,
    this.showDuration = AppConstants.tooltipDefaultShowDuration,
  });
  // ===========================================================================
  // COPY WITH
  // ===========================================================================
  AppearanceTooltipSettings copyWith({
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
    double? waitDuration,
    double? showDuration,
  }) {
    return AppearanceTooltipSettings(
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
      waitDuration: waitDuration ?? this.waitDuration,
      showDuration: showDuration ?? this.showDuration,
    );
  }

  // ===========================================================================
  // EFFECTIVE VALUES
  // ===========================================================================
  /// Blur effectif du tooltip.
  double get effectiveBlur => !enabled || !enableBlur ? 0.0 : blur;

  /// Opacité de fond effective.
  double get effectiveBackgroundOpacity => !enabled ? 0.0 : backgroundOpacity;

  /// Opacité de bordure effective.
  double get effectiveBorderOpacity =>
      !enabled || !enableBorder ? 0.0 : borderOpacity;

  /// Épaisseur de bordure effective.
  double get effectiveBorderWidth =>
      !enabled || !enableBorder ? 0.0 : borderWidth;

  /// Rayon de bordure effectif.
  double get effectiveBorderRadius => !enabled ? 0.0 : borderRadius;

  /// Opacité d'ombre effective.
  double get effectiveShadowOpacity =>
      !enabled || !enableShadow ? 0.0 : shadowOpacity;

  /// Blur d'ombre effectif.
  double get effectiveShadowBlur =>
      !enabled || !enableShadow ? 0.0 : shadowBlur;

  /// Décalage vertical de l'ombre effectif.
  double get effectiveShadowOffsetY =>
      !enabled || !enableShadow ? 0.0 : shadowOffsetY;

  /// Padding horizontal effectif.
  double get effectiveHorizontalPadding => !enabled ? 0.0 : horizontalPadding;

  /// Padding vertical effectif.
  double get effectiveVerticalPadding => !enabled ? 0.0 : verticalPadding;

  /// Largeur maximale effective.
  double get effectiveMaxWidth => !enabled ? 0.0 : maxWidth;

  /// Durée d'attente effective avant affichage.
  double get effectiveWaitDuration => !enabled ? 0.0 : waitDuration;

  /// Durée d'affichage effective.
  double get effectiveShowDuration => !enabled ? 0.0 : showDuration;
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
      'waitDuration': waitDuration,
      'showDuration': showDuration,
    };
  }

  factory AppearanceTooltipSettings.fromJson(Map<String, dynamic> json) {
    return AppearanceTooltipSettings(
      enabled: _readBool(json, 'enabled', AppConstants.tooltipDefaultEnabled),
      enableBlur: _readBool(
        json,
        'enableBlur',
        AppConstants.tooltipDefaultEnableBlur,
      ),
      blur: _readDouble(json, 'blur', AppConstants.tooltipDefaultBlur),
      backgroundOpacity: _readDouble(
        json,
        'backgroundOpacity',
        AppConstants.tooltipDefaultBackgroundOpacity,
      ),
      enableBorder: _readBool(
        json,
        'enableBorder',
        AppConstants.tooltipDefaultEnableBorder,
      ),
      borderOpacity: _readDouble(
        json,
        'borderOpacity',
        AppConstants.tooltipDefaultBorderOpacity,
      ),
      borderWidth: _readDouble(
        json,
        'borderWidth',
        AppConstants.tooltipDefaultBorderWidth,
      ),
      borderRadius: _readDouble(
        json,
        'borderRadius',
        AppConstants.tooltipDefaultBorderRadius,
      ),
      enableShadow: _readBool(
        json,
        'enableShadow',
        AppConstants.tooltipDefaultEnableShadow,
      ),
      shadowOpacity: _readDouble(
        json,
        'shadowOpacity',
        AppConstants.tooltipDefaultShadowOpacity,
      ),
      shadowBlur: _readDouble(
        json,
        'shadowBlur',
        AppConstants.tooltipDefaultShadowBlur,
      ),
      shadowOffsetY: _readDouble(
        json,
        'shadowOffsetY',
        AppConstants.tooltipDefaultShadowOffsetY,
      ),
      horizontalPadding: _readDouble(
        json,
        'horizontalPadding',
        AppConstants.tooltipDefaultHorizontalPadding,
      ),
      verticalPadding: _readDouble(
        json,
        'verticalPadding',
        AppConstants.tooltipDefaultVerticalPadding,
      ),
      maxWidth: _readDouble(
        json,
        'maxWidth',
        AppConstants.tooltipDefaultMaxWidth,
      ),
      waitDuration: _readDouble(
        json,
        'waitDuration',
        AppConstants.tooltipDefaultWaitDuration,
      ),
      showDuration: _readDouble(
        json,
        'showDuration',
        AppConstants.tooltipDefaultShowDuration,
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

import 'package:flutter/foundation.dart';
import 'package:universal_glass/glass.dart';

/// Réglages visuels communs aux composants Glass.
///
/// Utilisé notamment pour :
/// - AppBar
/// - Card
/// - Modal
/// - Dialog
/// - Button
/// - Toggle
/// - Chip
/// - Surface
///
/// Cette classe ne contient aucune logique d'application.
/// Elle représente uniquement la configuration visuelle d'un composant.
@immutable
class AppearanceComponentSettings {
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
  // PADDING
  // ===========================================================================

  final double horizontalPadding;
  final double verticalPadding;

  // ===========================================================================
  // CONSTRUCTOR
  // ===========================================================================

  const AppearanceComponentSettings({
    this.enabled = AppConstants.componentDefaultEnabled,

    this.enableBlur = AppConstants.componentDefaultEnableBlur,
    this.blur = AppConstants.componentDefaultBlur,

    this.backgroundOpacity =
        AppConstants.componentDefaultBackgroundOpacity,

    this.enableBorder =
        AppConstants.componentDefaultEnableBorder,
    this.borderOpacity =
        AppConstants.componentDefaultBorderOpacity,
    this.borderWidth =
        AppConstants.componentDefaultBorderWidth,
    this.borderRadius =
        AppConstants.componentDefaultBorderRadius,

    this.enableShadow =
        AppConstants.componentDefaultEnableShadow,
    this.shadowOpacity =
        AppConstants.componentDefaultShadowOpacity,
    this.shadowBlur =
        AppConstants.componentDefaultShadowBlur,
    this.shadowOffsetY =
        AppConstants.componentDefaultShadowOffsetY,

    this.enableHover =
        AppConstants.componentDefaultEnableHover,
    this.hoverLift =
        AppConstants.componentDefaultHoverLift,

    this.horizontalPadding =
        AppConstants.componenthorizontalPadding,
    this.verticalPadding =
        AppConstants.componentverticalPadding,
  });

  // ===========================================================================
  // COPY WITH
  // ===========================================================================

  AppearanceComponentSettings copyWith({
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

    double? horizontalPadding,
    double? verticalPadding,
  }) {
    return AppearanceComponentSettings(
      enabled: enabled ?? this.enabled,

      enableBlur: enableBlur ?? this.enableBlur,
      blur: blur ?? this.blur,

      backgroundOpacity:
          backgroundOpacity ?? this.backgroundOpacity,

      enableBorder:
          enableBorder ?? this.enableBorder,
      borderOpacity:
          borderOpacity ?? this.borderOpacity,
      borderWidth:
          borderWidth ?? this.borderWidth,
      borderRadius:
          borderRadius ?? this.borderRadius,

      enableShadow:
          enableShadow ?? this.enableShadow,
      shadowOpacity:
          shadowOpacity ?? this.shadowOpacity,
      shadowBlur:
          shadowBlur ?? this.shadowBlur,
      shadowOffsetY:
          shadowOffsetY ?? this.shadowOffsetY,

      enableHover:
          enableHover ?? this.enableHover,
      hoverLift:
          hoverLift ?? this.hoverLift,

      horizontalPadding:
          horizontalPadding ?? this.horizontalPadding,
      verticalPadding:
          verticalPadding ?? this.verticalPadding,
    );
  }

  // ===========================================================================
  // EFFECTIVE VALUES
  // ===========================================================================

  /// Blur effectivement appliqué au composant.
  ///
  /// Retourne `0.0` si le composant ou le blur est désactivé.
  double get effectiveBlur {
    if (!enabled || !enableBlur) {
      return 0.0;
    }

    return blur;
  }

  /// Opacité du background effectivement appliquée.
  double get effectiveBackgroundOpacity {
    if (!enabled) {
      return 0.0;
    }

    return backgroundOpacity;
  }

  /// Opacité de la bordure effectivement appliquée.
  double get effectiveBorderOpacity {
    if (!enabled || !enableBorder) {
      return 0.0;
    }

    return borderOpacity;
  }

  /// Épaisseur de la bordure effectivement appliquée.
  double get effectiveBorderWidth {
    if (!enabled || !enableBorder) {
      return 0.0;
    }

    return borderWidth;
  }

  /// Rayon effectivement appliqué au composant.
  double get effectiveBorderRadius {
    if (!enabled) {
      return 0.0;
    }

    return borderRadius;
  }

  /// Opacité de l'ombre effectivement appliquée.
  double get effectiveShadowOpacity {
    if (!enabled || !enableShadow) {
      return 0.0;
    }

    return shadowOpacity;
  }

  /// Blur de l'ombre effectivement appliqué.
  double get effectiveShadowBlur {
    if (!enabled || !enableShadow) {
      return 0.0;
    }

    return shadowBlur;
  }

  /// Décalage vertical de l'ombre effectivement appliqué.
  double get effectiveShadowOffsetY {
    if (!enabled || !enableShadow) {
      return 0.0;
    }

    return shadowOffsetY;
  }

  /// Élévation au survol effectivement appliquée.
  double get effectiveHoverLift {
    if (!enabled || !enableHover) {
      return 0.0;
    }

    return hoverLift;
  }

  /// Padding horizontal effectivement appliqué.
  ///
  /// Retourne `0.0` lorsque le composant est désactivé.
  double get effectiveHorizontalPadding {
    if (!enabled) {
      return 0.0;
    }

    return horizontalPadding;
  }

  /// Padding vertical effectivement appliqué.
  ///
  /// Retourne `0.0` lorsque le composant est désactivé.
  double get effectiveVerticalPadding {
    if (!enabled) {
      return 0.0;
    }

    return verticalPadding;
  }

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

      'horizontalPadding': horizontalPadding,
      'verticalPadding': verticalPadding,
    };
  }

  // ===========================================================================
  // FROM JSON
  // ===========================================================================

  factory AppearanceComponentSettings.fromJson(
    Map<String, dynamic> json,
  ) {
    return AppearanceComponentSettings(
      enabled: _readBool(
        json,
        'enabled',
        AppConstants.componentDefaultEnabled,
      ),

      enableBlur: _readBool(
        json,
        'enableBlur',
        AppConstants.componentDefaultEnableBlur,
      ),

      blur: _readDouble(
        json,
        'blur',
        AppConstants.componentDefaultBlur,
      ),

      backgroundOpacity: _readDouble(
        json,
        'backgroundOpacity',
        AppConstants.componentDefaultBackgroundOpacity,
      ),

      enableBorder: _readBool(
        json,
        'enableBorder',
        AppConstants.componentDefaultEnableBorder,
      ),

      borderOpacity: _readDouble(
        json,
        'borderOpacity',
        AppConstants.componentDefaultBorderOpacity,
      ),

      borderWidth: _readDouble(
        json,
        'borderWidth',
        AppConstants.componentDefaultBorderWidth,
      ),

      borderRadius: _readDouble(
        json,
        'borderRadius',
        AppConstants.componentDefaultBorderRadius,
      ),

      enableShadow: _readBool(
        json,
        'enableShadow',
        AppConstants.componentDefaultEnableShadow,
      ),

      shadowOpacity: _readDouble(
        json,
        'shadowOpacity',
        AppConstants.componentDefaultShadowOpacity,
      ),

      shadowBlur: _readDouble(
        json,
        'shadowBlur',
        AppConstants.componentDefaultShadowBlur,
      ),

      shadowOffsetY: _readDouble(
        json,
        'shadowOffsetY',
        AppConstants.componentDefaultShadowOffsetY,
      ),

      enableHover: _readBool(
        json,
        'enableHover',
        AppConstants.componentDefaultEnableHover,
      ),

      hoverLift: _readDouble(
        json,
        'hoverLift',
        AppConstants.componentDefaultHoverLift,
      ),

      horizontalPadding: _readDouble(
        json,
        'horizontalPadding',
        AppConstants.componenthorizontalPadding,
      ),

      verticalPadding: _readDouble(
        json,
        'verticalPadding',
        AppConstants.componentverticalPadding,
      ),
    );
  }

  // ===========================================================================
  // JSON HELPERS
  // ===========================================================================

  static bool _readBool(
    Map<String, dynamic> json,
    String key,
    bool fallback,
  ) {
    final dynamic value = json[key];

    if (value is bool) {
      return value;
    }

    return fallback;
  }

  static double _readDouble(
    Map<String, dynamic> json,
    String key,
    double fallback,
  ) {
    final dynamic value = json[key];

    if (value is num) {
      final double result = value.toDouble();

      if (result.isFinite) {
        return result;
      }
    }

    return fallback;
  }
}
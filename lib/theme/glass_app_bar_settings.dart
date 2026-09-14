import 'package:flutter/foundation.dart';

/// ============================================================================
/// GLASS APP BAR SETTINGS
/// ============================================================================
///
/// Réglages visuels et de layout de [UniversalAppBar].
///
/// Ce modèle appartient au package et ne dépend jamais de `example/`.
///
/// Les propriétés contextuelles de l'AppBar restent volontairement dans
/// [UniversalAppBar] :
///
/// - title
/// - subtitle
/// - showLogo
/// - showBackButton
/// - onBack
/// - actions
/// - tabs
/// - hideNavigation
///
/// Ici sont stockés uniquement les paramètres d'apparence globaux.
@immutable
class GlassAppBarSettings {
  /// AppBar active.
  final bool enabled;

  /// Autorise le fond gradient de l'AppBar.
  ///
  /// Ce paramètre permet notamment d'éviter une AppBar trop transparente.
  final bool useGradientBackground;

  /// Utilise la hauteur compacte.
  final bool compactMode;

  /// Hauteur personnalisée.
  ///
  /// `null` = hauteur responsive automatique.
  final double? height;

  // ==========================================================================
  // ACTION BUTTONS
  // ==========================================================================

  final double actionBackgroundOpacity;
  final double actionAccentOpacity;
  final double actionBorderOpacity;
  final double actionBorderWidth;
  final double actionShadowOpacity;
  final double actionShadowBlur;
  final double actionShadowOffsetY;

  // ==========================================================================
  // APP BAR SHADOW
  // ==========================================================================

  final double shadowOpacity;

  const GlassAppBarSettings({
    this.enabled = true,
    this.useGradientBackground = true,
    this.compactMode = false,
    this.height,
    this.actionBackgroundOpacity = 0.14,
    this.actionAccentOpacity = 0.07,
    this.actionBorderOpacity = 0.20,
    this.actionBorderWidth = 0.80,
    this.actionShadowOpacity = 0.06,
    this.actionShadowBlur = 8.0,
    this.actionShadowOffsetY = 1.0,
    this.shadowOpacity = 0.10,
  });

  // ==========================================================================
  // DEFAULTS
  // ==========================================================================

  static const GlassAppBarSettings defaults =
      GlassAppBarSettings();

  static const GlassAppBarSettings compact =
      GlassAppBarSettings(
    compactMode: true,
  );

  // ==========================================================================
  // EFFECTIVE VALUES
  // ==========================================================================

  double get effectiveActionBackgroundOpacity =>
      actionBackgroundOpacity.clamp(0.0, 1.0).toDouble();

  double get effectiveActionAccentOpacity =>
      actionAccentOpacity.clamp(0.0, 1.0).toDouble();

  double get effectiveActionBorderOpacity =>
      actionBorderOpacity.clamp(0.0, 1.0).toDouble();

  double get effectiveActionBorderWidth =>
      actionBorderWidth.clamp(0.0, 12.0).toDouble();

  double get effectiveActionShadowOpacity =>
      actionShadowOpacity.clamp(0.0, 1.0).toDouble();

  double get effectiveActionShadowBlur =>
      actionShadowBlur.clamp(0.0, 100.0).toDouble();

  double get effectiveActionShadowOffsetY =>
      actionShadowOffsetY.clamp(-100.0, 100.0).toDouble();

  double get effectiveShadowOpacity =>
      shadowOpacity.clamp(0.0, 1.0).toDouble();

  double? get effectiveHeight {
    if (height == null) {
      return null;
    }

    if (!height!.isFinite) {
      return null;
    }

    return height!.clamp(56.0, 200.0).toDouble();
  }

  // ==========================================================================
  // COPY WITH
  // ==========================================================================

  GlassAppBarSettings copyWith({
    bool? enabled,
    bool? useGradientBackground,
    bool? compactMode,
    double? height,
    bool clearHeight = false,
    double? actionBackgroundOpacity,
    double? actionAccentOpacity,
    double? actionBorderOpacity,
    double? actionBorderWidth,
    double? actionShadowOpacity,
    double? actionShadowBlur,
    double? actionShadowOffsetY,
    double? shadowOpacity,
  }) {
    return GlassAppBarSettings(
      enabled: enabled ?? this.enabled,
      useGradientBackground:
          useGradientBackground ??
          this.useGradientBackground,
      compactMode:
          compactMode ??
          this.compactMode,
      height: clearHeight
          ? null
          : height ?? this.height,
      actionBackgroundOpacity:
          actionBackgroundOpacity ??
          this.actionBackgroundOpacity,
      actionAccentOpacity:
          actionAccentOpacity ??
          this.actionAccentOpacity,
      actionBorderOpacity:
          actionBorderOpacity ??
          this.actionBorderOpacity,
      actionBorderWidth:
          actionBorderWidth ??
          this.actionBorderWidth,
      actionShadowOpacity:
          actionShadowOpacity ??
          this.actionShadowOpacity,
      actionShadowBlur:
          actionShadowBlur ??
          this.actionShadowBlur,
      actionShadowOffsetY:
          actionShadowOffsetY ??
          this.actionShadowOffsetY,
      shadowOpacity:
          shadowOpacity ??
          this.shadowOpacity,
    );
  }

  // ==========================================================================
  // NORMALIZE
  // ==========================================================================

  GlassAppBarSettings normalized() {
    return GlassAppBarSettings(
      enabled: enabled,
      useGradientBackground: useGradientBackground,
      compactMode: compactMode,
      height: effectiveHeight,
      actionBackgroundOpacity:
          effectiveActionBackgroundOpacity,
      actionAccentOpacity:
          effectiveActionAccentOpacity,
      actionBorderOpacity:
          effectiveActionBorderOpacity,
      actionBorderWidth:
          effectiveActionBorderWidth,
      actionShadowOpacity:
          effectiveActionShadowOpacity,
      actionShadowBlur:
          effectiveActionShadowBlur,
      actionShadowOffsetY:
          effectiveActionShadowOffsetY,
      shadowOpacity:
          effectiveShadowOpacity,
    );
  }

  // ==========================================================================
  // JSON
  // ==========================================================================

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'enabled': enabled,
      'useGradientBackground': useGradientBackground,
      'compactMode': compactMode,
      'height': height,
      'actionBackgroundOpacity':
          actionBackgroundOpacity,
      'actionAccentOpacity':
          actionAccentOpacity,
      'actionBorderOpacity':
          actionBorderOpacity,
      'actionBorderWidth':
          actionBorderWidth,
      'actionShadowOpacity':
          actionShadowOpacity,
      'actionShadowBlur':
          actionShadowBlur,
      'actionShadowOffsetY':
          actionShadowOffsetY,
      'shadowOpacity':
          shadowOpacity,
    };
  }

  factory GlassAppBarSettings.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return GlassAppBarSettings.defaults;
    }

    return GlassAppBarSettings(
      enabled: _readBool(
        json['enabled'],
        true,
      ),
      useGradientBackground: _readBool(
        json['useGradientBackground'],
        true,
      ),
      compactMode: _readBool(
        json['compactMode'],
        false,
      ),
      height: _readNullableDouble(
        json['height'],
      ),
      actionBackgroundOpacity: _readDouble(
        json['actionBackgroundOpacity'],
        0.14,
      ),
      actionAccentOpacity: _readDouble(
        json['actionAccentOpacity'],
        0.07,
      ),
      actionBorderOpacity: _readDouble(
        json['actionBorderOpacity'],
        0.20,
      ),
      actionBorderWidth: _readDouble(
        json['actionBorderWidth'],
        0.80,
      ),
      actionShadowOpacity: _readDouble(
        json['actionShadowOpacity'],
        0.06,
      ),
      actionShadowBlur: _readDouble(
        json['actionShadowBlur'],
        8.0,
      ),
      actionShadowOffsetY: _readDouble(
        json['actionShadowOffsetY'],
        1.0,
      ),
      shadowOpacity: _readDouble(
        json['shadowOpacity'],
        0.10,
      ),
    ).normalized();
  }

  // ==========================================================================
  // HELPERS
  // ==========================================================================

  static bool _readBool(
    dynamic value,
    bool fallback,
  ) {
    return value is bool ? value : fallback;
  }

  static double _readDouble(
    dynamic value,
    double fallback,
  ) {
    if (value is num && value.isFinite) {
      return value.toDouble();
    }

    return fallback;
  }

  static double? _readNullableDouble(
    dynamic value,
  ) {
    if (value is! num || !value.isFinite) {
      return null;
    }

    return value.toDouble();
  }

  // ==========================================================================
  // EQUALITY
  // ==========================================================================

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is GlassAppBarSettings &&
            other.enabled == enabled &&
            other.useGradientBackground ==
                useGradientBackground &&
            other.compactMode == compactMode &&
            other.height == height &&
            other.actionBackgroundOpacity ==
                actionBackgroundOpacity &&
            other.actionAccentOpacity ==
                actionAccentOpacity &&
            other.actionBorderOpacity ==
                actionBorderOpacity &&
            other.actionBorderWidth ==
                actionBorderWidth &&
            other.actionShadowOpacity ==
                actionShadowOpacity &&
            other.actionShadowBlur ==
                actionShadowBlur &&
            other.actionShadowOffsetY ==
                actionShadowOffsetY &&
            other.shadowOpacity == shadowOpacity;
  }

  @override
  int get hashCode {
    return Object.hash(
      enabled,
      useGradientBackground,
      compactMode,
      height,
      actionBackgroundOpacity,
      actionAccentOpacity,
      actionBorderOpacity,
      actionBorderWidth,
      actionShadowOpacity,
      actionShadowBlur,
      actionShadowOffsetY,
      shadowOpacity,
    );
  }

  @override
  String toString() {
    return 'GlassAppBarSettings('
        'enabled: $enabled, '
        'useGradientBackground: $useGradientBackground, '
        'compactMode: $compactMode, '
        'height: $height, '
        'actionBackgroundOpacity: '
        '$actionBackgroundOpacity, '
        'actionAccentOpacity: '
        '$actionAccentOpacity, '
        'actionBorderOpacity: '
        '$actionBorderOpacity, '
        'actionBorderWidth: '
        '$actionBorderWidth, '
        'actionShadowOpacity: '
        '$actionShadowOpacity, '
        'actionShadowBlur: '
        '$actionShadowBlur, '
        'actionShadowOffsetY: '
        '$actionShadowOffsetY, '
        'shadowOpacity: '
        '$shadowOpacity'
        ')';
  }
}
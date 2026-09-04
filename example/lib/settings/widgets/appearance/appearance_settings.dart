import 'package:flutter/material.dart';
import 'package:universal_glass/enums/glass_enums.dart';

/// ============================================================================
/// APPEARANCE SETTINGS
/// ============================================================================

@immutable
class AppearanceSettings {
  // MODE
  final AppThemeMode themeMode;
  // STYLE GLASS
  final GlassStyle glassStyle;

  // COULEURS
  final List<Color> aquaColors;
  final List<Color> classicColors;

  // BLUR / NOISE
  final bool enableBlur;
  final double blur;
  final bool enableNoise;
  final double noise;

  // GRADIENT
  final bool enableGradient;
  final double gradientOpacity;
  final int gradientDensity;

  // SURFACE
  final double surfaceOpacity;
  final double borderRadius;

  // BORDER
  final bool enableBorder;
  final double borderOpacity;
  final double borderWidth;

  // GLOW
  final bool enableGlow;
  final double glowOpacity;
  final double glowBlur;

  // HOVER
  final bool enableHover;
  final double hoverLift;

  // SHADOW
  final bool enableShadow;
  final double shadowOpacity;
  final double shadowBlur;
  final double shadowOffsetY;

  const AppearanceSettings({
    this.themeMode = AppThemeMode.aqua,
    this.glassStyle = GlassStyle.transparentAqua,

    this.aquaColors = const [Color(0xFF4DD0E1), Color(0xFF00BCD4)],
    this.classicColors = const [Color(0xFF121212), Color(0xFF1A1A1A)],

    this.enableBlur = true,
    this.blur = 12.0,

    this.enableNoise = false,
    this.noise = 0.0,

    this.enableGradient = true,
    this.gradientOpacity = 1.0,
    this.gradientDensity = 2,

    this.surfaceOpacity = 1.0,
    this.borderRadius = 20.0,

    this.enableBorder = true,
    this.borderOpacity = 0.18,
    this.borderWidth = 0.72,

    this.enableGlow = true,
    this.glowOpacity = 0.18,
    this.glowBlur = 18.0,

    this.enableHover = true,
    this.hoverLift = 3.0,

    this.enableShadow = true,
    this.shadowOpacity = 0.18,
    this.shadowBlur = 12.0,
    this.shadowOffsetY = 7.0,
  });

  AppearanceSettings copyWith({
    AppThemeMode? themeMode,
    GlassStyle? glassStyle,

    List<Color>? aquaColors,
    List<Color>? classicColors,

    bool? enableBlur,
    double? blur,

    bool? enableNoise,
    double? noise,

    bool? enableGradient,
    double? gradientOpacity,
    int? gradientDensity,

    double? surfaceOpacity,
    double? borderRadius,

    bool? enableBorder,
    double? borderOpacity,
    double? borderWidth,

    bool? enableGlow,
    double? glowOpacity,
    double? glowBlur,

    bool? enableHover,
    double? hoverLift,

    bool? enableShadow,
    double? shadowOpacity,
    double? shadowBlur,
    double? shadowOffsetY,
  }) {
    return AppearanceSettings(
      themeMode: themeMode ?? this.themeMode,
      glassStyle: glassStyle ?? this.glassStyle,

      aquaColors: aquaColors ?? this.aquaColors,
      classicColors: classicColors ?? this.classicColors,

      enableBlur: enableBlur ?? this.enableBlur,
      blur: blur ?? this.blur,

      enableNoise: enableNoise ?? this.enableNoise,
      noise: noise ?? this.noise,

      enableGradient: enableGradient ?? this.enableGradient,
      gradientOpacity: gradientOpacity ?? this.gradientOpacity,
      gradientDensity: gradientDensity ?? this.gradientDensity,

      surfaceOpacity: surfaceOpacity ?? this.surfaceOpacity,
      borderRadius: borderRadius ?? this.borderRadius,

      enableBorder: enableBorder ?? this.enableBorder,
      borderOpacity: borderOpacity ?? this.borderOpacity,
      borderWidth: borderWidth ?? this.borderWidth,

      enableGlow: enableGlow ?? this.enableGlow,
      glowOpacity: glowOpacity ?? this.glowOpacity,
      glowBlur: glowBlur ?? this.glowBlur,

      enableHover: enableHover ?? this.enableHover,
      hoverLift: hoverLift ?? this.hoverLift,

      enableShadow: enableShadow ?? this.enableShadow,
      shadowOpacity: shadowOpacity ?? this.shadowOpacity,
      shadowBlur: shadowBlur ?? this.shadowBlur,
      shadowOffsetY: shadowOffsetY ?? this.shadowOffsetY,
    );
  }

  // ==========================================================================
  // SERIALISATION POUR PERSISTANCE
  // ==========================================================================
  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.name,
      'glassStyle': glassStyle.name, // <-- SAVE STYLE

      'aquaColors': aquaColors.map((c) => c.value).toList(),
      'classicColors': classicColors.map((c) => c.value).toList(),

      'enableBlur': enableBlur,
      'blur': blur,

      'enableNoise': enableNoise,
      'noise': noise,

      'enableGradient': enableGradient,
      'gradientOpacity': gradientOpacity,
      'gradientDensity': gradientDensity,

      'surfaceOpacity': surfaceOpacity,
      'borderRadius': borderRadius,

      'enableBorder': enableBorder,
      'borderOpacity': borderOpacity,
      'borderWidth': borderWidth,

      'enableGlow': enableGlow,
      'glowOpacity': glowOpacity,
      'glowBlur': glowBlur,

      'enableHover': enableHover,
      'hoverLift': hoverLift,

      'enableShadow': enableShadow,
      'shadowOpacity': shadowOpacity,
      'shadowBlur': shadowBlur,
      'shadowOffsetY': shadowOffsetY,
    };
  }

  factory AppearanceSettings.fromJson(Map<String, dynamic> json) {
    return AppearanceSettings(
      themeMode: AppThemeMode.values.byName(json['themeMode'] ?? 'aqua'),
      glassStyle: GlassStyle.values.byName(json['glassStyle'] ?? 'transparentAqua'), // <-- LOAD STYLE

      aquaColors: (json['aquaColors'] as List<dynamic>?)?.map((e) => Color(e as int)).toList() ?? const [Color(0xFF4DD0E1), Color(0xFF00BCD4)],
      classicColors: (json['classicColors'] as List<dynamic>?)?.map((e) => Color(e as int)).toList() ?? const [Color(0xFF121212), Color(0xFF1A1A1A)],

      enableBlur: json['enableBlur'] ?? true,
      blur: (json['blur'] ?? 12.0).toDouble(),

      enableNoise: json['enableNoise'] ?? false,
      noise: (json['noise'] ?? 0.0).toDouble(),

      enableGradient: json['enableGradient'] ?? true,
      gradientOpacity: (json['gradientOpacity'] ?? 1.0).toDouble(),
      gradientDensity: json['gradientDensity'] ?? 2,

      surfaceOpacity: (json['surfaceOpacity'] ?? 1.0).toDouble(),
      borderRadius: (json['borderRadius'] ?? 20.0).toDouble(),

      enableBorder: json['enableBorder'] ?? true,
      borderOpacity: (json['borderOpacity'] ?? 0.18).toDouble(),
      borderWidth: (json['borderWidth'] ?? 0.72).toDouble(),

      enableGlow: json['enableGlow'] ?? true,
      glowOpacity: (json['glowOpacity'] ?? 0.18).toDouble(),
      glowBlur: (json['glowBlur'] ?? 18.0).toDouble(),

      enableHover: json['enableHover'] ?? true,
      hoverLift: (json['hoverLift'] ?? 3.0).toDouble(),

      enableShadow: json['enableShadow'] ?? true,
      shadowOpacity: (json['shadowOpacity'] ?? 0.18).toDouble(),
      shadowBlur: (json['shadowBlur'] ?? 12.0).toDouble(),
      shadowOffsetY: (json['shadowOffsetY'] ?? 7.0).toDouble(),
    );
  }

  // ==========================================================================
  // HELPERS
  // ==========================================================================
  bool get isSage {
    switch (themeMode) {
      case AppThemeMode.sage:
      case AppThemeMode.sagePro:
      case AppThemeMode.sageOled:
      case AppThemeMode.sageGlass:
        return true;
      default:
        return false;
    }
  }

  bool get isAqua => themeMode == AppThemeMode.aqua;
  bool get isClassic => themeMode == AppThemeMode.classic;
  bool get isDark => themeMode == AppThemeMode.dark;
  bool get isLight => themeMode == AppThemeMode.light;
  bool get isSystem => themeMode == AppThemeMode.system;

  List<Color> get activeColors {
    if (isAqua) return aquaColors;
    if (isClassic) return classicColors;
    if (isSage) return sageBackground;
    switch (themeMode) {
      case AppThemeMode.light:
        return const [Color(0xFFF5F5F5), Color(0xFFE8E8E8)];
      case AppThemeMode.dark:
      case AppThemeMode.system:
        return const [Color(0xFF121212), Color(0xFF1E1E1E)];
      default:
        return const [Color(0xFF121212), Color(0xFF1E1E1E)];
    }
  }

  List<Color> get sageBackground {
    switch (themeMode) {
      case AppThemeMode.sage: return const [Color(0xFF121212), Color(0xFF1E1E1E)];
      case AppThemeMode.sagePro: return const [Color(0xFF0A0A0A), Color(0xFF151515)];
      case AppThemeMode.sageOled: return const [Colors.black, Colors.black];
      case AppThemeMode.sageGlass: return const [Color(0xFF0F0F0F), Color(0xFF1A1A1A)];
      default: return const [Color(0xFF121212), Color(0xFF1E1E1E)];
    }
  }

  double get effectiveBlur =>!enableBlur? 0.0 : blur.clamp(0.0, 100.0);
  double get effectiveNoise =>!enableNoise? 0.0 : noise.clamp(0.0, 1.0);
  double get effectiveGradientOpacity =>!enableGradient? 0.0 : gradientOpacity.clamp(0.0, 1.0);
  int get effectiveGradientDensity => gradientDensity.clamp(1, 10);
  double get effectiveSurfaceOpacity => surfaceOpacity.clamp(0.0, 1.0);
  double get effectiveBorderOpacity =>!enableBorder? 0.0 : borderOpacity.clamp(0.0, 1.0);
  double get effectiveBorderWidth =>!enableBorder? 0.0 : borderWidth.clamp(0.0, 10.0);
  double get effectiveBorderRadius => borderRadius.clamp(0.0, 100.0);
  double get effectiveGlowOpacity =>!enableGlow? 0.0 : glowOpacity.clamp(0.0, 1.0);
  double get effectiveGlowBlur =>!enableGlow? 0.0 : glowBlur.clamp(0.0, 100.0);
  bool get effectiveHover => enableHover;
  double get effectiveHoverLift =>!enableHover? 0.0 : hoverLift.clamp(0.0, 20.0);
  double get effectiveShadowOpacity =>!enableShadow? 0.0 : shadowOpacity.clamp(0.0, 1.0);
  double get effectiveShadowBlur =>!enableShadow? 0.0 : shadowBlur.clamp(0.0, 100.0);
  double get effectiveShadowOffsetY =>!enableShadow? 0.0 : shadowOffsetY.clamp(-50.0, 50.0);

  factory AppearanceSettings.defaults() => const AppearanceSettings();

  @override
  String toString() {
    return 'AppearanceSettings(themeMode: $themeMode, glassStyle: $glassStyle)';
  }
}
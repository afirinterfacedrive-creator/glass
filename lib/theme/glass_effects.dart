import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_glass/theme/glass_color_palette.dart';

/// ============================================================================
/// GLASS EFFECTS
/// ============================================================================
class GlassEffects {
  final List<Color> bgGradient;
  final List<Color> borderGradient;
  final double blur;
  final double noise;
  final double bgBlur;
  final double bgNoise;
  final double surfaceOpacity;
  final double borderRadius;
  final bool enableBorder;
  final double borderOpacity;
  final double borderWidth;
  final bool enableGlow;
  final double glowOpacity;
  final double glowBlur;
  final bool enableShadow;
  final double shadowOpacity;
  final double shadowBlur;
  final double shadowOffsetY;
  final Color? tintColor;

  const GlassEffects({
    required this.bgGradient,
    this.borderGradient = const [],
    this.blur = 20.0,
    this.noise = 0.0,
    this.bgBlur = 20.0,
    this.bgNoise = 0.0,
    this.surfaceOpacity = 1.0,
    this.borderRadius = 20.0,
    this.enableBorder = true,
    this.borderOpacity = 0.18,
    this.borderWidth = 0.72,
    this.enableGlow = false,
    this.glowOpacity = 0.18,
    this.glowBlur = 18.0,
    this.enableShadow = true,
    this.shadowOpacity = 0.18,
    this.shadowBlur = 12.0,
    this.shadowOffsetY = 7.0,
    this.tintColor,
  });

  const GlassEffects.empty()
      : bgGradient = const [Colors.transparent, Colors.transparent],
        borderGradient = const [Colors.transparent, Colors.transparent],
        blur = 0,
        noise = 0,
        bgBlur = 0,
        bgNoise = 0,
        surfaceOpacity = 0,
        borderRadius = 0,
        enableBorder = false,
        borderOpacity = 0,
        borderWidth = 0,
        enableGlow = false,
        glowOpacity = 0,
        glowBlur = 0,
        enableShadow = false,
        shadowOpacity = 0,
        shadowBlur = 0,
        shadowOffsetY = 0,
        tintColor = null;

  factory GlassEffects.defaults() => const GlassEffects(
        bgGradient: [Colors.transparent, Colors.transparent],
      );

  GlassEffects copyWith({
    List<Color>? bgGradient,
    List<Color>? borderGradient,
    double? blur,
    double? noise,
    double? bgBlur,
    double? bgNoise,
    double? surfaceOpacity,
    double? borderRadius,
    bool? enableBorder,
    double? borderOpacity,
    double? borderWidth,
    bool? enableGlow,
    double? glowOpacity,
    double? glowBlur,
    bool? enableShadow,
    double? shadowOpacity,
    double? shadowBlur,
    double? shadowOffsetY,
    Color? tintColor,
  }) {
    return GlassEffects(
      bgGradient: bgGradient ?? this.bgGradient,
      borderGradient: borderGradient ?? this.borderGradient,
      blur: blur ?? this.blur,
      noise: noise ?? this.noise,
      bgBlur: bgBlur ?? this.bgBlur,
      bgNoise: bgNoise ?? this.bgNoise,
      surfaceOpacity: surfaceOpacity ?? this.surfaceOpacity,
      borderRadius: borderRadius ?? this.borderRadius,
      enableBorder: enableBorder ?? this.enableBorder,
      borderOpacity: borderOpacity ?? this.borderOpacity,
      borderWidth: borderWidth ?? this.borderWidth,
      enableGlow: enableGlow ?? this.enableGlow,
      glowOpacity: glowOpacity ?? this.glowOpacity,
      glowBlur: glowBlur ?? this.glowBlur,
      enableShadow: enableShadow ?? this.enableShadow,
      shadowOpacity: shadowOpacity ?? this.shadowOpacity,
      shadowBlur: shadowBlur ?? this.shadowBlur,
      shadowOffsetY: shadowOffsetY ?? this.shadowOffsetY,
      tintColor: tintColor ?? this.tintColor,
    );
  }

  factory GlassEffects.fromTheme(GlassColorPalette colors, {
    double? blur, double? noise, double? bgBlur, double? bgNoise,
    double? surfaceOpacity, double? borderRadius, bool? enableBorder,
    double? borderOpacity, double? borderWidth, bool? enableGlow,
    double? glowOpacity, double? glowBlur, bool? enableShadow,
    double? shadowOpacity, double? shadowBlur, double? shadowOffsetY,
  }) {
    return GlassEffects(
      bgGradient: [colors.surfaceSecondary, colors.surface],
      borderGradient: [colors.border, colors.border],
      blur: blur ?? 12.0, noise: noise ?? 0.0, bgBlur: bgBlur ?? 12.0, bgNoise: bgNoise ?? 0.0,
      surfaceOpacity: surfaceOpacity ?? 1.0, borderRadius: borderRadius ?? 20.0,
      enableBorder: enableBorder ?? true, borderOpacity: borderOpacity ?? 0.18, borderWidth: borderWidth ?? 0.72,
      enableGlow: enableGlow ?? false, glowOpacity: glowOpacity ?? 0.18, glowBlur: glowBlur ?? 18.0,
      enableShadow: enableShadow ?? true, shadowOpacity: shadowOpacity ?? 0.18, shadowBlur: shadowBlur ?? 12.0, shadowOffsetY: shadowOffsetY ?? 7.0,
    );
  }

  factory GlassEffects.liquidAqua(GlassColorPalette colors) {
    return GlassEffects(
      bgGradient: [colors.aqua.withValues(alpha: 0.18), colors.aquaDark.withValues(alpha: 0.055)],
      borderGradient: [colors.aqua.withValues(alpha: 0.25), colors.aquaDark.withValues(alpha: 0.12)],
      blur: 20, noise: 0.04, bgBlur: 20, bgNoise: 0.04, enableGlow: true, glowOpacity: 0.25, glowBlur: 30,
    );
  }

  factory GlassEffects.liquidClassic(GlassColorPalette colors) {
    return GlassEffects(
      bgGradient: [colors.classic.withValues(alpha: 0.15), colors.classicDark.withValues(alpha: 0.05)],
      borderGradient: [colors.classic.withValues(alpha: 0.22), colors.classicDark.withValues(alpha: 0.10)],
      blur: 18, noise: 0.03, bgBlur: 18, bgNoise: 0.03, enableBorder: true, borderOpacity: 0.3,
    );
  }

  factory GlassEffects.presetClassicSb(GlassColorPalette colors) {
    return GlassEffects(
      bgGradient: [const Color(0xFF1A1A1A), const Color(0xFF121212)],
      borderGradient: [const Color(0xFFD4AF37).withValues(alpha: 0.3), const Color(0xFFD4AF37).withValues(alpha: 0.15)],
      blur: 0, noise: 0, bgBlur: 0, bgNoise: 0, surfaceOpacity: 1.0, borderRadius: 26,
      enableBorder: true, borderOpacity: 0.3, borderWidth: 1.0, enableGlow: false,
      enableShadow: true, shadowBlur: 24, shadowOpacity: 0.25, shadowOffsetY: 12,
    );
  }

  factory GlassEffects.liquidBlue(GlassColorPalette colors) {
    return GlassEffects(
      bgGradient: [colors.info.withValues(alpha: 0.16), colors.info.withValues(alpha: 0.045)],
      borderGradient: [colors.info.withValues(alpha: 0.24), colors.info.withValues(alpha: 0.09)],
      blur: 20, noise: 0.04, bgBlur: 20, bgNoise: 0.04, enableGlow: true, glowOpacity: 0.2, glowBlur: 24,
    );
  }

  factory GlassEffects.liquidRed(GlassColorPalette colors) {
    return GlassEffects(
      bgGradient: [colors.error.withValues(alpha: 0.16), colors.error.withValues(alpha: 0.045)],
      borderGradient: [colors.error.withValues(alpha: 0.24), colors.error.withValues(alpha: 0.09)],
      blur: 20, noise: 0.04, bgBlur: 20, bgNoise: 0.04, enableGlow: true, glowOpacity: 0.2, glowBlur: 24,
    );
  }

  factory GlassEffects.liquidGreen(GlassColorPalette colors) {
    return GlassEffects(
      bgGradient: [colors.success.withValues(alpha: 0.15), colors.success.withValues(alpha: 0.045)],
      borderGradient: [colors.success.withValues(alpha: 0.23), colors.success.withValues(alpha: 0.09)],
      blur: 20, noise: 0.03, bgBlur: 20, bgNoise: 0.03, enableGlow: true, glowOpacity: 0.18, glowBlur: 22,
    );
  }

  factory GlassEffects.liquidAmber(GlassColorPalette colors) {
    return GlassEffects(
      bgGradient: [colors.warning.withValues(alpha: 0.15), colors.warning.withValues(alpha: 0.045)],
      borderGradient: [colors.warning.withValues(alpha: 0.23), colors.warning.withValues(alpha: 0.09)],
      blur: 20, noise: 0.04, bgBlur: 20, bgNoise: 0.04, enableGlow: true, glowOpacity: 0.2, glowBlur: 24,
    );
  }

  factory GlassEffects.liquidDark(GlassColorPalette colors) {
    return GlassEffects(
      bgGradient: [colors.surfaceSecondary.withValues(alpha: 0.55), colors.black.withValues(alpha: 0.65)],
      borderGradient: [colors.white.withValues(alpha: 0.08), colors.white.withValues(alpha: 0.04)],
      blur: 24, noise: 0.06, bgBlur: 24, bgNoise: 0.06, enableShadow: true, shadowBlur: 28, shadowOpacity: 0.3, shadowOffsetY: 14,
    );
  }

  factory GlassEffects.liquidWhite(GlassColorPalette colors) {
    return GlassEffects(
      bgGradient: [colors.white.withValues(alpha: 0.12), colors.white.withValues(alpha: 0.02)],
      borderGradient: [colors.white.withValues(alpha: 0.20), colors.white.withValues(alpha: 0.08)],
      blur: 16, noise: 0.02, bgBlur: 16, bgNoise: 0.02, enableBorder: true, borderOpacity: 0.15,
    );
  }

  static GlassEffects get none => const GlassEffects.empty();
  static GlassEffects get classic {
    final colors = GlassColorPalette.defaults();
    return GlassEffects.liquidClassic(colors);
  }
  static GlassEffects get aqua {
    final colors = GlassColorPalette.defaults();
    return GlassEffects.liquidAqua(colors);
  }
  static GlassEffects get classicSubtle {
    final colors = GlassColorPalette.defaults();
    return GlassEffects.presetClassicSb(colors);
  }
  static GlassEffects get blue {
    final colors = GlassColorPalette.defaults();
    return GlassEffects.liquidBlue(colors);
  }
  static GlassEffects get red {
    final colors = GlassColorPalette.defaults();
    return GlassEffects.liquidRed(colors);
  }
  static GlassEffects get green {
    final colors = GlassColorPalette.defaults();
    return GlassEffects.liquidGreen(colors);
  }
  static GlassEffects get amber {
    final colors = GlassColorPalette.defaults();
    return GlassEffects.liquidAmber(colors);
  }
  static GlassEffects get dark {
    final colors = GlassColorPalette.defaults();
    return GlassEffects.liquidDark(colors);
  }
  static GlassEffects get white {
    final colors = GlassColorPalette.defaults();
    return GlassEffects.liquidWhite(colors);
  }

  @override
  bool operator ==(covariant GlassEffects other) {
    if (identical(this, other)) return true;
    return listEquals(other.bgGradient, bgGradient) &&
        listEquals(other.borderGradient, borderGradient) &&
        other.blur == blur && other.noise == noise && other.bgBlur == bgBlur && other.bgNoise == bgNoise &&
        other.surfaceOpacity == surfaceOpacity && other.borderRadius == borderRadius &&
        other.enableBorder == enableBorder && other.borderOpacity == borderOpacity && other.borderWidth == borderWidth &&
        other.enableGlow == enableGlow && other.glowOpacity == glowOpacity && other.glowBlur == glowBlur &&
        other.enableShadow == enableShadow && other.shadowOpacity == shadowOpacity && other.shadowBlur == shadowBlur && other.shadowOffsetY == shadowOffsetY &&
        other.tintColor == tintColor;
  }

  @override
  int get hashCode => Object.hash(
        Object.hashAll(bgGradient), Object.hashAll(borderGradient),
        blur, noise, bgBlur, bgNoise, surfaceOpacity, borderRadius,
        enableBorder, borderOpacity, borderWidth, enableGlow, glowOpacity, glowBlur,
        enableShadow, shadowOpacity, shadowBlur, shadowOffsetY, tintColor,
      );
}
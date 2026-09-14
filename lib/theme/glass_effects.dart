
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_glass/theme/glass_color_palette.dart';

/// ============================================================================
/// GLASS EFFECTS
/// ============================================================================
///
/// Configuration immuable des effets visuels Universal Glass.
///
/// IMPORTANT :
/// - Une valeur explicite de 0.0 est une vraie valeur.
/// - `copyWith()` ne doit jamais transformer 0.0 en valeur par défaut.
/// - Les valeurs par défaut générales sont alignées sur le thème :
///   blur = 12.0
///   bgBlur = 12.0
///
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

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const GlassEffects({
    required this.bgGradient,
    this.borderGradient = const [],

    // Valeurs générales alignées sur GlassThemeState.
    this.blur = 12.0,
    this.noise = 0.0,

    this.bgBlur = 12.0,
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

  // ==========================================================================
  // EMPTY
  // ==========================================================================

  /// Effets complètement désactivés.
  ///
  /// Ici, blur et bgBlur sont explicitement à 0.
  /// Ils doivent rester à 0 et ne jamais être remplacés par les valeurs
  /// par défaut du constructeur principal.
  const GlassEffects.empty()
      : bgGradient = const [
          Colors.transparent,
          Colors.transparent,
        ],
        borderGradient = const [
          Colors.transparent,
          Colors.transparent,
        ],
        blur = 0.0,
        noise = 0.0,
        bgBlur = 0.0,
        bgNoise = 0.0,
        surfaceOpacity = 0.0,
        borderRadius = 0.0,
        enableBorder = false,
        borderOpacity = 0.0,
        borderWidth = 0.0,
        enableGlow = false,
        glowOpacity = 0.0,
        glowBlur = 0.0,
        enableShadow = false,
        shadowOpacity = 0.0,
        shadowBlur = 0.0,
        shadowOffsetY = 0.0,
        tintColor = null;

  // ==========================================================================
  // DEFAULTS
  // ==========================================================================

  /// Configuration générale par défaut.
  ///
  /// Les gradients sont transparents car ils sont généralement fournis
  /// séparément par le style actif.
  factory GlassEffects.defaults() {
    return const GlassEffects(
      bgGradient: [
        Colors.transparent,
        Colors.transparent,
      ],
    );
  }

  // ==========================================================================
  // COPY WITH
  // ==========================================================================

  /// Crée une copie avec les propriétés spécifiées.
  ///
  /// IMPORTANT :
  /// `??` permet de distinguer :
  ///
  ///   null  → conserver la valeur existante
  ///   0.0   → utiliser réellement 0.0
  ///
  /// Ainsi :
  ///
  ///   effects.copyWith(blur: 0.0)
  ///
  /// produit bien :
  ///
  ///   blur = 0.0
  ///
  /// et non la valeur par défaut de 12.0.
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

  // ==========================================================================
  // FROM THEME
  // ==========================================================================

  /// Construit les effets à partir d'une palette.
  ///
  /// Les paramètres optionnels permettent de remplacer individuellement
  /// les valeurs par défaut.
  ///
  /// Une valeur 0.0 explicitement fournie est conservée.
  factory GlassEffects.fromTheme(
    GlassColorPalette colors, {
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
  }) {
    return GlassEffects(
      bgGradient: [
        colors.surfaceSecondary,
        colors.surface,
      ],
      borderGradient: [
        colors.border,
        colors.border,
      ],

      blur: blur ?? 12.0,
      noise: noise ?? 0.0,

      bgBlur: bgBlur ?? 12.0,
      bgNoise: bgNoise ?? 0.0,

      surfaceOpacity: surfaceOpacity ?? 1.0,
      borderRadius: borderRadius ?? 20.0,

      enableBorder: enableBorder ?? true,
      borderOpacity: borderOpacity ?? 0.18,
      borderWidth: borderWidth ?? 0.72,

      enableGlow: enableGlow ?? false,
      glowOpacity: glowOpacity ?? 0.18,
      glowBlur: glowBlur ?? 18.0,

      enableShadow: enableShadow ?? true,
      shadowOpacity: shadowOpacity ?? 0.18,
      shadowBlur: shadowBlur ?? 12.0,
      shadowOffsetY: shadowOffsetY ?? 7.0,
    );
  }

  // ==========================================================================
  // LIQUID AQUA
  // ==========================================================================

  factory GlassEffects.liquidAqua(
    GlassColorPalette colors,
  ) {
    return GlassEffects(
      bgGradient: [
        colors.aqua.withValues(alpha: 0.18),
        colors.aquaDark.withValues(alpha: 0.055),
      ],
      borderGradient: [
        colors.aqua.withValues(alpha: 0.25),
        colors.aquaDark.withValues(alpha: 0.12),
      ],
      blur: 20.0,
      noise: 0.04,
      bgBlur: 20.0,
      bgNoise: 0.04,
      enableGlow: true,
      glowOpacity: 0.25,
      glowBlur: 30.0,
    );
  }

  // ==========================================================================
  // LIQUID CLASSIC
  // ==========================================================================

  factory GlassEffects.liquidClassic(
    GlassColorPalette colors,
  ) {
    return GlassEffects(
      bgGradient: [
        colors.classic.withValues(alpha: 0.15),
        colors.classicDark.withValues(alpha: 0.05),
      ],
      borderGradient: [
        colors.classic.withValues(alpha: 0.22),
        colors.classicDark.withValues(alpha: 0.10),
      ],
      blur: 18.0,
      noise: 0.03,
      bgBlur: 18.0,
      bgNoise: 0.03,
      enableBorder: true,
      borderOpacity: 0.3,
    );
  }

  // ==========================================================================
  // CLASSIC SB
  // ==========================================================================

  factory GlassEffects.presetClassicSb(
    GlassColorPalette colors,
  ) {
    return GlassEffects(
      bgGradient: const [
        Color(0xFF1A1A1A),
        Color(0xFF121212),
      ],
      borderGradient: [
        const Color(0xFFD4AF37).withValues(alpha: 0.3),
        const Color(0xFFD4AF37).withValues(alpha: 0.15),
      ],

      blur: 0.0,
      noise: 0.0,

      bgBlur: 0.0,
      bgNoise: 0.0,

      surfaceOpacity: 1.0,
      borderRadius: 26.0,

      enableBorder: true,
      borderOpacity: 0.3,
      borderWidth: 1.0,

      enableGlow: false,

      enableShadow: true,
      shadowBlur: 24.0,
      shadowOpacity: 0.25,
      shadowOffsetY: 12.0,
    );
  }

  // ==========================================================================
  // LIQUID BLUE
  // ==========================================================================

  factory GlassEffects.liquidBlue(
    GlassColorPalette colors,
  ) {
    return GlassEffects(
      bgGradient: [
        colors.info.withValues(alpha: 0.16),
        colors.info.withValues(alpha: 0.045),
      ],
      borderGradient: [
        colors.info.withValues(alpha: 0.24),
        colors.info.withValues(alpha: 0.09),
      ],
      blur: 20.0,
      noise: 0.04,
      bgBlur: 20.0,
      bgNoise: 0.04,
      enableGlow: true,
      glowOpacity: 0.2,
      glowBlur: 24.0,
    );
  }

  // ==========================================================================
  // LIQUID RED
  // ==========================================================================

  factory GlassEffects.liquidRed(
    GlassColorPalette colors,
  ) {
    return GlassEffects(
      bgGradient: [
        colors.error.withValues(alpha: 0.16),
        colors.error.withValues(alpha: 0.045),
      ],
      borderGradient: [
        colors.error.withValues(alpha: 0.24),
        colors.error.withValues(alpha: 0.09),
      ],
      blur: 20.0,
      noise: 0.04,
      bgBlur: 20.0,
      bgNoise: 0.04,
      enableGlow: true,
      glowOpacity: 0.2,
      glowBlur: 24.0,
    );
  }

  // ==========================================================================
  // LIQUID GREEN
  // ==========================================================================

  factory GlassEffects.liquidGreen(
    GlassColorPalette colors,
  ) {
    return GlassEffects(
      bgGradient: [
        colors.success.withValues(alpha: 0.15),
        colors.success.withValues(alpha: 0.045),
      ],
      borderGradient: [
        colors.success.withValues(alpha: 0.23),
        colors.success.withValues(alpha: 0.09),
      ],
      blur: 20.0,
      noise: 0.03,
      bgBlur: 20.0,
      bgNoise: 0.03,
      enableGlow: true,
      glowOpacity: 0.18,
      glowBlur: 22.0,
    );
  }

  // ==========================================================================
  // LIQUID AMBER
  // ==========================================================================

  factory GlassEffects.liquidAmber(
    GlassColorPalette colors,
  ) {
    return GlassEffects(
      bgGradient: [
        colors.warning.withValues(alpha: 0.15),
        colors.warning.withValues(alpha: 0.045),
      ],
      borderGradient: [
        colors.warning.withValues(alpha: 0.23),
        colors.warning.withValues(alpha: 0.09),
      ],
      blur: 20.0,
      noise: 0.04,
      bgBlur: 20.0,
      bgNoise: 0.04,
      enableGlow: true,
      glowOpacity: 0.2,
      glowBlur: 24.0,
    );
  }

  // ==========================================================================
  // LIQUID DARK
  // ==========================================================================

  factory GlassEffects.liquidDark(
    GlassColorPalette colors,
  ) {
    return GlassEffects(
      bgGradient: [
        colors.surfaceSecondary.withValues(alpha: 0.55),
        colors.black.withValues(alpha: 0.65),
      ],
      borderGradient: [
        colors.white.withValues(alpha: 0.08),
        colors.white.withValues(alpha: 0.04),
      ],
      blur: 24.0,
      noise: 0.06,
      bgBlur: 24.0,
      bgNoise: 0.06,
      enableShadow: true,
      shadowBlur: 28.0,
      shadowOpacity: 0.3,
      shadowOffsetY: 14.0,
    );
  }

  // ==========================================================================
  // LIQUID WHITE
  // ==========================================================================

  factory GlassEffects.liquidWhite(
    GlassColorPalette colors,
  ) {
    return GlassEffects(
      bgGradient: [
        colors.white.withValues(alpha: 0.12),
        colors.white.withValues(alpha: 0.02),
      ],
      borderGradient: [
        colors.white.withValues(alpha: 0.20),
        colors.white.withValues(alpha: 0.08),
      ],
      blur: 16.0,
      noise: 0.02,
      bgBlur: 16.0,
      bgNoise: 0.02,
      enableBorder: true,
      borderOpacity: 0.15,
    );
  }

  // ==========================================================================
  // STATIC PRESETS
  // ==========================================================================

  static GlassEffects get none {
    return const GlassEffects.empty();
  }

  static GlassEffects get classic {
    final GlassColorPalette colors =
        GlassColorPalette.defaults();

    return GlassEffects.liquidClassic(colors);
  }

  static GlassEffects get aqua {
    final GlassColorPalette colors =
        GlassColorPalette.defaults();

    return GlassEffects.liquidAqua(colors);
  }

  static GlassEffects get classicSubtle {
    final GlassColorPalette colors =
        GlassColorPalette.defaults();

    return GlassEffects.presetClassicSb(colors);
  }

  static GlassEffects get blue {
    final GlassColorPalette colors =
        GlassColorPalette.defaults();

    return GlassEffects.liquidBlue(colors);
  }

  static GlassEffects get red {
    final GlassColorPalette colors =
        GlassColorPalette.defaults();

    return GlassEffects.liquidRed(colors);
  }

  static GlassEffects get green {
    final GlassColorPalette colors =
        GlassColorPalette.defaults();

    return GlassEffects.liquidGreen(colors);
  }

  static GlassEffects get amber {
    final GlassColorPalette colors =
        GlassColorPalette.defaults();

    return GlassEffects.liquidAmber(colors);
  }

  static GlassEffects get dark {
    final GlassColorPalette colors =
        GlassColorPalette.defaults();

    return GlassEffects.liquidDark(colors);
  }

  static GlassEffects get white {
    final GlassColorPalette colors =
        GlassColorPalette.defaults();

    return GlassEffects.liquidWhite(colors);
  }

  // ==========================================================================
  // EQUALITY
  // ==========================================================================

  @override
  bool operator ==(covariant GlassEffects other) {
    if (identical(this, other)) {
      return true;
    }

    return listEquals(
          other.bgGradient,
          bgGradient,
        ) &&
        listEquals(
          other.borderGradient,
          borderGradient,
        ) &&
        other.blur == blur &&
        other.noise == noise &&
        other.bgBlur == bgBlur &&
        other.bgNoise == bgNoise &&
        other.surfaceOpacity == surfaceOpacity &&
        other.borderRadius == borderRadius &&
        other.enableBorder == enableBorder &&
        other.borderOpacity == borderOpacity &&
        other.borderWidth == borderWidth &&
        other.enableGlow == enableGlow &&
        other.glowOpacity == glowOpacity &&
        other.glowBlur == glowBlur &&
        other.enableShadow == enableShadow &&
        other.shadowOpacity == shadowOpacity &&
        other.shadowBlur == shadowBlur &&
        other.shadowOffsetY == shadowOffsetY &&
        other.tintColor == tintColor;
  }

  @override
  int get hashCode {
    return Object.hash(
      Object.hashAll(bgGradient),
      Object.hashAll(borderGradient),
      blur,
      noise,
      bgBlur,
      bgNoise,
      surfaceOpacity,
      borderRadius,
      enableBorder,
      borderOpacity,
      borderWidth,
      enableGlow,
      glowOpacity,
      glowBlur,
      enableShadow,
      shadowOpacity,
      shadowBlur,
      shadowOffsetY,
      tintColor,
    );
  }
}

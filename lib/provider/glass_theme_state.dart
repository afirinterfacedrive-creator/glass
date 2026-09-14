
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'package:universal_glass/theme/glass_color_palette.dart';
import 'package:universal_glass/theme/glass_display_settings.dart';
import 'package:universal_glass/theme/glass_effects.dart';
import 'package:universal_glass/utils/glass_classic_sb_decoration.dart';

import '../enums/glass_enums.dart';

/// ============================================================================
/// GLASS THEME STATE
/// ============================================================================
///
/// État central de toute l'apparence Universal Glass.
///
/// Cette classe reste volontairement immutable.
/// Toute modification passe par [copyWith].
///
/// Cette classe est autonome.
/// Elle ne dépend plus de [GlassThemeNotifier] ni d'une directive [part].
///
class GlassThemeState {
  // ==========================================================================
  // THEME
  // ==========================================================================

  final AppThemeMode themeMode;
  final GlassStyle glassStyle;
  final bool useAquaStyle;

  // ==========================================================================
  // GRADIENT
  // ==========================================================================

  final bool enableGradient;

  final List<Color> aquaGradient;
  final List<Color> classicGradient;
  final List<Color>? customGradientColors;

  final double gradientDensity;
  final double gradientOpacity;

  // ==========================================================================
  // BLUR / NOISE
  // ==========================================================================

  final double blur;
  final double noise;

  final bool enableBlur;
  final bool enableNoise;

  // ==========================================================================
  // SURFACE
  // ==========================================================================

  final double surfaceOpacity;
  final double borderRadius;

  // ==========================================================================
  // BORDER
  // ==========================================================================

  final bool enableBorder;
  final double borderOpacity;
  final double borderWidth;

  // ==========================================================================
  // GLOW
  // ==========================================================================

  final bool enableGlow;
  final double glowOpacity;
  final double glowBlur;

  // ==========================================================================
  // HOVER
  // ==========================================================================

  final bool enableHover;
  final double hoverLift;

  // ==========================================================================
  // SHADOW
  // ==========================================================================

  final bool enableShadow;
  final double shadowOpacity;
  final double shadowBlur;
  final double shadowOffsetY;

  // ==========================================================================
  // BREAKER
  // ==========================================================================

  final bool breakerOn;

  // ==========================================================================
  // DISPLAY
  // ==========================================================================

  /// Configuration globale de l'affichage.
  ///
  /// Contient notamment :
  ///
  /// - zoom ;
  /// - largeur maximale ;
  /// - padding ;
  /// - breakpoints ;
  /// - densité.
  final GlassDisplaySettings display;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const GlassThemeState({
    // ------------------------------------------------------------------------
    // THEME
    // ------------------------------------------------------------------------

    this.themeMode = AppThemeMode.aqua,

    this.glassStyle = GlassStyle.transparentAqua,

    this.useAquaStyle = true,

    // ------------------------------------------------------------------------
    // GRADIENT
    // ------------------------------------------------------------------------

    this.enableGradient = true,

    this.aquaGradient = const [
      Color(0xFF4DD0E1),
      Color(0xFF00BCD4),
    ],

    this.classicGradient = const [
      Color(0xFF121212),
      Color(0xFF1A1A1A),
    ],

    this.customGradientColors,

    this.gradientDensity = 2,

    this.gradientOpacity = 1.0,

    // ------------------------------------------------------------------------
    // BLUR / NOISE
    // ------------------------------------------------------------------------

    this.blur = 12.0,

    this.noise = 0.0,

    this.enableBlur = true,

    this.enableNoise = false,

    // ------------------------------------------------------------------------
    // SURFACE
    // ------------------------------------------------------------------------

    this.surfaceOpacity = 1.0,

    this.borderRadius = 20.0,

    // ------------------------------------------------------------------------
    // BORDER
    // ------------------------------------------------------------------------

    this.enableBorder = true,

    this.borderOpacity = 0.18,

    this.borderWidth = 0.72,

    // ------------------------------------------------------------------------
    // GLOW
    // ------------------------------------------------------------------------

    this.enableGlow = true,

    this.glowOpacity = 0.18,

    this.glowBlur = 18.0,

    // ------------------------------------------------------------------------
    // HOVER
    // ------------------------------------------------------------------------

    this.enableHover = true,

    this.hoverLift = 3.0,

    // ------------------------------------------------------------------------
    // SHADOW
    // ------------------------------------------------------------------------

    this.enableShadow = true,

    this.shadowOpacity = 0.18,

    this.shadowBlur = 12.0,

    this.shadowOffsetY = 7.0,

    // ------------------------------------------------------------------------
    // BREAKER
    // ------------------------------------------------------------------------

    this.breakerOn = false,

    // ------------------------------------------------------------------------
    // DISPLAY
    // ------------------------------------------------------------------------

    this.display = GlassDisplaySettings.defaults,
  });

  // ==========================================================================
  // EFFECTIVE BLUR
  // ==========================================================================

  double get effectiveBlur {
    if (!enableBlur) {
      return 0.0;
    }

    return blur.clamp(0.0, 100.0).toDouble();
  }

  // ==========================================================================
  // EFFECTIVE NOISE
  // ==========================================================================

  double get effectiveNoise {
    if (!enableNoise) {
      return 0.0;
    }

    return noise.clamp(0.0, 1.0).toDouble();
  }

  // ==========================================================================
  // EFFECTIVE ZOOM
  // ==========================================================================

  double get effectiveZoom {
    return display.zoom.clamp(0.50, 2.00).toDouble();
  }

  // ==========================================================================
  // STYLE
  // ==========================================================================

  GlassStyle get style {
    return glassStyle;
  }

  // ==========================================================================
  // PALETTE
  // ==========================================================================

  GlassColorPalette get palette {
    return GlassColorPalette.fromMode(
      themeMode,
    );
  }

  // ==========================================================================
  // EFFECTIVE GLASS STYLE
  // ==========================================================================

  GlassStyle get effectiveGlassStyle {
    return glassStyle;
  }

  // ==========================================================================
  // EFFECTS
  // ==========================================================================

  GlassEffects get effects {
    return GlassEffects.defaults().copyWith(
      // ----------------------------------------------------------------------
      // SURFACE
      // ----------------------------------------------------------------------

      surfaceOpacity: surfaceOpacity,

      // ----------------------------------------------------------------------
      // BLUR / NOISE
      // ----------------------------------------------------------------------
      //
      // blur et bgBlur sont volontairement synchronisés.
      //
      // Cela garantit notamment qu'une valeur explicite de 0.0 reste bien
      // 0.0 dans toutes les couches du moteur de rendu.
      //
      // Même logique pour noise et bgNoise.
      //

      blur: effectiveBlur,
      bgBlur: effectiveBlur,

      noise: effectiveNoise,
      bgNoise: effectiveNoise,

      // ----------------------------------------------------------------------
      // BORDER
      // ----------------------------------------------------------------------

      enableBorder: enableBorder,

      borderOpacity: borderOpacity,

      borderWidth: borderWidth,

      // ----------------------------------------------------------------------
      // GLOW
      // ----------------------------------------------------------------------

      enableGlow: enableGlow,

      glowOpacity: glowOpacity,

      glowBlur: glowBlur,

      // ----------------------------------------------------------------------
      // SHADOW
      // ----------------------------------------------------------------------

      enableShadow: enableShadow,

      shadowOpacity: shadowOpacity,

      shadowBlur: shadowBlur,

      shadowOffsetY: shadowOffsetY,
    );
  }

  // ==========================================================================
  // CLASSIC SB DECORATION
  // ==========================================================================

  BoxDecoration get classicSbDecoration {
    return GlassClassicSbDecoration.resolve(
      useAquaStyle: useAquaStyle,
      borderRadius: borderRadius,
    );
  }

  // ==========================================================================
  // EFFECTIVE DECORATION
  // ==========================================================================

  BoxDecoration get effectiveDecoration {
    switch (glassStyle) {
      case GlassStyle.classicSb:
        return classicSbDecoration;

      case GlassStyle.customGradient:
        final List<Color> colors = activeGradient;

        return BoxDecoration(
          borderRadius: BorderRadius.circular(
            borderRadius,
          ),
          gradient: colors.length >= 2
              ? LinearGradient(
                  colors: colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : colors.length == 1
                  ? LinearGradient(
                      colors: [
                        colors.first,
                        colors.first,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
        );

      default:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(
            borderRadius,
          ),
          color: palette.surface.withValues(
            alpha: surfaceOpacity
                .clamp(0.0, 1.0)
                .toDouble(),
          ),
          border: enableBorder
              ? Border.all(
                  color: Colors.white.withValues(
                    alpha: borderOpacity
                        .clamp(0.0, 1.0)
                        .toDouble(),
                  ),
                  width: borderWidth
                      .clamp(0.0, 10.0)
                      .toDouble(),
                )
              : null,
          boxShadow: enableShadow
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: shadowOpacity
                          .clamp(0.0, 1.0)
                          .toDouble(),
                    ),
                    blurRadius: shadowBlur
                        .clamp(0.0, 100.0)
                        .toDouble(),
                    offset: Offset(
                      0,
                      shadowOffsetY,
                    ),
                  ),
                ]
              : null,
        );
    }
  }

  // ==========================================================================
  // ACTIVE GRADIENT
  // ==========================================================================

  List<Color> get activeGradient {
    if (!enableGradient) {
      return const [];
    }

    final List<Color> base =
        customGradientColors?.isNotEmpty == true
            ? customGradientColors!
            : (
                useAquaStyle
                    ? aquaGradient
                    : classicGradient
              );

    if (base.isEmpty) {
      return const [];
    }

    final double density =
        gradientDensity.clamp(1.0, 10.0).toDouble();

    final List<Color> result = <Color>[];

    for (
      int i = 0;
      i < density && i < base.length;
      i++
    ) {
      result.add(base[i]);
    }

    while (result.length < density) {
      result.add(base.last);
    }

    final double opacity =
        gradientOpacity
            .clamp(0.0, 1.0)
            .toDouble();

    return result
        .map(
          (Color color) {
            return color.withValues(
              alpha: color.opacity * opacity,
            );
          },
        )
        .toList();
  }

  // ==========================================================================
  // COPY WITH
  // ==========================================================================

  GlassThemeState copyWith({
    // ------------------------------------------------------------------------
    // THEME
    // ------------------------------------------------------------------------

    AppThemeMode? themeMode,

    GlassStyle? glassStyle,

    bool? useAquaStyle,

    // ------------------------------------------------------------------------
    // GRADIENT
    // ------------------------------------------------------------------------

    bool? enableGradient,

    List<Color>? aquaGradient,

    List<Color>? classicGradient,

    List<Color>? customGradientColors,

    double? gradientDensity,

    double? gradientOpacity,

    // ------------------------------------------------------------------------
    // BLUR / NOISE
    // ------------------------------------------------------------------------

    double? blur,

    double? noise,

    bool? enableBlur,

    bool? enableNoise,

    // ------------------------------------------------------------------------
    // SURFACE
    // ------------------------------------------------------------------------

    double? surfaceOpacity,

    double? borderRadius,

    // ------------------------------------------------------------------------
    // BORDER
    // ------------------------------------------------------------------------

    bool? enableBorder,

    double? borderOpacity,

    double? borderWidth,

    // ------------------------------------------------------------------------
    // GLOW
    // ------------------------------------------------------------------------

    bool? enableGlow,

    double? glowOpacity,

    double? glowBlur,

    // ------------------------------------------------------------------------
    // HOVER
    // ------------------------------------------------------------------------

    bool? enableHover,

    double? hoverLift,

    // ------------------------------------------------------------------------
    // SHADOW
    // ------------------------------------------------------------------------

    bool? enableShadow,

    double? shadowOpacity,

    double? shadowBlur,

    double? shadowOffsetY,

    // ------------------------------------------------------------------------
    // BREAKER
    // ------------------------------------------------------------------------

    bool? breakerOn,

    // ------------------------------------------------------------------------
    // DISPLAY
    // ------------------------------------------------------------------------

    GlassDisplaySettings? display,
  }) {
    return GlassThemeState(
      // ----------------------------------------------------------------------
      // THEME
      // ----------------------------------------------------------------------

      themeMode:
          themeMode ?? this.themeMode,

      glassStyle:
          glassStyle ?? this.glassStyle,

      useAquaStyle:
          useAquaStyle ?? this.useAquaStyle,

      // ----------------------------------------------------------------------
      // GRADIENT
      // ----------------------------------------------------------------------

      enableGradient:
          enableGradient ??
              this.enableGradient,

      aquaGradient:
          aquaGradient ??
              this.aquaGradient,

      classicGradient:
          classicGradient ??
              this.classicGradient,

      customGradientColors:
          customGradientColors ??
              this.customGradientColors,

      gradientDensity:
          gradientDensity ??
              this.gradientDensity,

      gradientOpacity:
          gradientOpacity ??
              this.gradientOpacity,

      // ----------------------------------------------------------------------
      // BLUR / NOISE
      // ----------------------------------------------------------------------

      blur:
          blur ?? this.blur,

      noise:
          noise ?? this.noise,

      enableBlur:
          enableBlur ??
              this.enableBlur,

      enableNoise:
          enableNoise ??
              this.enableNoise,

      // ----------------------------------------------------------------------
      // SURFACE
      // ----------------------------------------------------------------------

      surfaceOpacity:
          surfaceOpacity ??
              this.surfaceOpacity,

      borderRadius:
          borderRadius ??
              this.borderRadius,

      // ----------------------------------------------------------------------
      // BORDER
      // ----------------------------------------------------------------------

      enableBorder:
          enableBorder ??
              this.enableBorder,

      borderOpacity:
          borderOpacity ??
              this.borderOpacity,

      borderWidth:
          borderWidth ??
              this.borderWidth,

      // ----------------------------------------------------------------------
      // GLOW
      // ----------------------------------------------------------------------

      enableGlow:
          enableGlow ??
              this.enableGlow,

      glowOpacity:
          glowOpacity ??
              this.glowOpacity,

      glowBlur:
          glowBlur ??
              this.glowBlur,

      // ----------------------------------------------------------------------
      // HOVER
      // ----------------------------------------------------------------------

      enableHover:
          enableHover ??
              this.enableHover,

      hoverLift:
          hoverLift ??
              this.hoverLift,

      // ----------------------------------------------------------------------
      // SHADOW
      // ----------------------------------------------------------------------

      enableShadow:
          enableShadow ??
              this.enableShadow,

      shadowOpacity:
          shadowOpacity ??
              this.shadowOpacity,

      shadowBlur:
          shadowBlur ??
              this.shadowBlur,

      shadowOffsetY:
          shadowOffsetY ??
              this.shadowOffsetY,

      // ----------------------------------------------------------------------
      // BREAKER
      // ----------------------------------------------------------------------

      breakerOn:
          breakerOn ??
              this.breakerOn,

      // ----------------------------------------------------------------------
      // DISPLAY
      // ----------------------------------------------------------------------

      display:
          display ??
              this.display,
    );
  }
}

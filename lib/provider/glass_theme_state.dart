// ignore_for_file: deprecated_member_use

part of 'glass_theme_provider.dart';

class GlassThemeState {
  final AppThemeMode themeMode;
  final GlassStyle glassStyle;
  final bool useAquaStyle;
  final bool enableGradient;
  final List<Color> aquaGradient;
  final List<Color> classicGradient;
  final List<Color>? customGradientColors;
  final int gradientDensity;
  final double gradientOpacity;
  final double blur;
  final double noise;
  final bool enableBlur;
  final bool enableNoise;
  final double surfaceOpacity;
  final double borderRadius;
  final bool enableBorder;
  final double borderOpacity;
  final double borderWidth;
  final bool enableGlow;
  final double glowOpacity;
  final double glowBlur;
  final bool enableHover;
  final double hoverLift;
  final bool enableShadow;
  final double shadowOpacity;
  final double shadowBlur;
  final double shadowOffsetY;
  final bool breakerOn;

  const GlassThemeState({
    this.themeMode = AppThemeMode.aqua,
    this.glassStyle = GlassStyle.transparentAqua,
    this.useAquaStyle = true,
    this.enableGradient = true,
    this.aquaGradient = const [Color(0xFF4DD0E1), Color(0xFF00BCD4)],
    this.classicGradient = const [Color(0xFF121212), Color(0xFF1A1A1A)],
    this.customGradientColors,
    this.gradientDensity = 2,
    this.gradientOpacity = 1.0,
    this.blur = 12.0,
    this.noise = 0.0,
    this.enableBlur = true,
    this.enableNoise = false,
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
    this.breakerOn = false,
  });

  double get effectiveBlur =>!enableBlur? 0.0 : blur.clamp(0.0, 100.0);
  double get effectiveNoise =>!enableNoise? 0.0 : noise.clamp(0.0, 1.0);

  bool get isSage => [
    AppThemeMode.sage,
    AppThemeMode.sagePro,
    AppThemeMode.sageOled,
    AppThemeMode.sageGlass
  ].contains(themeMode);

  GlassStyle get style => glassStyle;

  // ====================================================================
  // AJOUT : Decoration ClassicSB
  // ====================================================================
  BoxDecoration get classicSbDecoration {
    return GlassClassicSbDecoration.resolve(
      useAquaStyle: useAquaStyle,
      borderRadius: borderRadius,
    );
  }

  // ====================================================================
  // AJOUT : Resolver global
  // ====================================================================
  BoxDecoration get effectiveDecoration {
    switch (glassStyle) {
      case GlassStyle.classicSb:
        return classicSbDecoration;
      case GlassStyle.customGradient:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: LinearGradient(
            colors: activeGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        );
      default:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: Colors.white.withValues(alpha: surfaceOpacity),
          border: enableBorder
             ? Border.all(
                  color: Colors.white.withValues(alpha: borderOpacity),
                  width: borderWidth)
              : null,
          boxShadow: enableShadow
             ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: shadowOpacity),
                    blurRadius: shadowBlur,
                    offset: Offset(0, shadowOffsetY),
                  )
                ]
              : null,
        );
    }
  }

  List<Color> get activeGradient {
    if (!enableGradient) return [];
    List<Color> base = customGradientColors?? (useAquaStyle? aquaGradient : classicGradient);
    final List<Color> result = [];
    for (int i = 0; i < gradientDensity && i < base.length; i++) {
      result.add(base[i]);
    }
    while (result.length < gradientDensity) {
      result.add(base.last);
    }
    return result.map((c) => c.withValues(alpha: c.opacity * gradientOpacity)).toList();
  }

  GlassThemeState copyWith({
    AppThemeMode? themeMode,
    GlassStyle? glassStyle,
    bool? useAquaStyle,
    bool? enableGradient,
    List<Color>? aquaGradient,
    List<Color>? classicGradient,
    List<Color>? customGradientColors,
    int? gradientDensity,
    double? gradientOpacity,
    double? blur,
    double? noise,
    bool? enableBlur,
    bool? enableNoise,
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
    bool? breakerOn,
  }) {
    return GlassThemeState(
      themeMode: themeMode?? this.themeMode,
      glassStyle: glassStyle?? this.glassStyle,
      useAquaStyle: useAquaStyle?? this.useAquaStyle,
      enableGradient: enableGradient?? this.enableGradient,
      aquaGradient: aquaGradient?? this.aquaGradient,
      classicGradient: classicGradient?? this.classicGradient,
      customGradientColors: customGradientColors?? this.customGradientColors,
      gradientDensity: gradientDensity?? this.gradientDensity,
      gradientOpacity: gradientOpacity?? this.gradientOpacity,
      blur: blur?? this.blur,
      noise: noise?? this.noise,
      enableBlur: enableBlur?? this.enableBlur,
      enableNoise: enableNoise?? this.enableNoise,
      surfaceOpacity: surfaceOpacity?? this.surfaceOpacity,
      borderRadius: borderRadius?? this.borderRadius,
      enableBorder: enableBorder?? this.enableBorder,
      borderOpacity: borderOpacity?? this.borderOpacity,
      borderWidth: borderWidth?? this.borderWidth,
      enableGlow: enableGlow?? this.enableGlow,
      glowOpacity: glowOpacity?? this.glowOpacity,
      glowBlur: glowBlur?? this.glowBlur,
      enableHover: enableHover?? this.enableHover,
      hoverLift: hoverLift?? this.hoverLift,
      enableShadow: enableShadow?? this.enableShadow,
      shadowOpacity: shadowOpacity?? this.shadowOpacity,
      shadowBlur: shadowBlur?? this.shadowBlur,
      shadowOffsetY: shadowOffsetY?? this.shadowOffsetY,
      breakerOn: breakerOn?? this.breakerOn,
    );
  }
}
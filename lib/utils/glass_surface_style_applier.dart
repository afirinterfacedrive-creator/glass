import 'package:flutter/material.dart';
import 'package:universal_glass/components/surface/glass_surface_style.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/provider/glass_theme_provider.dart';
import 'package:universal_glass/theme/glass_color_palette.dart';
import 'package:universal_glass/theme/glass_effects.dart';
import 'package:universal_glass/utils/glass_surface_gradient.dart';
import 'package:universal_glass/utils/glass_surface_gradient_resolver.dart';
import 'package:universal_glass/components/inputs/glass_input_decoration.dart';

class GlassSurfaceRenderData {
  final List<Color> gradientColors;
  final List<double>? gradientStops;
  final Color borderColor;
  final double borderWidth;
  final BorderRadius radius;
  final List<BoxShadow> boxShadow;
  final Color contentColor;
  final double bgBlur;
  final double bgNoise;
  final bool animateHover;
  final EdgeInsetsGeometry padding;

  const GlassSurfaceRenderData({
    required this.gradientColors,
    required this.gradientStops,
    required this.borderColor,
    required this.borderWidth,
    required this.radius,
    required this.boxShadow,
    required this.contentColor,
    required this.bgBlur,
    required this.bgNoise,
    required this.animateHover,
    required this.padding,
  });
}

class GlassSurfaceStyleApplier {
  static GlassSurfaceRenderData apply({
    required BuildContext context,
    required GlassStyle style,
    required GlassInputDecoration decoration,
    required GlassEffects? effects,
    required bool isFocused,
    required bool hasError,
    required bool enabled,
    required bool liftOnHover,
    required bool isHovered,
    required BorderRadius? borderRadius,
    required GlassThemeState theme,
    required List<Color>? customGradient,
    required List<Color>? loadedGradient,
    required List<Color>? customColorsAqua,
    required List<Color>? customColorsClassic,
    bool isBodySurface = false, // <- AJOUT 1: Flag pour couper le blur dans le body
  }) {
    final GlassSurfaceStyle surfaceStyle = GlassSurfaceStyle(style);
    final bool isClassicSb = style == GlassStyle.classicSb;
    final bool useAquaStyle = theme.useAquaStyle;

    final AppThemeMode activeMode = surfaceStyle.isSageStyle
        ? AppThemeMode.sage
        : useAquaStyle
            ? AppThemeMode.aqua
            : AppThemeMode.classic;

    final GlassColorPalette palette = GlassColorPalette.fromMode(activeMode);
    final Color primary = palette.primaryForMode(activeMode);
    final Color light = palette.lightForMode(activeMode);
    final Color dark = palette.darkForMode(activeMode);
    final Color accent = useAquaStyle ? Colors.cyanAccent : Colors.orangeAccent;

    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool isSmallMobile = screenWidth < 375;

    final bool animateHover = isClassicSb
        ? false
        : surfaceStyle.shouldAnimateHover(liftOnHover: liftOnHover, enabled: enabled);

    // FIX: Si isBodySurface = true on force blur à 0
    final double bgBlur = surfaceStyle.isGhost || isClassicSb || isBodySurface 
        ? 0.0 
        : surfaceStyle.getBgBlur(effects: effects, theme: theme);
    
    final double bgNoise = surfaceStyle.isGhost || isClassicSb || isBodySurface 
        ? 0.0 
        : surfaceStyle.getBgNoise(effects: effects, theme: theme);

    final double baseAlpha = surfaceStyle.isGhost ? 0.0 : surfaceStyle.baseAlpha;
    final double disabledAlpha = surfaceStyle.getDisabledAlpha(enabled);

    // 1. GRADIENT
    final GlassGradientResolution gradientRes = GlassSurfaceGradientResolver.resolve(
      style: style,
      isClassicSb: isClassicSb,
      useAquaStyle: useAquaStyle,
      accent: accent,
      baseAlpha: baseAlpha,
      disabledAlpha: disabledAlpha,
      palette: palette,
      theme: theme,
      customGradient: customGradient,
      loadedGradient: loadedGradient,
      originalResolver: () => GlassSurfaceGradient.resolve(
        style: style,
        useAquaStyle: useAquaStyle,
        baseAlpha: baseAlpha * disabledAlpha,
        palette: palette,
        theme: theme,
        customGradient: customGradient,
        loadedGradient: loadedGradient,
      ),
    );

    // 2. BORDER
    final Color borderColor = surfaceStyle.isGhost
        ? Colors.transparent
        : isClassicSb
            ? accent.withValues(alpha: .10)
            : hasError
                ? palette.error.withValues(alpha: isHovered ? 0.46 : 0.38)
                : isFocused
                    ? light.withValues(alpha: 0.55)
                    : isHovered
                        ? light.withValues(alpha: 0.35)
                        : activeMode == AppThemeMode.aqua
                            ? primary.withValues(alpha: isSmallMobile ? 0.08 : 0.18)
                            : primary.withValues(alpha: isSmallMobile ? 0.15 : 0.28);

    final double borderWidth = surfaceStyle.isGhost
        ? 0.0
        : isClassicSb
            ? 1.0
            : hasError || isFocused
                ? 1.2
                : isHovered
                    ? 0.95
                    : isSmallMobile
                        ? 0.6
                        : 0.72;

    // 3. RADIUS
    final BorderRadius radius = borderRadius ??
        (surfaceStyle.isSageStyle
            ? BorderRadius.circular(16)
            : isClassicSb
                ? BorderRadius.circular(26)
                : BorderRadius.circular(isSmallMobile ? 12 : 20));

    // 4. SHADOW
    final double shadowBlur = isFocused ? 18.0 : 12.0;
    final List<BoxShadow> cardGlow = surfaceStyle.isGhost
        ? []
        : isClassicSb
            ? [BoxShadow(color: Colors.black.withValues(alpha: .18), blurRadius: 24, offset: const Offset(0, 10))]
            : surfaceStyle.isSageStyle
                ? [BoxShadow(color: palette.sage.withValues(alpha: 0.35), blurRadius: 10, spreadRadius: 0)]
                : isFocused
                    ? [
                        BoxShadow(color: primary.withValues(alpha: useAquaStyle ? 0.13 : 0.19), blurRadius: shadowBlur + 8, offset: Offset.zero),
                        BoxShadow(color: dark.withValues(alpha: 0.12), blurRadius: shadowBlur + 4, offset: const Offset(0, 7)),
                      ]
                    : [BoxShadow(color: palette.black.withValues(alpha: useAquaStyle ? 0.14 : 0.22), blurRadius: shadowBlur, offset: const Offset(0, 7))];

    // 5. CONTENT COLOR
    final Color contentColor = isClassicSb
        ? Colors.white
        : surfaceStyle.forceLightText
            ? Colors.white.withValues(alpha: disabledAlpha)
            : enabled
                ? palette.textPrimary
                : palette.textPrimary.withValues(alpha: 0.40);

    // 6. PADDING
    final EdgeInsetsGeometry responsivePadding = surfaceStyle.getResponsivePadding(
      context: context,
      padding: null,
      horizontalPadding: decoration.safeHorizontalPadding,
      verticalPadding: decoration.safeVerticalPadding,
    );

    return GlassSurfaceRenderData(
      gradientColors: gradientRes.colors,
      gradientStops: gradientRes.stops,
      borderColor: borderColor,
      borderWidth: borderWidth,
      radius: radius,
      boxShadow: cardGlow,
      contentColor: contentColor,
      bgBlur: bgBlur,
      bgNoise: bgNoise,
      animateHover: animateHover,
      padding: responsivePadding,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:universal_glass/components/inputs/glass_input_decoration.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/provider/glass_theme_provider.dart';
import 'package:universal_glass/theme/glass_color_palette.dart';
import 'package:universal_glass/theme/glass_effects.dart';
import 'package:universal_glass/utils/glass_classic_sb_decoration.dart';
import 'package:universal_glass/utils/glass_surface_gradient.dart';
import 'package:universal_glass/utils/glass_surface_gradient_resolver.dart';
import 'glass_content_style.dart';
import 'glass_surface_config.dart';
import 'glass_surface_layers.dart';
import 'glass_surface_style.dart';

class GlassSurfaceRenderer extends StatelessWidget {
  final Widget child;
  final GlassInputDecoration decoration;
  final GlassSurfaceConfig config;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Clip clipBehavior;
  final String? errorText;
  final VoidCallback? onTap;
  final ValueChanged<bool> onHoverChanged;

  const GlassSurfaceRenderer({
    super.key,
    required this.child,
    required this.decoration,
    required this.config,
    required this.onHoverChanged,
    this.onTap,
    this.width,
    this.height,
    this.constraints,
    this.padding,
    this.borderRadius,
    this.clipBehavior = Clip.antiAlias,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final GlassSurfaceConfig cfg = config;
    final GlassThemeState theme = cfg.theme;
    final GlassSurfaceStyle surfaceStyle = GlassSurfaceStyle(cfg.style);
    final GlassEffects effects = cfg.effects ?? GlassEffects.defaults();
    final bool isClassicSb = cfg.style == GlassStyle.classicSb;
    final bool isTransparentAqua = cfg.style == GlassStyle.transparentAqua;
    final bool useAquaStyle = theme.useAquaStyle;

    final AppThemeMode activeMode = surfaceStyle.isSageStyle ? AppThemeMode.sage : useAquaStyle ? AppThemeMode.aqua : AppThemeMode.classic;
    final GlassColorPalette palette = GlassColorPalette.fromMode(activeMode);
    final Color primary = palette.primaryForMode(activeMode);
    final Color light = palette.lightForMode(activeMode);
    final Color accent = useAquaStyle ? Colors.cyanAccent : Colors.orangeAccent;

    final bool animateHover = isClassicSb ? false : surfaceStyle.shouldAnimateHover(liftOnHover: cfg.liftOnHover, enabled: cfg.enabled);

    final double bgBlur = surfaceStyle.getBgBlur(effects: effects, theme: theme).clamp(0.0, 100.0);
    final double bgNoise = surfaceStyle.getBgNoise(effects: effects, theme: theme).clamp(0.0, 1.0);

    final double styleAlpha = surfaceStyle.isGhost ? 0.0 : surfaceStyle.baseAlpha;
    final double disabledAlpha = surfaceStyle.getDisabledAlpha(cfg.enabled);
    final double liveSurfaceOpacity = effects.surfaceOpacity.clamp(0.0, 1.0);
    final double surfaceAlpha = (styleAlpha * liveSurfaceOpacity * disabledAlpha).clamp(0.0, 1.0);

    final GlassGradientResolution gradientRes = GlassSurfaceGradientResolver.resolve(
      style: cfg.style,
      isClassicSb: isClassicSb,
      useAquaStyle: useAquaStyle,
      accent: accent,
      baseAlpha: styleAlpha,
      disabledAlpha: disabledAlpha,
      palette: palette,
      theme: theme,
      customGradient: cfg.customGradient,
      loadedGradient: cfg.loadedGradient,
      originalResolver: () => GlassSurfaceGradient.resolve(
        style: cfg.style,
        useAquaStyle: useAquaStyle,
        baseAlpha: surfaceAlpha,
        palette: palette,
        theme: theme,
        customGradient: cfg.customGradient,
        loadedGradient: cfg.loadedGradient,
      ),
    );

    final List<Color> gradientColors = gradientRes.colors.map((Color color) {
      // ignore: deprecated_member_use
      final double targetAlpha = (color.opacity * liveSurfaceOpacity).clamp(0.0, 1.0);
      return color.withValues(alpha: targetAlpha);
    }).toList();
    final List<double>? gradientStops = gradientRes.stops;

    final Color defaultBorderBaseColor = surfaceStyle.isGhost ? Colors.transparent : isClassicSb ? accent : cfg.hasError ? palette.error : cfg.isHovered ? light : primary;
    final double liveBorderOpacity = effects.borderOpacity.clamp(0.0, 1.0);
    final Color defaultBorderColor = defaultBorderBaseColor.withValues(alpha: surfaceStyle.isGhost ? 0.0 : liveBorderOpacity);

    Color resolveDecorationBorderColor(Color color) => color.withValues(alpha: liveBorderOpacity);

    final Color borderColor = surfaceStyle.isGhost
        ? Colors.transparent
        : cfg.hasError
            ? palette.error.withValues(alpha: liveBorderOpacity)
            : cfg.isFocused
                ? cfg.focusBorderColor != null ? resolveDecorationBorderColor(cfg.focusBorderColor!) : light.withValues(alpha: liveBorderOpacity)
                : cfg.borderColor != null ? resolveDecorationBorderColor(cfg.borderColor!) : defaultBorderColor;

    final double liveBorderWidth = effects.borderWidth.clamp(0.0, 12.0);
    final double focusBorderWidth = cfg.focusBorderWidth ?? liveBorderWidth;
    final double borderWidth = surfaceStyle.isGhost ? 0.0 : !theme.enableBorder ? 0.0 : cfg.isFocused ? focusBorderWidth.clamp(0.0, 12.0) : liveBorderWidth;

    final BorderRadius radius = borderRadius ?? BorderRadius.circular(theme.borderRadius.clamp(0.0, 160.0));

    final double shadowBlur = effects.shadowBlur.clamp(0.0, 100.0);
    final double shadowOpacity = effects.shadowOpacity.clamp(0.0, 1.0);
    final double shadowOffsetY = effects.shadowOffsetY.clamp(-100.0, 100.0);

    final double glowBlur = effects.glowBlur.clamp(0.0, 100.0);
    final double glowOpacity = effects.glowOpacity.clamp(0.0, 1.0);

    final List<BoxShadow> cardGlow = surfaceStyle.isGhost
        ? <BoxShadow>[]
        : <BoxShadow>[
            if (effects.enableGlow && glowOpacity > 0.0 && glowBlur > 0.0)
              BoxShadow(color: (surfaceStyle.isSageStyle ? palette.sage : primary).withValues(alpha: glowOpacity), blurRadius: glowBlur, spreadRadius: 0.0, offset: Offset.zero),
            if (effects.enableShadow && shadowOpacity > 0.0 && shadowBlur > 0.0)
              BoxShadow(color: palette.black.withValues(alpha: shadowOpacity), blurRadius: shadowBlur, spreadRadius: 0.0, offset: Offset(0.0, shadowOffsetY)),
          ];

    final List<BoxShadow> effectiveClassicSbShadows = isClassicSb && effects.enableShadow && shadowOpacity > 0.0 && shadowBlur > 0.0
        ? <BoxShadow>[BoxShadow(color: Colors.black.withValues(alpha: shadowOpacity), blurRadius: shadowBlur, spreadRadius: 0.0, offset: Offset(0.0, shadowOffsetY))]
        : <BoxShadow>[];

    final Color contentColor = isClassicSb
        ? Colors.white
        : surfaceStyle.forceLightText
            ? Colors.white.withValues(alpha: disabledAlpha)
            : cfg.enabled
                ? palette.textPrimary
                : palette.textPrimary.withValues(alpha: 0.40);

    final EdgeInsetsGeometry responsivePadding = surfaceStyle.getResponsivePadding(
      context: context,
      padding: padding,
      horizontalPadding: decoration.safeHorizontalPadding,
      verticalPadding: decoration.safeVerticalPadding,
    );

    final BoxDecoration finalDecoration = isClassicSb
        ? GlassClassicSbDecoration.resolve(useAquaStyle: useAquaStyle, borderRadius: radius.topLeft.x).copyWith(
            border: theme.enableBorder && borderWidth > 0.0 ? Border.all(color: borderColor, width: borderWidth) : null,
            boxShadow: effectiveClassicSbShadows,
          )
        : isTransparentAqua
            ? BoxDecoration(
                color: Colors.transparent,
                borderRadius: radius,
                border: theme.enableBorder && borderWidth > 0.0 ? Border.all(color: borderColor, width: borderWidth) : null,
                boxShadow: cardGlow,
              )
            : BoxDecoration(
                gradient: gradientColors.isEmpty ? null : LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: gradientColors, stops: gradientStops),
                color: gradientColors.isEmpty ? primary.withValues(alpha: surfaceAlpha) : null,
                borderRadius: radius,
                border: surfaceStyle.isGhost || !theme.enableBorder || borderWidth <= 0.0 ? null : Border.all(color: borderColor, width: borderWidth),
                boxShadow: cardGlow,
              );

    Widget surface = AnimatedContainer(
      duration: animateHover ? const Duration(milliseconds: 180) : Duration.zero,
      curve: Curves.easeOut,
      width: width,
      height: height,
      constraints: constraints,
      transform: Matrix4.translationValues(0.0, animateHover && cfg.isHovered ? -theme.hoverLift.clamp(0.0, 30.0) : 0.0, 0.0),
      padding: responsivePadding,
      decoration: finalDecoration,
      child: GlassContentStyle(decoration: decoration, contentColor: contentColor, child: child),
    );

    final Widget glassLayer = surfaceStyle.isGhost ? surface : GlassSurfaceLayers(surface: surface, radius: radius, blur: bgBlur, noise: bgNoise, clipBehavior: clipBehavior);

    Widget content = Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(onTap: cfg.enabled ? onTap : null, borderRadius: radius, excludeFromSemantics: !animateHover, child: glassLayer),
    );

    if (animateHover) {
      content = MouseRegion(
        cursor: cfg.enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: (_) { if (cfg.enabled && !cfg.isHovered) onHoverChanged(true); },
        onExit: (_) { if (cfg.isHovered) onHoverChanged(false); },
        child: content,
      );
    }

    return content;
  }
}
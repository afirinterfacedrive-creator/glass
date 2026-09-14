import 'package:flutter/material.dart';

import 'package:universal_glass/constants/app_constants.dart';
import 'package:universal_glass/provider/glass_theme_state.dart';
import 'package:universal_glass/utils/glass_input_decoration.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/theme/glass_color_palette.dart';
import 'package:universal_glass/theme/glass_effects.dart';
import 'package:universal_glass/utils/glass_classic_sb_decoration.dart';
import 'package:universal_glass/components/surface/glass_surface_gradient.dart';
import 'package:universal_glass/components/surface/glass_surface_gradient_resolver.dart';

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

  // ===========================================================================
  // TINT COLOR
  // ===========================================================================

  Color _getTintColor(
    GlassStyle style,
    GlassColorPalette palette,
    bool useAqua,
  ) {
    switch (style) {
      case GlassStyle.transparentRed:
        return AppConstants.transparentRed;

      case GlassStyle.transparentGreen:
        return AppConstants.transparentGreen;

      case GlassStyle.transparentAqua:
        return useAqua
            ? AppConstants.aquaAccent
            : AppConstants.classicAccent;

      default:
        return palette.primary;
    }
  }

  // ===========================================================================
  // ROLE TINT
  // ===========================================================================

  double _getRoleTintMultiplier(
    GlassSurfaceRole role,
  ) {
    switch (role) {
      case GlassSurfaceRole.card:
        return AppConstants.roleTintCard;

      case GlassSurfaceRole.field:
        return AppConstants.roleTintField;

      case GlassSurfaceRole.panel:
        return AppConstants.roleTintPanel;

      case GlassSurfaceRole.header:
        return AppConstants.roleTintHeader;

      case GlassSurfaceRole.body:
        return AppConstants.roleTintBody;

      case GlassSurfaceRole.footer:
        return AppConstants.roleTintFooter;

      case GlassSurfaceRole.dialog:
        return AppConstants.roleTintDialog;

      case GlassSurfaceRole.modal:
        return AppConstants.roleTintModal;

      case GlassSurfaceRole.tooltip:
        return AppConstants.roleTintTooltip;

      case GlassSurfaceRole.menu:
        return AppConstants.roleTintMenu;

      case GlassSurfaceRole.appBar:
        return AppConstants.appBarTintMultiplier;
    }
  }

  // ===========================================================================
  // BORDER
  // ===========================================================================

  Border? _buildBorder({
    required bool enabled,
    required double width,
    required Color color,
  }) {
    if (!enabled ||
        width <= AppConstants.minBorderWidth) {
      return null;
    }

    return Border.all(
      color: color,
      width: width,
    );
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final GlassSurfaceConfig cfg = config;

    final GlassThemeState theme = cfg.theme;

    final GlassSurfaceStyle surfaceStyle =
        GlassSurfaceStyle(cfg.style);

    final GlassEffects effects =
        cfg.effects ?? GlassEffects.defaults();

    // =========================================================================
    // STYLE
    // =========================================================================

    final GlassStyle style = cfg.style;

    final bool isClassicSb =
        style == GlassStyle.classicSb;

    final bool isTransparentTinted =
        surfaceStyle.isTransparentTinted;

    final bool isOpaque =
        surfaceStyle.isOpaque;

    final bool useAquaStyle =
        theme.useAquaStyle;

    final GlassSurfaceRole role =
        cfg.role;

    // =========================================================================
    // PALETTE
    // =========================================================================

    final AppThemeMode activeMode =
        useAquaStyle
            ? AppThemeMode.aqua
            : AppThemeMode.classic;

    final GlassColorPalette palette =
        GlassColorPalette.fromMode(
      activeMode,
    );

    final Color primary =
        palette.primaryForMode(
      activeMode,
    );

    final Color light =
        palette.lightForMode(
      activeMode,
    );

    final Color accent =
        useAquaStyle
            ? AppConstants.aquaAccent
            : AppConstants.classicAccent;

    // =========================================================================
    // TINT
    // =========================================================================

    final Color styleTintColor =
        _getTintColor(
      style,
      palette,
      useAquaStyle,
    );

    final Color tintColor =
        effects.tintColor ??
        (
          isTransparentTinted
              ? styleTintColor
              : cfg.backgroundColor ??
                  styleTintColor
        );

    // =========================================================================
    // BACKDROP BLUR
    // =========================================================================

    final double bgBlur =
        isOpaque || isClassicSb
            ? AppConstants.minBlur
            : surfaceStyle
                .getBgBlur(
                  theme: theme,
                  role: role,
                )
                .clamp(
                  AppConstants.minBlur,
                  AppConstants.maxBlur,
                )
                .toDouble();

    // =========================================================================
    // NOISE
    // =========================================================================

    final double bgNoise =
        isClassicSb
            ? AppConstants.minNoise
            : surfaceStyle
                .getBgNoise(
                  theme: theme,
                  role: role,
                )
                .clamp(
                  AppConstants.minNoise,
                  AppConstants.maxNoise,
                )
                .toDouble();

    // =========================================================================
    // SURFACE OPACITY
    // =========================================================================

    final double styleAlpha =
        surfaceStyle.baseAlpha;

    final double disabledAlpha =
        surfaceStyle.getDisabledAlpha(
      cfg.enabled,
    );

    final double liveSurfaceOpacity =
        effects.surfaceOpacity
            .clamp(
              AppConstants.transparentOpacity,
              AppConstants.fullOpacity,
            )
            .toDouble();

    final double roleAlpha =
        surfaceStyle.getRoleAlphaMultiplier(
      role,
    );

    final double calculatedSurfaceAlpha =
        (
          styleAlpha *
          roleAlpha *
          liveSurfaceOpacity *
          disabledAlpha
        ).clamp(
          AppConstants.transparentOpacity,
          AppConstants.fullOpacity,
        ).toDouble();

    // =========================================================================
    // APP BAR MINIMUM OPACITY
    // =========================================================================
    //
    // Une AppBar ne doit jamais devenir réellement transparente.
    //
    // Même si le style, le rôle ou les réglages produisent une faible opacité,
    // on conserve au minimum AppConstants.appBarMinimumAlpha.
    // =========================================================================

    final double surfaceAlpha =
        role == GlassSurfaceRole.appBar
            ? calculatedSurfaceAlpha
                .clamp(
                  AppConstants.appBarMinimumAlpha,
                  AppConstants.fullOpacity,
                )
                .toDouble()
            : calculatedSurfaceAlpha;

    // =========================================================================
    // GRADIENT RESOLUTION
    // =========================================================================
    //
    // IMPORTANT :
    //
    // Le renderer fournit l'alpha FINAL de la surface au resolver.
    //
    // Le resolver délègue ensuite à GlassSurfaceGradient.
    //
    // Il n'y a donc plus de seconde multiplication de :
    //
    //   liveSurfaceOpacity
    //   disabledAlpha
    //
    // après résolution du gradient.
    // =========================================================================

    final bool gradientEnabled =
        theme.enableGradient;

    final GlassGradientResolution gradientRes =
        gradientEnabled
            ? GlassSurfaceGradientResolver.resolve(
                style: style,
                isClassicSb: isClassicSb,
                useAquaStyle: useAquaStyle,
                accent: accent,

                // Alpha final de la surface.
                baseAlpha: surfaceAlpha,

                // Conservé dans l'API du resolver pour compatibilité.
                disabledAlpha: disabledAlpha,

                palette: palette,
                theme: theme,

                customGradient:
                    cfg.customGradient,

                loadedGradient:
                    cfg.loadedGradient,

                originalResolver: () =>
                    GlassSurfaceGradient.resolve(
                  style: style,
                  useAquaStyle: useAquaStyle,
                  baseAlpha: surfaceAlpha,
                  palette: palette,
                  theme: theme,
                  customGradient:
                      cfg.customGradient,
                  loadedGradient:
                      cfg.loadedGradient,
                ),
              )
            : const GlassGradientResolution(
                colors: <Color>[],
                stops: null,
              );

    // =========================================================================
    // FINAL GRADIENT COLORS
    // =========================================================================
    //
    // Le resolver a déjà reçu surfaceAlpha.
    //
    // On conserve donc l'alpha intrinsèque de chaque couleur.
    //
    // Pour l'AppBar uniquement, on garantit le minimum visuel défini par
    // AppConstants.appBarMinimumAlpha.
    // =========================================================================

    final List<Color> resolvedGradientColors =
        gradientRes.colors
            .map(
              (Color color) {
                final double finalAlpha =
                    role == GlassSurfaceRole.appBar
                        ? color.a
                            .clamp(
                              AppConstants.appBarMinimumAlpha,
                              AppConstants.fullOpacity,
                            )
                            .toDouble()
                        : color.a
                            .clamp(
                              AppConstants.transparentOpacity,
                              AppConstants.fullOpacity,
                            )
                            .toDouble();

                return color.withValues(
                  alpha: finalAlpha,
                );
              },
            )
            .toList();

    final List<double>? gradientStops =
        gradientRes.stops;

    // =========================================================================
    // BORDER COLOR
    // =========================================================================

    final Color defaultBorderBaseColor =
        isClassicSb
            ? accent
            : isTransparentTinted
                ? tintColor
                : cfg.hasError
                    ? palette.error
                    : cfg.isHovered
                        ? light
                        : primary;

    final double liveBorderOpacity =
        effects.borderOpacity
            .clamp(
              AppConstants.minBorderOpacity,
              AppConstants.maxBorderOpacity,
            )
            .toDouble();

    final Color defaultBorderColor =
        defaultBorderBaseColor.withValues(
      alpha: liveBorderOpacity,
    );

    Color resolveDecorationBorderColor(
      Color color,
    ) {
      return color.withValues(
        alpha: liveBorderOpacity,
      );
    }

    // =========================================================================
    // BORDER STATE
    // =========================================================================

    final Color borderColor =
        cfg.hasError
            ? palette.error.withValues(
                alpha: liveBorderOpacity,
              )
            : cfg.isFocused
                ? cfg.focusBorderColor != null
                    ? resolveDecorationBorderColor(
                        cfg.focusBorderColor!,
                      )
                    : light.withValues(
                        alpha: liveBorderOpacity,
                      )
                : cfg.borderColor != null
                    ? resolveDecorationBorderColor(
                        cfg.borderColor!,
                      )
                    : defaultBorderColor;

    // =========================================================================
    // BORDER WIDTH
    // =========================================================================

    final double liveBorderWidth =
        effects.borderWidth
            .clamp(
              AppConstants.minBorderWidth,
              AppConstants.maxBorderWidth,
            )
            .toDouble();

    final double focusBorderWidth =
        cfg.focusBorderWidth ??
        liveBorderWidth;

    final double errorBorderWidth =
        cfg.errorBorderWidth ??
        liveBorderWidth;

    final bool borderEnabled =
        theme.enableBorder &&
        effects.enableBorder;

    final double borderWidth =
        !borderEnabled
            ? AppConstants.minBorderWidth
            : cfg.hasError
                ? errorBorderWidth
                    .clamp(
                      AppConstants.minBorderWidth,
                      AppConstants.maxBorderWidth,
                    )
                    .toDouble()
                : cfg.isFocused
                    ? focusBorderWidth
                        .clamp(
                          AppConstants.minBorderWidth,
                          AppConstants.maxBorderWidth,
                        )
                        .toDouble()
                    : liveBorderWidth;

    // =========================================================================
    // RADIUS
    // =========================================================================

    final BorderRadius radius =
        borderRadius ??
        BorderRadius.circular(
          theme.borderRadius
              .clamp(
                AppConstants.minBorderRadius,
                AppConstants.maxBorderRadius,
              )
              .toDouble(),
        );

    // =========================================================================
    // SHADOW
    // =========================================================================

    final double shadowBlur =
        effects.shadowBlur
            .clamp(
              AppConstants.minShadowBlur,
              AppConstants.maxShadowBlur,
            )
            .toDouble();

    final double shadowOpacity =
        effects.shadowOpacity
            .clamp(
              AppConstants.minShadowOpacity,
              AppConstants.maxShadowOpacity,
            )
            .toDouble();

    final double shadowOffsetY =
        effects.shadowOffsetY
            .clamp(
              AppConstants.minShadowOffsetY,
              AppConstants.maxShadowOffsetY,
            )
            .toDouble();

    final double depthMultiplier =
        surfaceStyle.getRoleDepthMultiplier(
      role,
    );

    final double effectiveShadowBlur =
        (shadowBlur * depthMultiplier)
            .clamp(
              AppConstants.minShadowBlur,
              AppConstants.maxShadowBlur,
            )
            .toDouble();

    final double effectiveShadowOpacity =
        (shadowOpacity * depthMultiplier)
            .clamp(
              AppConstants.minShadowOpacity,
              AppConstants.maxShadowOpacity,
            )
            .toDouble();

    // =========================================================================
    // GLOW
    // =========================================================================

    final double glowBlur =
        effects.glowBlur
            .clamp(
              AppConstants.minGlowBlur,
              AppConstants.maxGlowBlur,
            )
            .toDouble();

    final double glowOpacity =
        effects.glowOpacity
            .clamp(
              AppConstants.minGlowOpacity,
              AppConstants.maxGlowOpacity,
            )
            .toDouble();

    final Color glowColor =
        isTransparentTinted
            ? tintColor
            : primary;

    // =========================================================================
    // SHADOWS / GLOW
    // =========================================================================

    final List<BoxShadow> cardGlow =
        <BoxShadow>[
      if (effects.enableGlow &&
          glowOpacity >
              AppConstants.minGlowOpacity &&
          glowBlur >
              AppConstants.minGlowBlur)
        BoxShadow(
          color: glowColor.withValues(
            alpha: glowOpacity,
          ),
          blurRadius: glowBlur,
          spreadRadius:
              AppConstants.transparentOpacity,
          offset: Offset.zero,
        ),
      if (effects.enableShadow &&
          effectiveShadowOpacity >
              AppConstants.minShadowOpacity &&
          effectiveShadowBlur >
              AppConstants.minShadowBlur)
        BoxShadow(
          color: palette.black.withValues(
            alpha: effectiveShadowOpacity,
          ),
          blurRadius: effectiveShadowBlur,
          spreadRadius:
              AppConstants.transparentOpacity,
          offset: Offset(
            AppConstants.transparentOpacity,
            shadowOffsetY * depthMultiplier,
          ),
        ),
    ];

    // =========================================================================
    // CLASSIC SB SHADOW
    // =========================================================================

    final List<BoxShadow>
        effectiveClassicSbShadows =
        isClassicSb &&
                effects.enableShadow &&
                shadowOpacity >
                    AppConstants.minShadowOpacity &&
                shadowBlur >
                    AppConstants.minShadowBlur
            ? <BoxShadow>[
                BoxShadow(
                  color:
                      AppConstants.black.withValues(
                    alpha: shadowOpacity,
                  ),
                  blurRadius: shadowBlur,
                  spreadRadius:
                      AppConstants.transparentOpacity,
                  offset: Offset(
                    AppConstants.transparentOpacity,
                    shadowOffsetY,
                  ),
                ),
              ]
            : <BoxShadow>[];

    // =========================================================================
    // CONTENT COLOR
    // =========================================================================

    final Color contentColor =
        isClassicSb
            ? AppConstants.white
            : surfaceStyle.forceLightText
                ? AppConstants.white.withValues(
                    alpha: disabledAlpha,
                  )
                : cfg.enabled
                    ? palette.textPrimary
                    : palette.textPrimary.withValues(
                        alpha:
                            AppConstants
                                .disabledContentOpacity,
                      );

    // =========================================================================
    // PADDING
    // =========================================================================

    final EdgeInsetsGeometry
        responsivePadding =
        surfaceStyle.getResponsivePadding(
      context: context,
      padding: padding,
      horizontalPadding:
          decoration.safeHorizontalPadding,
      verticalPadding:
          decoration.safeVerticalPadding,
    );

    // =========================================================================
    // BASE BORDER
    // =========================================================================

    final Border? resolvedBorder =
        _buildBorder(
      enabled: borderEnabled,
      width: borderWidth,
      color: borderColor,
    );

    // =========================================================================
    // CLASSIC SB
    // =========================================================================

    final BoxDecoration classicSbDecoration =
        GlassClassicSbDecoration.resolve(
      useAquaStyle: useAquaStyle,
      borderRadius: radius.topLeft.x,
    ).copyWith(
      border: resolvedBorder,
      boxShadow:
          effectiveClassicSbShadows,
    );

    // =========================================================================
    // TRANSPARENT / REAL GLASS
    // =========================================================================

    final double roleTintMultiplier =
        _getRoleTintMultiplier(role);

    final double topTintAlpha =
        (
          surfaceAlpha *
          roleTintMultiplier
        ).clamp(
          AppConstants.transparentOpacity,
          AppConstants.fullOpacity,
        ).toDouble();

    final double bottomTintFactor =
        role == GlassSurfaceRole.appBar
            ? AppConstants.appBarGlassBottomFactor
            : AppConstants.transparentGlassBottomFactor;

    final double bottomTintAlpha =
        (
          surfaceAlpha *
          bottomTintFactor *
          roleTintMultiplier
        ).clamp(
          AppConstants.transparentOpacity,
          AppConstants.fullOpacity,
        ).toDouble();

    // =========================================================================
    // FALLBACK TRANSPARENT GRADIENT
    // =========================================================================
    //
    // Utilisé uniquement lorsqu'aucun gradient réel n'a été résolu.
    //
    // Il conserve le comportement historique du glass transparent :
    // une teinte plus forte en haut et plus légère en bas.
    // =========================================================================

    final LinearGradient
        fallbackTransparentGradient =
        LinearGradient(
      begin: AppConstants.gradientBegin,
      end: AppConstants.gradientEnd,
      colors: <Color>[
        tintColor.withValues(
          alpha: topTintAlpha,
        ),
        tintColor.withValues(
          alpha: bottomTintAlpha,
        ),
      ],
    );

    // =========================================================================
    // TRANSPARENT GRADIENT
    // =========================================================================
    //
    // Priorité :
    //
    // 1. gradient personnalisé
    // 2. gradient chargé
    // 3. gradient du thème
    // 4. gradient du style
    // 5. fallback glass
    // =========================================================================

    final bool hasResolvedGradient =
        resolvedGradientColors.isNotEmpty;

    final LinearGradient?
        transparentGlassGradient =
        theme.enableGradient
            ? hasResolvedGradient
                ? LinearGradient(
                    begin:
                        AppConstants.gradientBegin,
                    end:
                        AppConstants.gradientEnd,
                    colors:
                        resolvedGradientColors,
                    stops:
                        gradientStops,
                  )
                : fallbackTransparentGradient
            : null;

    // =========================================================================
    // TRANSPARENT COLOR
    // =========================================================================

    final Color? transparentGlassColor =
        theme.enableGradient
            ? null
            : tintColor.withValues(
                alpha: surfaceAlpha,
              );

    // =========================================================================
    // TRANSPARENT DECORATION
    // =========================================================================

    final BoxDecoration
        transparentGlassDecoration =
        BoxDecoration(
      borderRadius: radius,
      color: transparentGlassColor,
      gradient: transparentGlassGradient,
      border: resolvedBorder,
      boxShadow: cardGlow,
    );

    // =========================================================================
    // OPAQUE / STANDARD
    // =========================================================================

    final Color? forcedBackgroundColor =
        cfg.backgroundColor;

    final BoxDecoration standardDecoration =
        BoxDecoration(
      gradient:
          resolvedGradientColors.isEmpty
              ? null
              : LinearGradient(
                  begin:
                      AppConstants
                          .gradientVerticalBegin,
                  end:
                      AppConstants
                          .gradientVerticalEnd,
                  colors:
                      resolvedGradientColors,
                  stops:
                      gradientStops,
                ),
      color:
          resolvedGradientColors.isEmpty
              ? forcedBackgroundColor != null
                  ? forcedBackgroundColor.withValues(
                      alpha: surfaceAlpha,
                    )
                  : primary.withValues(
                      alpha: surfaceAlpha,
                    )
              : null,
      borderRadius: radius,
      border: resolvedBorder,
      boxShadow: cardGlow,
    );

    // =========================================================================
    // FINAL DECORATION
    // =========================================================================

    final BoxDecoration finalDecoration =
        isClassicSb
            ? classicSbDecoration
            : isTransparentTinted
                ? transparentGlassDecoration
                : standardDecoration;

    // =========================================================================
    // CONTENT
    // =========================================================================

    final Widget baseContent =
        GlassContentStyle(
      decoration: decoration,
      contentColor: contentColor,
      child: child,
    );

    // =========================================================================
    // SURFACE
    // =========================================================================

    final Widget baseSurface =
        Container(
      width: width,
      height: height,
      constraints: constraints,
      decoration: finalDecoration,
      child: Padding(
        padding: responsivePadding,
        child: baseContent,
      ),
    );

    // =========================================================================
    // GLASS LAYERS
    // =========================================================================
    //
    // GlassSurfaceLayers gère uniquement :
    //
    // - BackdropFilter
    // - noise
    // - clipping
    //
    // La décoration de surface reste ici.
    // =========================================================================

    final Widget glassLayer =
        GlassSurfaceLayers(
      surface: baseSurface,
      radius: radius,
      blur: bgBlur,
      noise: bgNoise,
      clipBehavior: clipBehavior,
    );

    // =========================================================================
    // MATERIAL / INKWELL
    // =========================================================================

    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        onTap: cfg.enabled
            ? onTap
            : null,
        onHover: onHoverChanged,
        borderRadius: radius,
        excludeFromSemantics: false,
        child: glassLayer,
      ),
    );
  }
}
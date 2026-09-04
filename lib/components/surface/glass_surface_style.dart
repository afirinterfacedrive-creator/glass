import 'package:flutter/material.dart';

import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/provider/glass_theme_provider.dart';
import 'package:universal_glass/theme/glass_effects.dart';

class GlassSurfaceStyle {
  final GlassStyle style;

  const GlassSurfaceStyle(this.style);

  // ==========================================================================
  // TYPES DE STYLE
  // ==========================================================================

  bool get isGhost =>
      style == GlassStyle.ghost;

  bool get isOpaque =>
      style == GlassStyle.opaqueHeavy ||
      style == GlassStyle.opaqueMat;

  bool get isGradientOpaque =>
      style == GlassStyle.gradientOpaque;

  bool get isCustomGradient =>
      style == GlassStyle.customGradient;

  bool get isSageStyle =>
      style == GlassStyle.sage ||
      style == GlassStyle.sagePro ||
      style == GlassStyle.sageOled ||
      style == GlassStyle.sageGlass;

  bool get isClassicSb =>
      style == GlassStyle.classicSb;

  // ==========================================================================
  // ALPHA DE BASE DU STYLE
  // ==========================================================================
  //
  // Cette valeur représente l'identité visuelle du style.
  //
  // Elle ne remplace PAS surfaceOpacity du thème.
  // Les deux valeurs sont combinées dans le renderer.
  // ==========================================================================

  double get baseAlpha {
    switch (style) {
      case GlassStyle.opaqueHeavy:
        return 1.0;

      case GlassStyle.opaqueMat:
        return 0.95;

      case GlassStyle.gradientOpaque:
        return 1.0;

      case GlassStyle.customGradient:
        return 1.0;

      case GlassStyle.solidAqua:
        return 0.75;

      case GlassStyle.solidClassic:
        return 0.75;

      case GlassStyle.transparentAqua:
        return 0.15;

      case GlassStyle.ghost:
        return 0.03;

      case GlassStyle.sage:
        return 0.20;

      case GlassStyle.sagePro:
        return 0.30;

      case GlassStyle.sageOled:
        return 1.0;

      case GlassStyle.sageGlass:
        return 0.15;

      case GlassStyle.appBar:
        return 0.75;

      case GlassStyle.classicSb:
        return 0.95;

      case GlassStyle.custom:
        return 0.10;
    }
  }

  // ==========================================================================
  // BLUR
  // ==========================================================================

  double getBgBlur({
    required GlassEffects? effects,
    required GlassThemeState theme,
  }) {
    // Ghost = pas de blur.
    if (isGhost) {
      return 0.0;
    }

    // Sage historique : pas de blur.
    //
    // On conserve ici le comportement existant uniquement pour `sage`.
    // sagePro / sageOled / sageGlass peuvent utiliser le blur live.
    if (style == GlassStyle.sage) {
      return 0.0;
    }

    // Le thème est la source de vérité.
    //
    // effectiveBlur tient compte de enableBlur.
    return theme.effectiveBlur.clamp(0.0, 100.0);
  }

  // ==========================================================================
  // NOISE
  // ==========================================================================

  double getBgNoise({
    required GlassEffects? effects,
    required GlassThemeState theme,
  }) {
    if (isGhost) {
      return 0.0;
    }

    if (style == GlassStyle.sage) {
      return 0.0;
    }

    // Le thème est la source de vérité.
    //
    // effectiveNoise tient compte de enableNoise.
    return theme.effectiveNoise.clamp(0.0, 1.0);
  }

  // ==========================================================================
  // TEXTE
  // ==========================================================================

  bool get forceLightText =>
      isOpaque ||
      isGradientOpaque ||
      isCustomGradient ||
      isSageStyle ||
      style == GlassStyle.solidAqua ||
      isClassicSb;

  // ==========================================================================
  // DISABLED
  // ==========================================================================

  double getDisabledAlpha(bool enabled) {
    return enabled ? 1.0 : 0.45;
  }

  // ==========================================================================
  // PADDING RESPONSIVE
  // ==========================================================================

  EdgeInsetsGeometry getResponsivePadding({
    required BuildContext context,
    required EdgeInsetsGeometry? padding,
    required double horizontalPadding,
    required double verticalPadding,
  }) {
    if (padding != null) {
      return padding;
    }

    final double screenWidth =
        MediaQuery.sizeOf(context).width;

    final bool isSmallMobile =
        screenWidth < 375;

    return EdgeInsets.symmetric(
      horizontal: isSmallMobile
          ? horizontalPadding * 0.6
          : horizontalPadding,
      vertical: isSmallMobile
          ? verticalPadding * 0.6
          : verticalPadding,
    );
  }

  // ==========================================================================
  // GRADIENT ANIMÉ
  // ==========================================================================

  bool get hasAnimatedGradient => false;

  // ==========================================================================
  // HOVER
  // ==========================================================================

  bool shouldAnimateHover({
    required bool liftOnHover,
    required bool enabled,
  }) {
    if (!liftOnHover || !enabled) {
      return false;
    }

    if (isOpaque) {
      return false;
    }

    if (isGradientOpaque) {
      return false;
    }

    if (isCustomGradient) {
      return false;
    }

    if (isGhost) {
      return false;
    }

    if (isClassicSb) {
      return false;
    }

    return true;
  }
}
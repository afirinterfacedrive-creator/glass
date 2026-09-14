import 'package:flutter/material.dart';

import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/provider/glass_theme_state.dart';

/// Décrit la nature visuelle d'une surface Glass.
///
/// [GlassSurfaceStyle] définit l'identité visuelle du matériau.
///
/// [GlassSurfaceRole] définit le contexte d'utilisation.
///
/// Les deux notions sont volontairement séparées.
///
/// Exemple :
///
/// transparentAqua + card
/// transparentAqua + dialog
///
/// conservent la même identité Aqua, mais avec une densité,
/// un blur, une profondeur et un contraste différents.
class GlassSurfaceStyle {
  final GlassStyle style;

  const GlassSurfaceStyle(this.style);

  // ===========================================================================
  // IDENTITÉ DU STYLE
  // ===========================================================================

  /// Surface totalement ou fortement opaque.
  bool get isOpaque =>
      style == GlassStyle.opaqueHeavy ||
      style == GlassStyle.opaqueMat;

  /// Surface opaque avec dégradé.
  bool get isGradientOpaque => style == GlassStyle.gradientOpaque;

  /// Surface basée sur un dégradé personnalisé.
  bool get isCustomGradient => style == GlassStyle.customGradient;

  /// Surface translucide avec une teinte.
  bool get isTransparentTinted =>
      style == GlassStyle.transparentAqua ||
      style == GlassStyle.transparentRed ||
      style == GlassStyle.transparentGreen;

  /// Style Classic SB.
  ///
  /// Ce style reste volontairement dense et non translucide.
  bool get isClassicSb => style == GlassStyle.classicSb;

  /// Indique si le style participe au système Glass.
  ///
  /// Classic SB reste exclu du vrai Glass.
  bool get isGlass =>
      isTransparentTinted ||
      style == GlassStyle.custom;

  // ===========================================================================
  // ALPHA DE BASE
  // ===========================================================================

  /// Opacité intrinsèque du style.
  ///
  /// Cette valeur décrit uniquement le matériau.
  ///
  /// Elle ne prend pas encore en compte :
  /// - le rôle ;
  /// - l'opacité globale du thème ;
  /// - l'état disabled.
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
        return 0.08;

      case GlassStyle.transparentRed:
        return 0.08;

      case GlassStyle.transparentGreen:
        return 0.08;

      case GlassStyle.classicSb:
        return 0.95;

      case GlassStyle.custom:
        return 0.10;
    }
  }

  // ===========================================================================
  // DENSITÉ SELON LE RÔLE
  // ===========================================================================

  /// Multiplicateur d'opacité selon le rôle de la surface.
  ///
  /// Les éléments flottants et structurels sont volontairement
  /// plus denses que les cartes ordinaires.
  double getRoleAlphaMultiplier(GlassSurfaceRole role) {
    switch (role) {
      case GlassSurfaceRole.card:
        return 1.0;

      case GlassSurfaceRole.field:
        return 1.10;

      case GlassSurfaceRole.panel:
        return 1.20;

      case GlassSurfaceRole.header:
        return 1.25;

      case GlassSurfaceRole.body:
        return 1.15;

      case GlassSurfaceRole.footer:
        return 1.25;

      case GlassSurfaceRole.dialog:
        return 1.65;

      case GlassSurfaceRole.modal:
        return 1.80;

      case GlassSurfaceRole.tooltip:
        return 1.45;

      case GlassSurfaceRole.menu:
        return 1.50;

        case GlassSurfaceRole.appBar:
         return 1.27;
    }
  }

  /// Calcule l'opacité finale de la surface.
  double getEffectiveAlpha({
    required GlassSurfaceRole role,
    required double surfaceOpacity,
  }) {
    final double roleMultiplier = getRoleAlphaMultiplier(role);

    return (
      baseAlpha *
      roleMultiplier *
      surfaceOpacity.clamp(0.0, 1.0)
    ).clamp(0.0, 1.0);
  }

  // ===========================================================================
  // BLUR
  // ===========================================================================

  /// Multiplicateur de blur selon le rôle.
  double getRoleBlurMultiplier(GlassSurfaceRole role) {
    switch (role) {
      case GlassSurfaceRole.card:
        return 1.0;

      case GlassSurfaceRole.field:
        return 0.85;

      case GlassSurfaceRole.panel:
        return 1.10;

      case GlassSurfaceRole.header:
        return 1.15;

      case GlassSurfaceRole.body:
        return 1.05;

      case GlassSurfaceRole.footer:
        return 1.10;

      case GlassSurfaceRole.dialog:
        return 1.35;

      case GlassSurfaceRole.modal:
        return 1.45;

      case GlassSurfaceRole.tooltip:
        return 1.20;

      case GlassSurfaceRole.menu:
        return 1.25;

        case GlassSurfaceRole.appBar:
         return 1.00;
    }
  }

  /// Résout le blur final.
  ///
  /// Le thème reste la source globale du blur.
  /// Le rôle adapte ensuite son intensité.
  ///
  /// La responsabilité de [GlassEffects] reste dans le
  /// `GlassSurfaceContainer` / `GlassSurfaceRenderer`.
  ///
  /// Ici, [GlassSurfaceStyle] ne fait qu'adapter la valeur
  /// globale du thème au rôle de la surface.
  double getBgBlur({
    required GlassThemeState theme,
    GlassSurfaceRole role = GlassSurfaceRole.card,
  }) {
    if (!theme.enableBlur) {
      return 0.0;
    }

    final double themeBlur =
        theme.effectiveBlur.clamp(0.0, 100.0);

    if (themeBlur <= 0.0) {
      return 0.0;
    }

    final double multiplier =
        getRoleBlurMultiplier(role);

    return (
      themeBlur * multiplier
    ).clamp(0.0, 100.0);
  }

  // ===========================================================================
  // NOISE
  // ===========================================================================

  /// Multiplicateur de noise selon le rôle.
  double getRoleNoiseMultiplier(GlassSurfaceRole role) {
    switch (role) {
      case GlassSurfaceRole.card:
        return 1.0;

      case GlassSurfaceRole.field:
        return 0.75;

      case GlassSurfaceRole.panel:
        return 1.0;

      case GlassSurfaceRole.header:
        return 0.90;

      case GlassSurfaceRole.body:
        return 0.90;

      case GlassSurfaceRole.footer:
        return 0.90;

      case GlassSurfaceRole.dialog:
        return 0.85;

      case GlassSurfaceRole.modal:
        return 0.80;

      case GlassSurfaceRole.tooltip:
        return 0.75;

      case GlassSurfaceRole.menu:
        return 0.75;

        case GlassSurfaceRole.appBar:
         return 0.53;
    }
  }

  /// Résout le niveau de noise final.
  ///
  /// Le thème fournit l'intensité globale.
  /// Le rôle adapte ensuite cette intensité.
  double getBgNoise({
    required GlassThemeState theme,
    GlassSurfaceRole role = GlassSurfaceRole.card,
  }) {
    if (!theme.enableNoise) {
      return 0.0;
    }

    final double themeNoise =
        theme.effectiveNoise.clamp(0.0, 1.0);

    if (themeNoise <= 0.0) {
      return 0.0;
    }

    final double multiplier =
        getRoleNoiseMultiplier(role);

    return (
      themeNoise * multiplier
    ).clamp(0.0, 1.0);
  }

  // ===========================================================================
  // PROFONDEUR
  // ===========================================================================

  /// Multiplicateur de profondeur.
  ///
  /// Utilisé par le renderer pour renforcer :
  /// - l'ombre ;
  /// - le glow ;
  /// - les reflets ;
  /// - la séparation visuelle.
  double getRoleDepthMultiplier(GlassSurfaceRole role) {
    switch (role) {
      case GlassSurfaceRole.card:
        return 1.0;

      case GlassSurfaceRole.field:
        return 0.75;

      case GlassSurfaceRole.panel:
        return 1.10;

      case GlassSurfaceRole.header:
        return 1.10;

      case GlassSurfaceRole.body:
        return 1.0;

      case GlassSurfaceRole.footer:
        return 1.10;

      case GlassSurfaceRole.dialog:
        return 1.45;

      case GlassSurfaceRole.modal:
        return 1.60;

      case GlassSurfaceRole.tooltip:
        return 1.20;

      case GlassSurfaceRole.menu:
        return 1.25;

        case GlassSurfaceRole.appBar:
         return 1.00;
    }
  }

  // ===========================================================================
  // CONTRASTE
  // ===========================================================================

  /// Multiplicateur de contraste visuel.
  ///
  /// Les surfaces flottantes obtiennent davantage de séparation
  /// avec l'arrière-plan.
  double getRoleContrastMultiplier(GlassSurfaceRole role) {
    switch (role) {
      case GlassSurfaceRole.card:
        return 1.0;

      case GlassSurfaceRole.field:
        return 1.05;

      case GlassSurfaceRole.panel:
        return 1.10;

      case GlassSurfaceRole.header:
        return 1.10;

      case GlassSurfaceRole.body:
        return 1.05;

      case GlassSurfaceRole.footer:
        return 1.10;

      case GlassSurfaceRole.dialog:
        return 1.30;

      case GlassSurfaceRole.modal:
        return 1.40;

      case GlassSurfaceRole.tooltip:
        return 1.20;

      case GlassSurfaceRole.menu:
        return 1.25;

        case GlassSurfaceRole.appBar:
         return 1.00;
    }
  }

  // ===========================================================================
  // TEXTE
  // ===========================================================================

  /// Indique si le contenu doit privilégier un texte clair.
  bool get forceLightText =>
      isOpaque ||
      isGradientOpaque ||
      isCustomGradient ||
      style == GlassStyle.solidAqua ||
      isClassicSb;

  // ===========================================================================
  // ÉTAT DISABLED
  // ===========================================================================

  /// Alpha appliqué à une surface désactivée.
  double getDisabledAlpha(bool enabled) {
    return enabled ? 1.0 : 0.45;
  }

  // ===========================================================================
  // PADDING RESPONSIVE
  // ===========================================================================

  /// Résout le padding en tenant compte des petits écrans.
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
        screenWidth < 375.0;

    return EdgeInsets.symmetric(
      horizontal: isSmallMobile
          ? horizontalPadding * 0.6
          : horizontalPadding,
      vertical: isSmallMobile
          ? verticalPadding * 0.6
          : verticalPadding,
    );
  }

  // ===========================================================================
  // ANIMATION
  // ===========================================================================

  /// Indique si le style possède un gradient animé.
  ///
  /// Réservé à une future implémentation de gradient dynamique.
  bool get hasAnimatedGradient => false;

  /// Indique si le hover peut être animé.
  bool shouldAnimateHover({
    required bool liftOnHover,
    required bool enabled,
  }) {
    if (!liftOnHover || !enabled) {
      return false;
    }

    // Les surfaces opaques et Classic SB ne participent
    // pas au comportement de hover du vrai Glass.
    if (isOpaque ||
        isGradientOpaque ||
        isCustomGradient ||
        isClassicSb) {
      return false;
    }

    return true;
  }
}
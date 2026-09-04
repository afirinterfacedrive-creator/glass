import 'package:flutter/material.dart';
import 'package:universal_glass/glass.dart';

class GlassStyleGalleryHelpers {
  const GlassStyleGalleryHelpers._();

  static String getStyleNameFormatted(GlassStyle style) {
    final String name = style.name;

    final String spaced = name.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (Match match) => ' ${match.group(0)}',
    );

    if (spaced.isEmpty) {
      return spaced;
    }

    return spaced.substring(0, 1).toUpperCase() +
        spaced.substring(1);
  }

  static String getStyleDescription(GlassStyle style) {
    switch (style) {
      case GlassStyle.opaqueMat:
        return '95% opaque. Idéal pour fiches et panneaux.';

      case GlassStyle.opaqueHeavy:
        return '98% opaque. Bloque fortement les calques arrière.';

      case GlassStyle.gradientOpaque:
        return 'Dégradé solide sans translucidité.';

      case GlassStyle.customGradient:
        return 'Dégradé utilisateur injecté.';

      case GlassStyle.transparentAqua:
        return '8% opaque, cristallin, avec reflets cyan.';

      case GlassStyle.ghost:
        return '3% opaque, ultra-discret. Idéal pour les inputs.';

      case GlassStyle.solidAqua:
        return '75% opaque, teinté cyan dynamique.';

      case GlassStyle.solidClassic:
        return '75% opaque, blanc/gris classique.';

      case GlassStyle.sage:
        return 'Noir 20% + rouge KDTV. Base professionnelle.';

      case GlassStyle.sagePro:
        return 'Noir 30% + bordure rouge + glow animé.';

      case GlassStyle.sageOled:
        return 'Noir pur #000000. Optimisé OLED.';

      case GlassStyle.sageGlass:
        return 'Noir 15%, effet miroir + rouge animé.';

      case GlassStyle.appBar:
        return 'Barre de navigation haute adaptative.';

       case GlassStyle.classicSb:
      return 'Dégradé asymétrique "Welcome Card". Toggle Aqua/Classic dispo.';

      case GlassStyle.custom:
        return 'Dégradé custom de bienvenue.';
    }
  }

  static IconData getStyleIcon(GlassStyle style) {
    if (style.name.contains('sage')) {
      return Icons.eco_rounded;
    }

    if (style.name.contains('opaque') ||
        style.name.contains('solid')) {
      return Icons.layers_rounded;
    }

    if (style == GlassStyle.classicSb) {
      return Icons.rectangle_rounded;
    }

    if (style == GlassStyle.appBar) {
      return Icons.vertical_split_rounded;
    }

    if (style == GlassStyle.ghost) {
      return Icons.visibility_off_rounded;
    }

    if (style == GlassStyle.customGradient) {
      return Icons.gradient_rounded;
    }

    if (style == GlassStyle.transparentAqua) {
      return Icons.water_drop_rounded;
    }

    return Icons.blur_on_rounded;
  }
}
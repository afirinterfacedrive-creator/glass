import 'package:flutter/material.dart';
import 'package:universal_glass/glass.dart';

class GlassStyleGalleryHelpers {
  const GlassStyleGalleryHelpers._();

  // ==========================================================================
  // NOM DU STYLE
  // ==========================================================================

  static String getStyleNameFormatted(GlassStyle style) {
    switch (style) {
      case GlassStyle.opaqueMat:
        return 'Opaque Mat';

      case GlassStyle.gradientOpaque:
        return 'Gradient Opaque';

      case GlassStyle.customGradient:
        return 'Custom Gradient';

      case GlassStyle.solidAqua:
        return 'Solid Aqua';

      case GlassStyle.solidClassic:
        return 'Solid Classic';

      case GlassStyle.opaqueHeavy:
        return 'Opaque Heavy';

      case GlassStyle.transparentAqua:
        return 'Transparent Aqua';

      case GlassStyle.transparentRed:
        return 'Transparent Red';

      case GlassStyle.transparentGreen:
        return 'Transparent Green';

      case GlassStyle.classicSb:
        return 'Classic SB';

      case GlassStyle.custom:
        return 'Custom';
    }
  }

  // ==========================================================================
  // DESCRIPTION
  // ==========================================================================

  static String getStyleDescription(GlassStyle style) {
    switch (style) {
      case GlassStyle.opaqueMat:
        return 'Surface opaque et mate. Idéale pour fiches, sheets et panneaux.';

      case GlassStyle.gradientOpaque:
        return 'Surface opaque avec un dégradé riche et structuré.';

      case GlassStyle.customGradient:
        return 'Dégradé personnalisé contrôlé directement par la palette utilisateur.';

      case GlassStyle.solidAqua:
        return 'Surface Aqua semi-opaque avec une teinte cyan dynamique.';

      case GlassStyle.solidClassic:
        return 'Surface Classic semi-opaque avec une apparence sobre et élégante.';

      case GlassStyle.opaqueHeavy:
        return 'Surface fortement opaque qui bloque presque totalement les calques arrière.';

      case GlassStyle.transparentAqua:
        return 'Surface cristalline translucide avec une signature Aqua et des reflets cyan.';

      case GlassStyle.transparentRed:
        return 'Surface translucide teintée rouge, idéale pour les actions critiques.';

      case GlassStyle.transparentGreen:
        return 'Surface translucide teintée verte, idéale pour les validations et succès.';

      case GlassStyle.classicSb:
        return 'Dégradé asymétrique Classic SB conçu pour les cartes et surfaces principales.';

      case GlassStyle.custom:
        return 'Style entièrement personnalisable via les effets et paramètres Universal Glass.';
    }
  }

  // ==========================================================================
  // ICÔNE
  // ==========================================================================

  static IconData getStyleIcon(GlassStyle style) {
    switch (style) {
      case GlassStyle.opaqueMat:
        return Icons.layers_rounded;

      case GlassStyle.gradientOpaque:
        return Icons.gradient_rounded;

      case GlassStyle.customGradient:
        return Icons.auto_awesome_rounded;

      case GlassStyle.solidAqua:
        return Icons.water_rounded;

      case GlassStyle.solidClassic:
        return Icons.layers_rounded;

      case GlassStyle.opaqueHeavy:
        return Icons.layers_clear_rounded;

      case GlassStyle.transparentAqua:
        return Icons.water_drop_rounded;

      case GlassStyle.transparentRed:
        return Icons.delete_forever_rounded;

      case GlassStyle.transparentGreen:
        return Icons.check_circle_rounded;

      case GlassStyle.classicSb:
        return Icons.view_quilt_rounded;

      case GlassStyle.custom:
        return Icons.tune_rounded;
    }
  }
}
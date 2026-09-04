
import 'package:flutter_riverpod/legacy.dart';

import '../theme/glass_color_palette.dart';
import 'glass_color_provider.dart';

// ============================================================================
// GLASS COLOR PROVIDER
// ============================================================================
//
// Provider Riverpod de la palette Universal Glass.
//
// Architecture :
//
// Riverpod
//    │
//    └── glassColorProvider
//           │
//           └── GlassColorProvider
//                    │
//                    └── GlassColorPalette
//
// IMPORTANT
//
// GlassColorProvider reste un ChangeNotifier.
//
// Riverpod observe automatiquement les notifyListeners().
//
// ============================================================================

final glassColorProvider =
    ChangeNotifierProvider<GlassColorProvider>(
  (ref) {
    final GlassColorProvider provider =
        GlassColorProvider(
      initialPalette:
          GlassColorPalette.defaults(),
    );

    // ------------------------------------------------------------------------
    // CHARGEMENT DE LA PALETTE SAUVEGARDÉE
    // ------------------------------------------------------------------------
    //
    // load() restaure :
    //
    // - le preset
    // - les couleurs personnalisées
    //
    // Le provider est immédiatement disponible avec defaults(),
    // puis est mis à jour lorsque load() termine.
    //
    provider.load();

    return provider;
  },
);
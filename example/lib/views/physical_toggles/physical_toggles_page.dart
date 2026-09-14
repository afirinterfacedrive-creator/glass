import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/glass.dart';

import 'sections/physical_toggles_section.dart';

// ============================================================================
// PHYSICAL TOGGLES PAGE
// ============================================================================
//
// Page dédiée aux contrôles physiques.
//
// ============================================================================

class PhysicalTogglesPage extends ConsumerWidget {
  const PhysicalTogglesPage({super.key});

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    // =========================================================================
    // THÈME GLASS - WATCH POUR REBUILD LIVE
    // =========================================================================
    final GlassThemeState theme = ref.watch(glassThemeProvider);

    // =========================================================================
    // COLOR PROVIDER
    // =========================================================================
    final GlassColorProvider colorProvider = ref.watch(glassColorProvider);

    // =========================================================================
    // PALETTE
    // =========================================================================
    final GlassColorPalette palette = colorProvider.palette;

    // =========================================================================
    // SCAFFOLD
    // =========================================================================
    return GlassScaffold(
      title: 'Physical Toggles',
      subtitle: 'HARDWARE CONTROLS',
      showLogo: true,
      showBackButton: true,
      hideNavigation: true,

      
      blur: theme.blur,   // <-- AJOUT
      noise: theme.noise, // <-- AJOUT

      // =======================================================================
      // CONTENU
      // =======================================================================
      child: PhysicalTogglesSection(
        theme: theme,
        palette: palette,
      ),
    );
  }
}
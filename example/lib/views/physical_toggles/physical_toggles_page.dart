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
// Architecture:
//
// GlassScaffold
//      │
//      ▼
// PhysicalTogglesSection
//      │
//      ▼
// PhysicalToggleRegistry
//      │
//      ▼
// PhysicalToggleItem
//      │
//      ▼
// PhysicalToggleCard
//
// ============================================================================

class PhysicalTogglesPage extends ConsumerWidget {
  const PhysicalTogglesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // =========================================================================
    // THÈME GLASS
    // =========================================================================

    final GlassThemeState theme = ref.watch(glassThemeProvider);

    // =========================================================================
    // SCAFFOLD
    // =========================================================================

    return GlassScaffold(
      title: 'Physical Toggles',
      subtitle: 'HARDWARE CONTROLS',
      showLogo: true,
      showBackButton: true,
      hideNavigation: true,
      child: PhysicalTogglesSection(theme: theme),
    );
  }
}

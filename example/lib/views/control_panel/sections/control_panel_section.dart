
import 'package:flutter/material.dart';

import 'package:universal_glass/glass.dart';

import 'package:universal_glass_example/views/physical_toggles/sections/physical_toggles_section.dart';

import '../widgets/control_panel_section_title.dart';
import '../widgets/control_panel_theme_card.dart';

// ============================================================================
// CONTROL PANEL SECTION
// ============================================================================
//
// Section principale des contrôles Glass.
//
// ARCHITECTURE
//
// ControlPanelSection
//       │
//       ├── GLASS CONTROLS
//       │      │
//       │      └── ControlPanelThemeCard
//       │             ├── GlassThemeState
//       │             └── GlassColorPalette
//       │
//       └── PHYSICAL CONTROLS
//              │
//              └── PhysicalTogglesSection
//                     ├── GlassThemeState
//                     └── GlassColorPalette
//
// ============================================================================
//
// RESPONSABILITÉS
//
// - afficher les contrôles Glass
// - recevoir le thème Glass
// - recevoir la palette Glass
// - transmettre les données aux composants enfants
// - afficher la section Physical Toggles
// - gérer uniquement la disposition générale
//
// ============================================================================
//
// NE GÈRE PAS
//
// - Riverpod
// - navigation
// - GlassScaffold
// - AppBar
// - logique des Physical Toggles
// - logique du thème
// - création de la palette
// - création des effets Glass
//
// ============================================================================

class ControlPanelSection extends StatelessWidget {
  // ==========================================================================
  // THÈME
  // ==========================================================================

  final GlassThemeState theme;

  // ==========================================================================
  // PALETTE
  // ==========================================================================

  final GlassColorPalette palette;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const ControlPanelSection({
    super.key,
    required this.theme,
    required this.palette,
  });

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (
        BuildContext context,
        BoxConstraints constraints,
      ) {
        final double width = constraints.maxWidth;

        final bool compact = width < 600;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =================================================================
            // GLASS CONTROLS
            // =================================================================

            ControlPanelSectionTitle(
              theme: theme,
              title: 'GLASS CONTROLS',
              description:
                  'Contrôlez l’apparence et les effets '
                  'visuels de votre interface.',
            ),

            SizedBox(
              height: compact ? 16 : 18,
            ),

            // =================================================================
            // THEME CARD
            // =================================================================

            Wrap(
              spacing: compact ? 14 : 20,
              runSpacing: compact ? 14 : 20,
              children: [
                ControlPanelThemeCard(
                  theme: theme,
                  palette: palette,
                ),
              ],
            ),

            // =================================================================
            // ESPACEMENT
            // =================================================================

            SizedBox(
              height: compact ? 30 : 36,
            ),

            // =================================================================
            // PHYSICAL TOGGLES
            // =================================================================
            //
            // IMPORTANT :
            //
            // La palette doit être transmise à PhysicalTogglesSection.
            //
            // =================================================================

            PhysicalTogglesSection(
              theme: theme,
              palette: palette,
            ),
          ],
        );
      },
    );
  }
}


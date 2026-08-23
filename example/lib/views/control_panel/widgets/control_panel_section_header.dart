import 'package:flutter/material.dart';

import 'package:glass/glass.dart';

// ============================================================================
// CONTROL PANEL SECTION HEADER
// ============================================================================
//
// Header de la section principale du Control Panel.
//
// Responsabilités :
//
// - titre
// - description
// - couleur d'accent selon le thème
//
// ============================================================================

class ControlPanelSectionHeader extends StatelessWidget {
  final GlassThemeState theme;

  const ControlPanelSectionHeader({super.key, required this.theme});

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    final Color accent = theme.useAquaStyle
        ? Colors.cyanAccent
        : Colors.orangeAccent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        // =====================================================================
        // TITRE
        // =====================================================================
        Text(
          'GLASS CONTROLS',

          style: TextStyle(
            color: accent,

            fontSize: 13,

            fontWeight: FontWeight.bold,

            letterSpacing: 1.4,
          ),
        ),

        const SizedBox(height: 6),

        // =====================================================================
        // DESCRIPTION
        // =====================================================================
        const Text(
          'Contrôlez l’apparence et les effets '
          'visuels de votre interface.',

          style: TextStyle(color: Colors.white54, fontSize: 12, height: 1.4),
        ),
      ],
    );
  }
}

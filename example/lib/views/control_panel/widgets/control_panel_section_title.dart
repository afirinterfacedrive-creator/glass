import 'package:flutter/material.dart';

import 'package:universal_glass/glass.dart';

// ============================================================================
// CONTROL PANEL SECTION TITLE
// ============================================================================
//
// En-tête réutilisable pour les sections du Control Panel.
//
// ============================================================================

class ControlPanelSectionTitle extends StatelessWidget {
  final GlassThemeState theme;

  final String title;

  final String description;

  const ControlPanelSectionTitle({
    super.key,
    required this.theme,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final Color accent = theme.useAquaStyle
        ? Colors.cyanAccent
        : Colors.orangeAccent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: accent,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.4,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          description,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import 'package:universal_glass/glass.dart';

// ============================================================================
// HOME THEME INDICATOR
// ============================================================================
//
// Petit indicateur affiché dans les actions du UniversalAppBar.
//
// Affiche :
//
// AQUA
// ou
// MATTE
//
// ============================================================================

class HomeThemeIndicator extends StatelessWidget {
  final GlassThemeState theme;

  const HomeThemeIndicator({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    final Color accent = theme.useAquaStyle
        ? Colors.cyanAccent
        : Colors.orangeAccent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),

        color: accent.withValues(alpha: .08),

        border: Border.all(color: accent.withValues(alpha: .16)),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(
            theme.useAquaStyle ? Icons.opacity : Icons.layers_clear,

            size: 14,

            color: accent,
          ),

          const SizedBox(width: 6),

          Text(
            theme.useAquaStyle ? 'AQUA' : 'MATTE',

            style: TextStyle(
              color: accent,

              fontSize: 9,

              fontWeight: FontWeight.bold,

              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

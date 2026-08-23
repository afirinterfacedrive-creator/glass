import 'package:flutter/material.dart';

// ============================================================================
// PANEL HEADER
// ============================================================================
//
// En-tête générique d'un panneau.
//
// Responsabilités :
//
// - afficher un titre
// - afficher éventuellement un sous-titre
// - afficher éventuellement une action à droite
//
// NE gère PAS :
//
// - Riverpod
// - le thème global
// - le toggle Aqua
// - GlassBreakerSwitch
// - la navigation
// - les Physical Toggles
//
// Le changement de thème Aqua est maintenant géré dans SettingsPage.
//
// ============================================================================

class PanelHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const PanelHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ====================================================================
        // TITRE
        // ====================================================================
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 10, color: Colors.black26)],
                ),
              ),

              if (subtitle != null) ...[
                const SizedBox(height: 5),

                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ],
          ),
        ),

        // ====================================================================
        // ACTION À DROITE
        // ====================================================================
        if (trailing != null) ...[const SizedBox(width: 16), trailing!],
      ],
    );
  }
}

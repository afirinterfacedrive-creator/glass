import 'package:flutter/material.dart';

// ============================================================================
// PHYSICAL TOGGLE HEADER
// ============================================================================
//
// Header générique d'un contrôle Glass.
//
// RESPONSABILITÉS
//
// - afficher l'icône
// - afficher le titre
// - afficher la description
// - gérer l'animation visuelle de l'état
//
// NE GÈRE PAS
//
// - état métier
// - callback
// - Riverpod
// - navigation
// - type du toggle
//
// ============================================================================

class PhysicalToggleHeader extends StatelessWidget {
  // ==========================================================================
  // INFORMATIONS
  // ==========================================================================

  final String title;
  final String subtitle;
  final IconData icon;

  // ==========================================================================
  // ÉTAT
  // ==========================================================================

  final bool value;

  // ==========================================================================
  // ACCENT
  // ==========================================================================

  final Color accent;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const PhysicalToggleHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.accent,
  });

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          // ===================================================================
          // ICÔNE
          // ===================================================================
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,

            width: 44,
            height: 44,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: accent.withValues(alpha: value ? .14 : .06),

              border: Border.all(
                color: accent.withValues(alpha: value ? .32 : .14),
              ),

              boxShadow: value
                  ? [
                      BoxShadow(
                        color: accent.withValues(alpha: .18),
                        blurRadius: 12,
                      ),
                    ]
                  : null,
            ),

            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),

              child: Icon(
                icon,
                key: ValueKey<bool>(value),
                color: value ? accent : Colors.white54,
                size: 21,
              ),
            ),
          ),

          const SizedBox(width: 10),

          // ===================================================================
          // TITRE + DESCRIPTION
          // ===================================================================
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 11,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

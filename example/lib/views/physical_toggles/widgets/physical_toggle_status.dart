import 'package:flutter/material.dart';

// ============================================================================
// PHYSICAL TOGGLE STATUS
// ============================================================================
//
// Indicateur générique de l'état d'un contrôle.
//
// RESPONSABILITÉS
//
// - afficher le voyant
// - afficher ACTIVE / INACTIVE
// - animer le changement d'état
//
// NE GÈRE PAS
//
// - état métier
// - callback
// - Riverpod
// - logique du toggle
//
// ============================================================================

class PhysicalToggleStatus extends StatelessWidget {
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

  const PhysicalToggleStatus({
    super.key,
    required this.value,
    required this.accent,
  });

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),

        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: .90, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
              ),
              child: child,
            ),
          );
        },

        child: Row(
          key: ValueKey<bool>(value),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // =================================================================
            // VOYANT
            // =================================================================
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),

              width: 7,
              height: 7,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                color: value ? accent : Colors.white38,

                boxShadow: value
                    ? [
                        BoxShadow(
                          color: accent.withValues(alpha: .55),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
            ),

            const SizedBox(width: 7),

            // =================================================================
            // TEXTE
            // =================================================================
            Text(
              value ? 'ACTIVE' : 'INACTIVE',

              style: TextStyle(
                color: value ? accent : Colors.white38,

                fontSize: 10,

                fontWeight: FontWeight.bold,

                letterSpacing: 1.2,

                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

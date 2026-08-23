import 'package:flutter/material.dart';

import 'package:universal_glass/glass.dart';

// ============================================================================
// HOME STATUS CARD
// ============================================================================
//
// Carte indiquant l'état d'un élément système.
//
// Exemple :
//
// Glass Engine     ● Ready
// Storage          ● Available
// System           ● Online
//
// ============================================================================

class HomeStatusCard extends StatelessWidget {
  final GlassThemeState theme;

  final IconData icon;

  final String title;

  final String value;

  final bool active;

  const HomeStatusCard({
    super.key,
    required this.theme,
    required this.icon,
    required this.title,
    required this.value,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    final Color accent = theme.useAquaStyle
        ? Colors.cyanAccent
        : Colors.orangeAccent;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),

      width: 250,

      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),

        color: Colors.white.withValues(alpha: .055),

        border: Border.all(
          color: active
              ? accent.withValues(alpha: .12)
              : Colors.white.withValues(alpha: .10),
        ),
      ),

      child: Row(
        children: [
          // ==================================================================
          // ICÔNE
          // ==================================================================
          Container(
            width: 40,

            height: 40,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: active
                  ? accent.withValues(alpha: .10)
                  : Colors.white.withValues(alpha: .06),
            ),

            child: Icon(
              icon,

              size: 20,

              color: active ? accent : Colors.white38,
            ),
          ),

          const SizedBox(width: 12),

          // ==================================================================
          // TEXTE
          // ==================================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(color: Colors.white60, fontSize: 11),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    // ==========================================================
                    // INDICATEUR
                    // ==========================================================
                    Container(
                      width: 7,

                      height: 7,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        color: active ? accent : Colors.white30,

                        boxShadow: active
                            ? [
                                BoxShadow(
                                  color: accent.withValues(alpha: .45),

                                  blurRadius: 7,
                                ),
                              ]
                            : null,
                      ),
                    ),

                    const SizedBox(width: 6),

                    // ==========================================================
                    // VALEUR
                    // ==========================================================
                    Text(
                      value,

                      style: TextStyle(
                        color: active ? Colors.white : Colors.white38,

                        fontSize: 12,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

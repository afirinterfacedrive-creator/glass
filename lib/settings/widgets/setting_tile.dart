import 'package:flutter/material.dart';

// ============================================================================
// SETTING TILE
// ============================================================================
//
// Élément générique d'un réglage.
//
// Responsabilités :
//
// - icône
// - titre
// - sous-titre
// - action
// - hover
// - splash
//
// Ne connaît pas Riverpod.
//
// ============================================================================

class SettingTile extends StatelessWidget {
  final IconData icon;

  final Color iconColor;

  final String title;

  final String subtitle;

  final Widget trailing;

  final VoidCallback? onTap;

  const SettingTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius: BorderRadius.circular(18),

        hoverColor: Colors.white.withValues(alpha: .035),

        splashColor: iconColor.withValues(alpha: .08),

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

          child: Row(
            children: [
              // =================================================================
              // ICÔNE
              // =================================================================
              Container(
                width: 42,
                height: 42,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color: iconColor.withValues(alpha: .08),

                  border: Border.all(color: iconColor.withValues(alpha: .16)),
                ),

                child: Icon(icon, color: iconColor, size: 20),
              ),

              const SizedBox(width: 14),

              // =================================================================
              // TEXTE
              // =================================================================
              Expanded(
                child: Column(
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
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,

                      maxLines: 2,

                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // =================================================================
              // ACTION
              // =================================================================
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}

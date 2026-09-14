import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/glass.dart';

// ============================================================================
// HOME STATUS CARD
// ============================================================================

class HomeStatusCard extends ConsumerWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool active;
  final Color? iconColor;

  const HomeStatusCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.active,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlassLayoutContext glass = GlassLayoutScope.of(context);

    // FIX: Utilise iconColor si fourni, sinon prend l'accent du theme
    final Color accent = iconColor ?? glass.palette.accent;

    return GlassSurfaceContainer(
      style: glass.effectiveGlassStyle, // <- COMME UniversalGlassTextBoxView
      effects: glass.effects,
      borderRadius: BorderRadius.circular(glass.isSmallMobile ? 14 : 16),
      padding: EdgeInsets.symmetric(
        horizontal: glass.isSmallMobile ? 12 : 16,
        vertical: glass.isSmallMobile ? 10 : 12,
      ),
      liftOnHover: glass.theme.enableHover,
      child: Row(
        children: [
          // ==================================================================
          // ICÔNE
          // ==================================================================
          Container(
            width: glass.isSmallMobile ? 36 : 40,
            height: glass.isSmallMobile ? 36 : 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active
                  ? accent.withValues(alpha: .15)
                  : Colors.white.withValues(alpha: .06),
            ),
            child: Icon(
              icon,
              size: glass.isSmallMobile ? 18 : 20,
              color: active ? accent : Colors.white38,
            ),
          ),

          SizedBox(width: glass.isSmallMobile ? 10 : 12),

          // ==================================================================
          // TEXTE
          // ==================================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GlassText(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  fontSize: glass.isSmallMobile ? 10 : 11,
                  alpha: 0.6,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    // INDICATEUR LUMINEUX
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: active ? accent : Colors.white30,
                        boxShadow: active
                            ? [
                                BoxShadow(
                                  color: accent.withValues(alpha: .45),
                                  blurRadius: 6,
                                ),
                              ]
                            : null,
                      ),
                    ),
                    const SizedBox(width: 6),

                    // VALEUR
                    Expanded(
                      child: GlassText(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        fontSize: glass.isSmallMobile ? 11 : 12,
                        fontWeight: FontWeight.bold,
                        alpha: active ? 1.0 : 0.38,
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
